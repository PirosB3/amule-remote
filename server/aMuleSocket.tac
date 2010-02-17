from twisted.internet import protocol, reactor
from twisted.protocols.basic import LineOnlyReceiver
from twisted.application import service

from xml.etree import ElementTree as ET

from aMuleClass import amulecmd

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
            else:
                print "Invalid request: %s\n" % query


class MyService(service.Service):
    def __init__(self,port=14000):
        self.port = port
    def startService(self):
        self.factory = protocol.Factory()
        self.factory.protocol = DialogueProtocol
        reactor.callWhenRunning(self.startListening)
    def startListening(self):
        self.factory.mule = amulecmd()
        self.listener = reactor.listenTCP(self.port,self.factory)
        print "Started listening"
    def stopService(self):
        self.listener.stopListening()

application = service.Application("aMuleSocket")
services = service.IServiceCollection(application)
MyService().setServiceParent(services)