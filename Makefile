install:
	sudo apt-get install ruby1.9.1-dev # for pi_piper
	cp etc/shelvesd.sh /etc/init.d/shelvesd
	chmod +x /etc/init.d/shelvesd
	update-rc.d shelvesd defaults
	/etc/init.d/shelvesd restart &
