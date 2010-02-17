# 
#  aMuleSocket_twisted.py
#  amule-remote
#  
#  Created by piros on 2010-01-11.
#  Licensed under MIT
# 
# This is an emproved version of aMuleSocket, also it requires twisted to work, the socket is asyncronus,
# which will permit more than one client to connect at a time

from twisted.internet import reactor
from twisted.internet.protocol import ServerFactory
from twisted.protocols.basic import LineOnlyReceiver

from xml.etree import ElementTree as ET

from aMuleClass import amulecmd

## Change Port information below

class DialogueProtocol(LineOnlyReceiver):
    def connectionMade(self):
        print "Connected: %s" % self.transport.getPeer().host
    def lineReceived(self, line):
        parsed= ET.XML(line)
        if parsed.attrib['type'] == 'request':
            if parsed.attrib['prompt'] == 'results':
                self.transport.write(self.factory.mule.results())
            elif parsed.attrib['prompt'] == 'downloads':
                self.transport.write(self.factory.mule.downloads())
            else:
                print "Invalid request: %s\n" % line
        else:
            query= parsed.attrib['value']
            if parsed.attrib['type'] == 'search':
                print "must search for %s" % query
                self.factory.mule.search(query)
            elif parsed.attrib['type'] == 'cancel':
                print "must cancel %s" % query
                self.factory.mule.command("cancel %s" % query)
            elif parsed.attrib['type'] == 'download':
                print "must download %s" % query
                self.factory.mule.command("download %s" % query)
        
class DialogueProtocolFactory(ServerFactory):
    def __init__(self):
        self.protocol= DialogueProtocol
        self.mule= amulecmd()

def main():
    ##
    port= 2000
    ##
    factory= DialogueProtocolFactory()
    reactor.listenTCP(port, factory)
    reactor.run()


if __name__ == '__main__':
    main()
