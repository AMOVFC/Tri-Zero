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
git push origin main --force
git rm -r --cached printer_data/database/ printer_data/logs/ 2>/dev/null
cd ~
echo "printer_data/database/" >> .gitignore
echo "printer_data/logs/" >> .gitignore
# This moves the "pointer" back one step but keeps your files as they are
git reset --soft HEAD~1
# Now, re-add everything (it will now respect the new .gitignore)
git add .
# Create a fresh, clean commit
git commit -m "Reset: Source of truth (Secrets Removed)"
git push origin main --force
ls
~/kiauh/kiauh.sh
# 1. Move into the fluidd directory
cd ~/fluidd
# 2. Download the latest web files directly from the source
wget -q https://github.com/fluidd-core/fluidd/releases/latest/download/fluidd.zip
# 3. Unzip them (this puts back .version, index.html, etc.)
unzip -o fluidd.zip
# 4. Clean up the zip file
rm fluidd.zip
# 5. Force the permissions to be writable again
sudo chown -R andre:andre /home/andre/fluidd
chmod -R 755 /home/andre/fluidd
ls
cd ~
# Create the directory
mkdir -p ~/fluidd
# Move the loose web files into it
mv assets/ img/ monacoeditorwork/ ~/fluidd/ 2>/dev/null
mv index.html config.json favicon.ico manifest.webmanifest robots.txt sw.js release_info.json editor.theme.json ~/fluidd/ 2>/dev/null
mv logo_*.svg ~/fluidd/ 2>/dev/null
sudo chown -R andre:andre ~/fluidd
chmod -R 755 ~/fluidd
git rm --cached index.html config.json favicon.ico 2>/dev/null
git commit -m "chore: moved loose web files to fluidd folder"
~/kiauh/kiauh.sh
mv ~/.version ~/fluidd/
cat <<EOF > ~/.gitignore
# Application Folders (Ignore everything Git found)
Klipper-Adaptive-Meshing-Purging/
KlipperScreen/
ResHelper/
crowsnest/
fluidd/
katapult/
kiauh/
klipper-backup/
mainsail-config/
mobileraker_companion/
moonraker-timelapse/
octoeverywhere/
klipper/
moonraker/

# Hidden Files
.version
.wget-hsts

# Data and Logs
printer_data/logs/
printer_data/database/
*.log
EOF

git add .gitignore
git commit -m "chore: silence untracked application folders"
git push origin main
ls
~/kiauh/kiauh.sh
ls
systemctl list-timers
systemctl --user list-units --state=failed
ps aux | grep nginx
sudo reboot
sudo chown -R andre:andre ~/printer_data
chmod -R 775 ~/printer_data/gcodes
cd ~
git rm -r --cached printer_data/gcodes 2>/dev/null
echo "printer_data/gcodes/" >> ~/.gitignore
git commit -m "fix: stop tracking gcodes to prevent moonraker lock"
sudo systemctl restart moonraker
tail -f ~/printer_data/logs/moonraker.log
cd ~
git rm -r --cached printer_data/gcodes 2>/dev/null
echo "printer_data/gcodes/" >> ~/.gitignore
git commit -m "fix: ignore gcodes to stop moonraker scanning loop"
rm -rf ~/printer_data/gcodes/.thumbs/*
sudo systemctl restart klipper
sudo systemctl restart moonraker
tail -f ~/printer_data/logs/moonraker.log
# Move any hidden git files out of the gcodes folder specifically
find ~/printer_data/gcodes -name ".git*" -delete
# Clear any stuck thumbnail generation
rm -rf ~/printer_data/gcodes/.thumbs/*
rm ~/printer_data/database/moonraker.db
sudo systemctl restart moonraker
ls ~/printer_data/gcodes | wc -l
tail -f ~/printer_data/logs/moonraker.log
# 1. Kill the 'Reserved Path' metadata Moonraker is choking on
rm -rf ~/printer_data/gcodes/.git*
rm -f ~/printer_data/gcodes/.version
# 2. Fix the permissions for the entire data stack
sudo chown -R andre:andre ~/printer_data
chmod -R 755 ~/printer_data
# 3. Clean the Moonraker database (this clears the 'stuck' scan)
rm -f ~/printer_data/database/moonraker.db
# 4. CRITICAL: Stop Moonraker from thinking your home dir is a managed repo
# This moves the .git folder out of the way temporarily to test
mv ~/.git ~/.git_backup
sudo systemctl restart moonraker
tail -f ~/printer_data/logs/moonraker.log
# 1. Rename your current gcodes folder to hide it from Moonraker
mv ~/printer_data/gcodes ~/printer_data/gcodes_backup
# 2. Create a fresh, empty gcodes folder
mkdir ~/printer_data/gcodes
# 3. Fix permissions and restart
sudo chown -R andre:andre ~/printer_data/gcodes
sudo systemctl restart moonraker
tail -f ~/printer_data/logs/moonraker.log
~/kiauh/kiauh.sh
sudo reboot
sudo nano ~/printer_data/config/moonraker.conf
# Force ownership back to your user for everything
sudo chown -R andre:andre /home/andre/printer_data
# Give write permissions to the config folder
chmod -R 775 /home/andre/printer_data/config
# Restart Moonraker to apply the changes
sudo systemctl restart moonraker
lsusb
ls dev/serial/by-id/*
ls dev/serial/*
ls dev/
ls ~/dev/
cd
ls
ls /dev/serial/by-id/
sudo apt-get install jq crudini
cd ~/Backup-Pie
./scripts/install.sh
sed -n '1,10p' ~/.config/backup-pie/config.env
sed -i 's|^BACKUP_COMMIT_PREFIX=.*|BACKUP_COMMIT_PREFIX="backup(printer)"|' ~/.config/backup-pie/config.env
./scripts/install.sh
sudo apt install inotify-tools
systemctl --user daemon-reload
systemctl --user enable --now pi-home-backup-watch.service
systemctl --user status pi-home-backup-watch.service
[200~journalctl --user -u pi-home-backup.service -n 50~
journalctl --user -u pi-home-backup.service -n 50
bash ~/Backup-Pie/scripts/pi-home-sync.sh
bash <(cat <<'EOF'
set -euo pipefail
source "$HOME/.config/backup-pie/config.env"

WORKTREE="${BACKUP_WORKTREE:-$HOME}"
BRANCH="${BACKUP_BRANCH:-main}"
REMOTE="${BACKUP_REMOTE:-origin}"
PREFIX="${BACKUP_COMMIT_PREFIX:-backup(pi-home)}"

log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
r()   { git -C "$WORKTREE" "$@"; }

log "Fetching $REMOTE/$BRANCH"
r fetch "$REMOTE" "$BRANCH" 2>/dev/null || log "No remote branch yet; skipping snapshot"

if r rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
  snap="snapshot/$(date -u +'%Y-%m-%d')"
  if ! r ls-remote --exit-code "$REMOTE" "refs/heads/$snap" >/dev/null 2>&1; then
    log "Saving snapshot: $snap"
    r push "$REMOTE" "$REMOTE/$BRANCH:refs/heads/$snap"
  else
    log "Snapshot already exists for today: $snap"
  fi
fi

if [[ -n "$(r status --porcelain)" ]]; then
  log "Committing local changes"
  r add -A
  r commit -m "$PREFIX: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
else
  log "No local changes"
fi

log "Force-pushing to $REMOTE/$BRANCH"
r push --force "$REMOTE" "$BRANCH"
log "Done"
EOF

)
# Check the credentials file looks right (token will be visible — run in private)
cat ~/.config/backup-pie/git-credentials
# Check git is pointing to that file for the home repo
git -C ~ config credential.helper
# Check what remote URL git is using
git -C ~ remote get-url origin
# Fix the remote URL to plain HTTPS (no token embedded)
git -C ~ remote set-url origin https://github.com/AMOVFC/Tri-Zero.git
# Save your token to the credentials file
read -r -s -p "GitHub token: " tok && printf '\n' && printf 'https://x-access-token:%s@github.com\n' "$tok" > ~/.config/backup-pie/git-credentials && echo "Token saved."
bash <(cat <<'EOF'
set -euo pipefail
source "$HOME/.config/backup-pie/config.env"

WORKTREE="${BACKUP_WORKTREE:-$HOME}"
BRANCH="${BACKUP_BRANCH:-main}"
REMOTE="${BACKUP_REMOTE:-origin}"
PREFIX="${BACKUP_COMMIT_PREFIX:-backup(pi-home)}"

log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
r()   { git -C "$WORKTREE" "$@"; }

log "Fetching $REMOTE/$BRANCH"
r fetch "$REMOTE" "$BRANCH" 2>/dev/null || log "No remote branch yet; skipping snapshot"

if r rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
  snap="snapshot/$(date -u +'%Y-%m-%d')"
  if ! r ls-remote --exit-code "$REMOTE" "refs/heads/$snap" >/dev/null 2>&1; then
    log "Saving snapshot: $snap"
    r push "$REMOTE" "$REMOTE/$BRANCH:refs/heads/$snap"
  else
    log "Snapshot already exists for today: $snap"
  fi
fi

if [[ -n "$(r status --porcelain)" ]]; then
  log "Committing local changes"
  r add -A
  r commit -m "$PREFIX: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
else
  log "No local changes"
fi

log "Force-pushing to $REMOTE/$BRANCH"
r push --force "$REMOTE" "$BRANCH"
log "Done"
EOF

)
set -euo pipefail
source "$HOME/.config/backup-pie/config.env"
WORKTREE="${BACKUP_WORKTREE:-$HOME}"
BRANCH="${BACKUP_BRANCH:-main}"
REMOTE="${BACKUP_REMOTE:-origin}"
PREFIX="${BACKUP_COMMIT_PREFIX:-backup(pi-home)}"
log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
r()   { git -C "$WORKTREE" "$@"; }
log "Fetching $REMOTE/$BRANCH"
r fetch "$REMOTE" "$BRANCH" 2>/dev/null || log "No remote branch yet; skipping snapshot"
if r rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then   snap="snapshot/$(date -u +'%Y-%m-%d')";   if ! r ls-remote --exit-code "$REMOTE" "refs/heads/$snap" >/dev/null 2>&1; then     log "Saving snapshot: $snap";     r push "$REMOTE" "$REMOTE/$BRANCH:refs/heads/$snap";   else     log "Snapshot already exists for today: $snap";   fi; fi
bash <(cat <<'EOF'
set -euo pipefail
source "$HOME/.config/backup-pie/config.env"

WORKTREE="${BACKUP_WORKTREE:-$HOME}"
BRANCH="${BACKUP_BRANCH:-main}"
REMOTE="${BACKUP_REMOTE:-origin}"
PREFIX="${BACKUP_COMMIT_PREFIX:-backup(pi-home)}"

log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
r()   { git -C "$WORKTREE" "$@"; }

log "Fetching $REMOTE/$BRANCH"
r fetch "$REMOTE" "$BRANCH" 2>/dev/null || log "No remote branch yet; skipping snapshot"

if r rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
  snap="snapshot/$(date -u +'%Y-%m-%d')"
  if ! r ls-remote --exit-code "$REMOTE" "refs/heads/$snap" >/dev/null 2>&1; then
    log "Saving snapshot: $snap"
    r push "$REMOTE" "$REMOTE/$BRANCH:refs/heads/$snap"
  else
    log "Snapshot already exists for today: $snap"
  fi
fi

if [[ -n "$(r status --porcelain)" ]]; then
  log "Committing local changes"
  r add -A
  r commit -m "$PREFIX: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
else
  log "No local changes"
fi

log "Force-pushing to $REMOTE/$BRANCH"
r push --force "$REMOTE" "$BRANCH"
log "Done"
EOF

)
cd /backup-pie
ls
cd Backup-Pie
ls
cd scripts
ls
sh install.sh
install.sh
cd
cd Backup-Pie
./scripts/install.sh
bash <(cat <<'EOF'
set -euo pipefail
source "$HOME/.config/backup-pie/config.env"

WORKTREE="${BACKUP_WORKTREE:-$HOME}"
BRANCH="${BACKUP_BRANCH:-main}"
REMOTE="${BACKUP_REMOTE:-origin}"
PREFIX="${BACKUP_COMMIT_PREFIX:-backup(pi-home)}"

log() { printf '[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"; }
r()   { git -C "$WORKTREE" "$@"; }

log "Fetching $REMOTE/$BRANCH"
r fetch "$REMOTE" "$BRANCH" 2>/dev/null || log "No remote branch yet; skipping snapshot"

if r rev-parse --verify "$REMOTE/$BRANCH" >/dev/null 2>&1; then
  snap="snapshot/$(date -u +'%Y-%m-%d')"
  if ! r ls-remote --exit-code "$REMOTE" "refs/heads/$snap" >/dev/null 2>&1; then
    log "Saving snapshot: $snap"
    r push "$REMOTE" "$REMOTE/$BRANCH:refs/heads/$snap"
  else
    log "Snapshot already exists for today: $snap"
  fi
fi

if [[ -n "$(r status --porcelain)" ]]; then
  log "Committing local changes"
  r add -A
  r commit -m "$PREFIX: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
else
  log "No local changes"
fi

log "Force-pushing to $REMOTE/$BRANCH"
r push --force "$REMOTE" "$BRANCH"
log "Done"
EOF


)
cd ~/Backup-Pie
./scripts/install.sh
# Add the config dir to gitignore permanently
echo ".config/backup-pie/" >> ~/.gitignore
# Remove it from git tracking
git -C ~ rm -r --cached .config/backup-pie/
# Amend the commit to remove the secret
git -C ~ commit --amend --no-edit
# Force push (secret is gone from the commit now)
git -C ~ push --force origin main
# Reset to the commit before the secret was added
git -C ~ reset --hard 8424f5c^
# Confirm .config/backup-pie/ is in gitignore
grep -qxF '.config/backup-pie/' ~/.gitignore || echo '.config/backup-pie/' >> ~/.gitignore
# Remove from index if somehow still tracked
git -C ~ rm -r --cached .config/backup-pie/ 2>/dev/null || true
# Fresh commit of current state (no secret this time)
git -C ~ add -A
git -C ~ commit -m "backup(printer): $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
# Force push
git -C ~ push --force origin main
cd ~/Backup-Pie && git pull origin main
cd ~/Backup-Pie && ./scripts/install.sh
cd ~/Backup-Pie && git pull origin main
cd ~/Backup-Pie && ./scripts/install.sh
cd
ls
cd..
cd ./
ls
sudo apt update
apt list --upgradable
sudo apt full-upgrade -y
./install-afc.sh -h
sudo apt-get install jq crudini
cd ~
git clone https://github.com/AFCProject/AFC-Klipper-Add-On.git
cd AFC-Klipper-Add-On
./install-afc.sh
cd
sudo reboot
lsusb
ls dev/serial/by-id/**
ls ../dev/serial/by-id/**
ls ~/dev/serial/by-id/**
cd ~/
cd ../
ls
cd ../
ls
ls dev/serial/by-id/**
cd ~/AFC-Klipper-Add-On
git pull
./install.sh
ls
install-afc.sh
./install-afc.sh
cd
ls
cd kiauh
ls
./kiauh.sh
