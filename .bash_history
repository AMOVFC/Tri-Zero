sudo apt-get update && sudo apt-get install git -y
cd ~ && git clone https://github.com/dw-0/kiauh.git
./kiauh/kiauh.sh
cd ~
git clone https://github.com/lhndo/ResHelper.git
cd ResHelper
./install.sh
cd
cd ~/
git clone https://github.com/mainsail-crew/moonraker-timelapse.git
cd ~/moonraker-timelapse
make install
cd
ls /dev/serial/by-id/
ls
cd klipper
ls
cd config
ls
cd
ls
cd printer_data/
ls
cd config
ls
cd
./kiauh/kiauh.sh
ls
./kiauh/kiauh.sh
sudo nano /boot/config.txt
sudo nano /boot/firmware/config.txt
sudo reboot
ls /dev/spidev*
systemctl status KlipperScreen
# 1) Show the actual error from the last run
journalctl -u KlipperScreen -n 200 --no-pager
# 2) Also show KlipperScreen's own log (often more detailed)
tail -n 200 /tmp/KlipperScreen.log 2>/dev/null || true
tail -n 200 ~/printer_data/logs/KlipperScreen.log 2>/dev/null || true
# 3) Confirm what display devices exist
ls -l /dev/fb* /dev/dri/* 2>/dev/null
sudo systemctl stop KlipperScreen
sudo usermod -aG video,render,input andre
sudo reboot
id andre
sudo systemctl stop KlipperScreen
cd ~/KlipperScreen
source ./.KlipperScreen-env/bin/activate
python3 -m KlipperScreen
ls -la ~/KlipperScreen
sudo systemctl stop KlipperScreen
sudo apt update
sudo apt install -y python3-venv python3-pip python3-dev   gir1.2-gtk-3.0 libgirepository1.0-dev libcairo2-dev pkg-config   libjpeg-dev zlib1g-dev
cd ~/KlipperScreen
python3 -m venv .KlipperScreen-env
source .KlipperScreen-env/bin/activate
pip install --upgrade pip wheel setuptools
pip install -r scripts/KlipperScreen-requirements.txt
python3 ./screen.py --help
python3 ./screen.py -l /tmp/KlipperScreen.log
nano ~/printer_data/config/KlipperScreen.conf
sudo nano /etc/systemd/system/KlipperScreen.service
sudo systemctl daemon-reload
sudo systemctl restart KlipperScreen
systemctl status KlipperScreen --no-pager
sudo systemctl restart KlipperScreen
ls -l /dev/fb* 2>/dev/null || echo "NO framebuffer devices"
ls -l /dev/dri/card* /dev/dri/renderD* 2>/dev/null
sudo dmesg -T | egrep -i "fb|fbtft|drm|st77|ili93|ili94|spi.*lcd|panel" | tail -n 120
cat /boot/config.txt
dtoverlay -l
cat /boot/firmware/config.txt
dtoverlay -l
ls -l /dev/spidev*
sudo nano /boot/firmware/config.txt
sudo reboot
# shows overlays currently enabled
dtoverlay -l
# show what BTT packages/drivers might exist
dpkg -l | egrep -i "fbcp|tinydrm|kms|drm|waveshare|tft|btt" || true
cat /etc/os-release | egrep "PRETTY_NAME|VERSION"
uname -a
# backup
sudo cp -a /boot/firmware/config.txt /boot/firmware/config.txt.bak.$(date +%F-%H%M%S)
# append settings (safe to append; duplicates usually OK but we can keep it simple)
sudo bash -c 'cat >> /boot/firmware/config.txt <<EOF

# ---- SPI + I2C for TFT / IO boards ----
dtparam=spi=on
dtparam=i2c_arm=on
EOF'
sudo reboot
ls -l /dev/spidev*
ls -l /dev/i2c*
sudo nano /boot/firmware/config.txt
sudo modprobe i2c-dev
sudo modprobe i2c-bcm2835
ls -l /dev/i2c* || echo "still no i2c devices"
sudo tee /etc/modules-load.d/i2c.conf >/dev/null <<'EOF'
i2c-dev
i2c-bcm2835
EOF

sudo apt update
sudo apt install -y i2c-tools
sudo i2cdetect -y 1
ls -1 /boot/firmware/overlays | egrep -i "ili|st77|tinydrm|piscreen|tft|waveshare|panel|spi" || true
readlink -f /sys/class/spidev/spidev10.0/device
sudo nano /boot/firmware/config.txt
sudo reboot
sudo bash -lc 'set -e; ts=$(date +%F-%H%M%S); \
for f in /boot/firmware/config.txt /etc/modules-load.d/i2c.conf /etc/systemd/system/fbcp-tft.service; do [ -e "$f" ] && cp -a "$f" "$f.bak.$ts"; done; \
sed -i -e "/^# ---- SPI \+ I2C for TFT \/ IO boards ----/,\$d" -e "/mipi-dbi-spi/d" -e "/pitft/d" /boot/firmware/config.txt; \
rm -f /etc/modules-load.d/i2c.conf; \
systemctl disable --now fbcp-tft.service 2>/dev/null || true; \
modprobe -r i2c-dev i2c-bcm2835 2>/dev/null || true; \
reboot'
sudo apt update && sudo apt install -y xserver-xorg x11-xserver-utils xinit xinput libegl1 libgl1
sudo systemctl edit KlipperScreen
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
nano /boot/firmware/config.txt
sudo nano /boot/firmware/config.txt
sudo reboot
ps aux | grep -E "Xorg|Xorg.wrap"
sudo apt update && sudo apt install -y xserver-xorg xinit x11-xserver-utils libegl1 libgl1
sudo systemctl edit KlipperScreen
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo reboot
ps aux | grep -E "Xorg|Xorg.wrap"
sudo apt update
sudo apt install -y xserver-xorg xinit x11-xserver-utils
cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
sudo bash -lc 'ts=$(date +%F-%H%M%S); cp -a /boot/firmware/config.txt /boot/firmware/config.txt.bak.$ts; \
grep -q "^hdmi_force_hotplug=1" /boot/firmware/config.txt || echo "hdmi_force_hotplug=1" >> /boot/firmware/config.txt; \
grep -q "^hdmi_ignore_edid=0xa5000080" /boot/firmware/config.txt || echo "hdmi_ignore_edid=0xa5000080" >> /boot/firmware/config.txt; \
grep -q "^hdmi_group=2" /boot/firmware/config.txt || echo "hdmi_group=2" >> /boot/firmware/config.txt; \
grep -q "^hdmi_mode=82" /boot/firmware/config.txt || echo "hdmi_mode=82" >> /boot/firmware/config.txt; \
echo "Wrote HDMI recovery settings. Rebooting..."; reboot'
tcd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- # 1) What exactly is failing in the KlipperScreen service
sudo systemctl status KlipperScreen --no-pager -l
# 2) Last 200 log lines from KlipperScreen service
sudo journalctl -u KlipperScreen -n 200 --no-pager
# 3) If X tried to start, show the Xorg errors
sudo grep -E "(EE)|(WW)" /var/log/Xorg.0.log | tail -n 120
sudo systemctl stop KlipperScreen
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/99-pi-kms.conf >/dev/null <<'EOF'
Section "Device"
    Identifier "PiKMS"
    Driver "modesetting"
    Option "kmsdev" "/dev/dri/card0"
EndSection
EOF

cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
grep -E "(EE)|(WW)" /var/log/Xorg.0.log | tail -n 120
ls -l /dev/dri/by-path
sudo systemctl restart KlipperScreen
sudo systemctl status KlipperScreen --no-pager -l
sudo sed -i 's|/dev/dri/card0|/dev/dri/card1|' /etc/X11/xorg.conf.d/99-pi-kms.conf
cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
sudo pkill -9 Xorg Xorg.wrap Xwayland || true
sudo rm -f /tmp/.X0-lock /tmp/.X11-unix/X0
sudo systemctl stop KlipperScreen
cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
sudo systemctl disable --now KlipperScreen
sudo pkill -9 Xorg Xorg.wrap Xwayland || true
sudo rm -f /tmp/.X0-lock /tmp/.X11-unix/X0
ps aux | grep -E "Xorg|Xorg.wrap|Xwayland" | grep -v grep || echo "no X processes"
cd ~/KlipperScreen
xinit ./scripts/KlipperScreen-start.sh -- :0
systemctl status KlipperScreen
sudo systemctl enable KlipperScreen
sudo systemctl start KlipperScreen
systemctl status KlipperScreen
cat ~/printer_data/logs/KlipperScreen.log
cat /tmp/KlipperScreen.log
DISPLAY=:0 /home/andre/.KlipperScreen-env/bin/python /home/andre/KlipperScreen/screen.py
nano ~/printer_data/config/KlipperScreen.conf
sudo systemctl restart KlipperScreen
systemctl status KlipperScreen
cat /etc/systemd/system/KlipperScreen.service.d/override.conf
sudo rm /tmp/.X0-lock
sudo systemctl restart KlipperScreen
DISPLAY=:0 /home/andre/.KlipperScreen-env/bin/python /home/andre/KlipperScreen/screen.py
./kiauh/kiauh.sh
shut dowm
shut down
sudo shutdown
./kiauh/kiauh.sh
ls
cd klipper-backup
ls
ls utils
ls install-files
cat readme.md
cat README.md
cd ~/klipper-backup
ls -la
nano .env
CD
sudo reboot
git push -force
cd ~/klipper-backup
git push -force
git push --force
git push
script.sh -f
nano .env
git push
git push --help
git push -f
nano .env
git push -f
nano .env
git push -f
CD
cd
nano .env
cd ~/klipper-backup
nano .env
cd
cd ~/printer_data/config
git status
git remote -v
git branch --show-current
git status
ls
cd
git status
cd klipper-backup
ls
git status
cd
cd ~ && rm -rf ~/voronv0-backup-repo && git clone https://github.com/AMOVFC/VoronV0-MIA.git ~/voronv0-backup-repo && cd ~/voronv0-backup-repo && git checkout -b printer-config-$(date +%Y%m%d_%H%M) && rsync -avL --delete   --exclude '.git/'   --exclude '*.log'   --exclude '*.tmp'   --exclude '*.swp'   --exclude '.cache/'   --exclude '__pycache__/'   ~/printer_data/config/ ./ && git add -A && git commit -m "Update from live printer config $(date +%Y-%m-%d\ %H:%M)" && git push -u origin HEAD
cd
cd klipper-backup
git push --force
cd
git push --force
cd klipper-backup
nano .evn
ls -l
ls -lm
ls
ls -a
nano .env
sudo raspi-config
sudo apt install i2c-tools
i2cdetect -y 1
#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y   python3-pip   python3-pil   python3-smbus   i2c-tools   python3-venv
mkdir -p ~/printer_air_monitor
cd ~/printer_air_monitor
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install   adafruit-blinka   adafruit-circuitpython-ssd1306   adafruit-circuitpython-bme680   pillow
mkdir -p ~/printer_air_monitor
nano ~/printer_air_monitor/install.sh
chmod +x ~/printer_air_monitor/install.sh
~/printer_air_monitor/install.sh
nano ~/printer_air_monitor/printer_air_monitor.service
sudo cp ~/printer_air_monitor/printer_air_monitor.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable printer_air_monitor
sudo systemctl start printer_air_monitor
sudo systemctl status printer_air_monitor
#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt install -y   python3-pip   python3-pil   python3-smbus   i2c-tools   python3-venv
mkdir -p ~/printer_air_monitor
cd ~/printer_air_monitor
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install   adafruit-blinka   adafruit-circuitpython-ssd1306   adafruit-circuitpython-bme280   pillow
mkdir -p ~/printer_air_monitor
chmod +x ~/printer_air_monitor/install.sh
~/printer_air_monitor/install.sh
cat /tmp/printer_air_monitor/status.txt
nano ~/printer_air_monitor/read_voc.py
chmod +x ~/printer_air_monitor/read_voc.py
python3 ~/printer_air_monitor/read_voc.py
cd ~/printer_air_monitor
source .venv/bin/activate
pip install requests
ls
rm air_monitor.py
nano air_monitor.py
cd ~/printer_air_monitor
source .venv/bin/activate
python3 air_monitor.py
sudo systemctl stop printer_air_monitor
pkill -f air_monitor.py
rm air_monitor.py
nano air_monitor.py
python3 air_monitor.py
sudo systemctl restart printer_air_monitor
sudo systemctl status printer_air_monitor
cat /tmp/printer_air_monitor/status.txt
rm air_monitor.py
nano air_monitor.py
sudo systemctl restart printer_air_monitor
cd ~/printer_air_monitor
source .venv/bin/activate
pip install requests
nano air_monitor.py
sudo systemctl restart printer_air_monitor
python3 air_monitor.py
nano air_monitor.py
python3 air_monitor.py
sudo systemctl restart printer_air_monitor
sudo systemctl restart moonraker
rm air_monitor.py
nano air_monitor.py
python3 air_monitor.py
cat /tmp/printer_air_monitor/status.txt
tail -f /tmp/printer_air_monitor/air_monitor.log
source .venv/bin/activate
cd ~/printer_air_monitor
source .venv/bin/activate
rm air_monitor.py
nano air_monitor.py
pip install paho-mqtt
sudo apt update
sudo apt install -y mosquitto mosquitto-clients
sudo systemctl enable --now mosquitto
sudo systemctl restart moonraker
sudo systemctl status mosquitto
mosquitto_sub -h 127.0.0.1 -t printer/air_monitor/state -v
curl http://127.0.0.1:7125/server/sensors/list
curl "http://127.0.0.1:7125/server/sensors/measurements?sensor=chamber_env"
sudo reboot
cd ~/printer_air_monitor
source .venv/bin/activate
python3 air_monitor.py
cd ~/printer_air_monitor
source .venv/bin/activate
rm air_monitor.py
nano air_monitor.py
pip install paho-mqtt
python3 air_monitor.py
rm air_monitor.py
nano air_monitor.py
python3 air_monitor.py
sudo reboot
lsusb
sudo systemctl stop klipper
sudo apt update && sudo apt install git -y
cd ~ && git clone https://github.com/Arksine/katapult
virtualenv -p python3 ~/katapult-env
~/katapult-env/bin/pip3 install pyserial greenlet cffi python-can aenum
cd ~/katapult
make menuconfig
make
sudo dfu-util -d 0483:df11 -a 0 -s 0x08000000:mass-erase:force -D out/katapult.bin
cd
lsusb
ls dev/serial/by-id/
ls dev/serial/by-id
ls dev/serial/
ls /dev/serial/
ls /dev/serial/by-id/
sudo reboot
rrrrrrrrrrrrrr
cd ~/klipper
~/katapult-env/bin/python3 ~/katapult/scripts/flashtool.py -d /dev/serial/by-id/usb-katapult_stm32h743xx_3A0046001451333135363231-if00 -f out/klipper.bin
ls /dev/serial/by-id/**
sudo systemctl start klipper
ls /dev/serial/by-id/**
