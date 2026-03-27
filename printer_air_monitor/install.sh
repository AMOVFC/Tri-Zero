#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
  python3-pip \
  python3-pil \
  python3-smbus \
  i2c-tools \
  python3-venv

mkdir -p ~/printer_air_monitor
cd ~/printer_air_monitor

python3 -m venv .venv
source .venv/bin/activate

pip install --upgrade pip
pip install \
  adafruit-blinka \
  adafruit-circuitpython-ssd1306 \
  adafruit-circuitpython-bme280 \
  pillow
