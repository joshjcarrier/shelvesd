# driver from http://www.recantha.co.uk/blog/?p=4849

import sys

try:
  import lcddriver
except ImportError, e:
  print >> sys.stderr, 'Failed to load lcddriver. Possibly because package python-smbus is missing or not supported.'
  sys.exit(1)

from time import *

COLS=20
ROWS=4

lcd = lcddriver.lcd()

if sys.argv[1] == 'txt':
  i = 0
  for arg in sys.argv[2:]:
    i+=1
    if i > ROWS:
      continue
    lcd.lcd_display_string(sys.argv[i+1][:COLS], i)
elif sys.argv[1] == 'bl':
  if sys.argv[2] == '1':
    lcd.lcd_backlight_on()
  else:
    lcd.lcd_backlight_off()
