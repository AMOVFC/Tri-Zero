#!/usr/bin/env python3
import json
import time
from pathlib import Path

import board
import busio
import requests
from PIL import Image, ImageDraw, ImageFont

import adafruit_ssd1306
from adafruit_bme280 import basic as adafruit_bme280
import adafruit_sgp40
import paho.mqtt.client as mqtt


OLED_WIDTH = 128
OLED_HEIGHT = 64
OLED_ADDR = 0x3C
BME280_ADDR = 0x77
LOOP_SECONDS = 2.0

MOONRAKER_URL = "http://127.0.0.1:7125/printer/gcode/script"
MOONRAKER_TIMEOUT = 2.0

MQTT_HOST = "127.0.0.1"
MQTT_PORT = 1883
MQTT_TOPIC = "printer/air_monitor/state"

OUT_DIR = Path("/tmp/printer_air_monitor")
OUT_DIR.mkdir(parents=True, exist_ok=True)
STATUS_FILE = OUT_DIR / "status.txt"
CSV_FILE = OUT_DIR / "history.csv"

VOC_LOW_ON = 70
VOC_MED_ON = 110
VOC_HIGH_ON = 150

VOC_LOW_OFF = 45
VOC_MED_OFF = 90
VOC_HIGH_OFF = 130


def mqtt_connect():
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    client.connect(MQTT_HOST, MQTT_PORT, 60)
    client.loop_start()
    return client


def publish_state(client, temp_c, humidity, pressure_hpa, voc):
    payload = {
        "temperature": round(temp_c, 2),
        "humidity": round(humidity, 2),
        "pressure": round(pressure_hpa, 2),
        "voc_index": int(voc),
        "timestamp": int(time.time()),
    }
    info = client.publish(MQTT_TOPIC, json.dumps(payload), qos=0, retain=False)
    info.wait_for_publish()


def load_fonts():
    try:
        big = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 18)
        small = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 10)
    except Exception:
        big = ImageFont.load_default()
        small = ImageFont.load_default()
    return big, small


def draw_screen(display, big_font, small_font, temp_c, humidity, voc, fan_percent):
    image = Image.new("1", (OLED_WIDTH, OLED_HEIGHT))
    draw = ImageDraw.Draw(image)

    draw.rectangle((0, 0, OLED_WIDTH, OLED_HEIGHT), fill=0)
    draw.text((0, 0), f"T {temp_c:4.1f}C", font=big_font, fill=255)
    draw.text((0, 22), f"VOC {voc:4d}", font=big_font, fill=255)
    draw.text((0, 54), f"RH {humidity:4.1f}%  FAN {fan_percent:3d}%", font=small_font, fill=255)

    display.image(image)
    display.show()


def write_status(temp_c, humidity, pressure_hpa, voc, fan_speed, status):
    STATUS_FILE.write_text(
        "\n".join(
            [
                f"temperature_c={temp_c:.2f}",
                f"humidity_rh={humidity:.2f}",
                f"pressure_hpa={pressure_hpa:.2f}",
                f"voc_index={voc}",
                f"fan_speed={fan_speed:.2f}",
                f"status={status}",
                f"timestamp={int(time.time())}",
            ]
        ) + "\n",
        encoding="utf-8",
    )


def append_csv(temp_c, humidity, pressure_hpa, voc, fan_speed):
    if not CSV_FILE.exists():
        CSV_FILE.write_text(
            "timestamp,temperature_c,humidity_rh,pressure_hpa,voc_index,fan_speed\n",
            encoding="utf-8",
        )

    with CSV_FILE.open("a", encoding="utf-8") as f:
        f.write(
            f"{int(time.time())},{temp_c:.2f},{humidity:.2f},{pressure_hpa:.2f},{voc},{fan_speed:.2f}\n"
        )


def send_gcode(script: str):
    requests.post(
        MOONRAKER_URL,
        json={"script": script},
        timeout=MOONRAKER_TIMEOUT,
    ).raise_for_status()


def set_nevermore_speed(speed: float):
    speed = max(0.0, min(1.0, speed))
    send_gcode(f"SET_FAN_SPEED FAN=nevermore SPEED={speed:.2f}")


def next_fan_speed(voc: int, current_speed: float) -> float:
    if current_speed >= 0.99:
        if voc <= VOC_HIGH_OFF:
            return 0.70
        return 1.00

    if current_speed >= 0.69:
        if voc >= VOC_HIGH_ON:
            return 1.00
        if voc <= VOC_MED_OFF:
            return 0.35
        return 0.70

    if current_speed >= 0.34:
        if voc >= VOC_HIGH_ON:
            return 1.00
        if voc >= VOC_MED_ON:
            return 0.70
        if voc <= VOC_LOW_OFF:
            return 0.00
        return 0.35

    if voc >= VOC_HIGH_ON:
        return 1.00
    if voc >= VOC_MED_ON:
        return 0.70
    if voc >= VOC_LOW_ON:
        return 0.35
    return 0.00


def read_bme280(bme280):
    temp_c = float(bme280.temperature)
    humidity = float(bme280.relative_humidity)
    pressure_hpa = float(bme280.pressure)
    return temp_c, humidity, pressure_hpa


def read_sgp40_with_retry(sgp40, temp_c, humidity, retries=3, delay=0.25):
    last_error = None
    for _ in range(retries):
        try:
            return int(sgp40.measure_index(temperature=temp_c, relative_humidity=humidity))
        except OSError as e:
            last_error = e
            time.sleep(delay)
    raise last_error


def main():
    i2c = busio.I2C(board.SCL, board.SDA)

    display = adafruit_ssd1306.SSD1306_I2C(
        OLED_WIDTH,
        OLED_HEIGHT,
        i2c,
        addr=OLED_ADDR,
    )
    display.fill(0)
    display.show()

    big_font, small_font = load_fonts()

    bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=BME280_ADDR)
    bme280.sea_level_pressure = 1013.25
    sgp40 = adafruit_sgp40.SGP40(i2c)
    mqtt_client = mqtt_connect()

    last_csv_write = 0
    current_fan_speed = 0.0
    last_sent_fan_speed = None

    last_temp_c = 0.0
    last_humidity = 0.0
    last_pressure_hpa = 0.0
    last_voc = 0
    status = "BOOT"

    try:
        set_nevermore_speed(current_fan_speed)
        last_sent_fan_speed = current_fan_speed
    except Exception:
        pass

    while True:
        try:
            temp_c, humidity, pressure_hpa = read_bme280(bme280)
            voc = read_sgp40_with_retry(sgp40, temp_c, humidity)

            last_temp_c = temp_c
            last_humidity = humidity
            last_pressure_hpa = pressure_hpa
            last_voc = voc
            status = "RUN"

        except OSError:
            status = "I2C"
        except Exception:
            status = "ERR"

        current_fan_speed = next_fan_speed(last_voc, current_fan_speed)

        if last_sent_fan_speed is None or abs(current_fan_speed - last_sent_fan_speed) > 0.001:
            try:
                set_nevermore_speed(current_fan_speed)
                last_sent_fan_speed = current_fan_speed
            except Exception:
                status = "API"

        try:
            publish_state(
                mqtt_client,
                last_temp_c,
                last_humidity,
                last_pressure_hpa,
                last_voc,
            )
        except Exception:
            status = "MQTT"

        write_status(
            last_temp_c,
            last_humidity,
            last_pressure_hpa,
            last_voc,
            current_fan_speed,
            status,
        )

        now = time.time()
        if now - last_csv_write >= 30:
            append_csv(
                last_temp_c,
                last_humidity,
                last_pressure_hpa,
                last_voc,
                current_fan_speed,
            )
            last_csv_write = now

        draw_screen(
            display,
            big_font,
            small_font,
            last_temp_c,
            last_humidity,
            last_voc,
            int(current_fan_speed * 100),
        )

        time.sleep(LOOP_SECONDS)


if __name__ == "__main__":
    main()
