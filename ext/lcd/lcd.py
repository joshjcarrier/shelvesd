# driver from http://www.recantha.co.uk/blog/?p=4849
import lcddriver
import sys
from time import *

COLS=20
ROWS=4

lcd = lcddriver.lcd()

i = 0
for arg in sys.argv[1:]:
  i+=1
  if i > ROWS:
    continue
  lcd.lcd_display_string(sys.argv[i][:COLS], i)
