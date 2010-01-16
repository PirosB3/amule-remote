# 
#  aMuleClass.py
#  amule-remote
#  
#  Created by piros on 2010-01-11.
#  Licensed under MIT
# 

# ==========================================================================================
# = This class interacts with aMuleCMD, it must be installed and configured on your server =
# ==========================================================================================

import pexpect
import re
from time import sleep
class amulecmd():
	def __init__(self):
		try:
			self.process= pexpect.spawn('amulecmd', timeout=2)
			self.process.expect('aMulecmd')
			self.timeout= False
		except pexpect.TIMEOUT:
			self.timeout= True	
	def prompt(self):
		if not self.timeout:
			self.process.expect('aMulecmd')
        def filters(self, name):
            ## RETURNS VALID DATA
            name= name.replace("&", "&amp;")
            name= name.replace('"', '&quot;')
            name= name.replace("'", '&apos;')
            name= name.replace("<", "&lt;")
            name= name.replace(">", "&gt;")
            return name
        
	def command(self, command):
		if not self.timeout:
			self.process.sendline(command)
			self.prompt()
			return self.process.before
	
	def kad_status(self):
## RETURNS KAD STATUS
		if not self.timeout:
			status= self.command('status')
			for x in status.splitlines():
				if x.__contains__('Connesso'):
					return_code= '<?xml version="1.0" encoding="UTF-8" ?>\n<root type="response" prompt="status">\n\t<status>ON</status>\n</root>'
					break
				else:
				    return_code= '<?xml version="1.0" encoding="UTF-8" ?>\n<root type="response" prompt="status">\n\t<status>OFF</status>\n</root>'
			return return_code
		
	def downloads(self):
## RETURN DOWNLOAD STATUS
		if not self.timeout:
			list= self.command('show DL').splitlines()
			status_pattern= '\[\w*,\w*%\]'
			arrange= True
			files= []
			status= []
			results= []
			hashes= []
			for x in list[1:]:
			    if arrange:
				y= x.split()
				hashes.append(y[1])
				files.append(" ".join(y[2:]))
				arrange= False
			    else:
				y= re.findall(status_pattern, x)
				status.append(y[0])
				arrange= True
			for x in range(0, len(files)):
			        results.append('<file name="%s" status="%s" hash="%s" />\n'  %(self.filters(files[x]), status[x], hashes[x]))
			return '<?xml version="1.0" encoding="UTF-8" ?>\n<root>\n<downloads>\n' + "".join(results) + '</downloads>\n</root>\n'
		else:
			return '<?xml version="1.0" encoding="UTF-8" ?>\n<root>\n<error type="aMule not running"/>\n</root>'
		
	def search(self, query):
## SENDS A SEARCH REQUEST, THIS METHOD REQUIRES THE SEARCH QUERY
		if not self.timeout:
			self.command('search kad %s' % query)
		
	def results(self):
## RETURNS RESULTS
		if not self.timeout:
		    list= self.command('results').splitlines()
		    results= []
		    del list[(len(list)-1)]
		    for x in list[3:]:
		        y= ' '.join(x.split())
			number= re.findall('\A\d*', y)
			size= re.findall('\d*\.\d*\d', y)
			disp= re.findall('\d*$', y)
			try:
			    results.append('<file id="%d" name="%s" size="%d" disp="%d"/>\n' % (int(number[0]), self.filters(x[3:]), float(size[0]), int(disp[0])))
			except ValueError:
			    pass
		    #print len(results)
		    return '<?xml version="1.0" encoding="UTF-8" ?>\n<root>\n<results>\n' + "".join(results) + "</results>\n</root>\n"
		else:
			return '<?xml version="1.0" encoding="UTF-8" ?>\n<root>\n<error type="aMule not running"/>\n</root>'