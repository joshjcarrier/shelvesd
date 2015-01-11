shelvesd
========

Your shelves, but smarter.

Prepare the gems.
> make configure

Run it.
> ruby lib/shevesd.rb

Make it part of startup.
> make install


On Raspberry Pis, make sure I2C is enabled for LCD support:
-------------------------------
Remove I2C from Blacklist:
> $ cat /etc/modprobe.d/raspi-blacklist.conf
> # blacklist spi and i2c by default (many users don't need them)
> blacklist spi-bcm2708
> #blacklist i2c-bcm2708


Add this to the end of /etc/modules
> i2c-dev


And install I2C device support for Python
> apt-get install python-smbus 
