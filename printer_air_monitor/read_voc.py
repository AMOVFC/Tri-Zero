#!/usr/bin/env python3
import re

with open("/tmp/printer_air_monitor/status.txt") as f:
    text = f.read()

m = re.search(r"voc_index=(\d+)", text)

if m:
    print(m.group(1))
else:
    print(0)
