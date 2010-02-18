There are two possible sockets to choose from

simple-socket:
	It's a very simple a rural implementation on python's socket library
	IMPORTANT: All you need to do is copy the aMuleClass from twisted-socket/ folder
	cp twisted-socket/aMuleClass.py simple-socket/    from this dir
	python simple-socket/aMuleSocket.py
		+ Very easy to implement
		+ No need of extra libraries
		- doesn't manage async calls
		- lack of multithread
		- lack of background
		
twisted-socket:
	The implementation i reccomend, it requires python-twisted, but you get most advantages from it
	The script is launched using twistd.
	twistd -y twisted-socket/aMuleSocket.tap ( for debug use -noy flags instead of -y)
	to kill the socket, just look at it's PID
		+ Background support, launch it and forget about it
		+ async support
		- need python-twisted libraries
		
		NOTE: I am currently working on a .DEB and .RPM package which includes all the twisted-socket plus goodies such as init.d scripts for startup and shutdown