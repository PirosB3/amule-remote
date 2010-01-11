#!/usr/bin/env python
# encoding: utf-8
"""
aMuleSocket.py

Created by piros on 2010-01-01.
Licensed under MIT
"""

import sys
import os
import socket
from time import strftime
from xml.etree import ElementTree as ET
from xml.parsers.expat import ExpatError

from aMuleClass import amulecmd

mule= amulecmd()
## This is the logfile, it spawns on first start, the changes to it will be effective only when the socket gets killed
logfile= open('log.txt', 'a+') ## CHANGE IF NECESSARY

host= socket.gethostbyname(socket.gethostname()) ## CHANGE IF NECESSARY
port= 2000 ## CHANGE IF NECESSARY

def request_from_aMule(element):
    ask= element.attrib['prompt']
    if ask == "results":
        return mule.results()
    elif ask == "status":
        return mule.kad_status()
    elif ask == "downloads":
        return mule.downloads()
    else:
        logfile.write("Strange request: %s\n" % ask)
        #ONLY FOR DEBUG
        return "Strange request"

def search(element):
    var= element.attrib
    if var['type']== "search":
        return mule.search(var['value'])
    elif var['type'] == "download":
        return mule.command("download %s" % var['value'])
    elif var['type'] == "cancel":
        return mule.command("Cancel %s" % var['value'])

def is_request(attribute):
    if attribute['type'] == "request":
        return True
    else:
        return False

def parse_xml(data):
    element =ET.XML(data)
    if is_request(element.attrib):
        return request_from_aMule(element)
    else:
        return search(element)

def main():
    sock= socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind((host, port))
    print "running on address:%s and on port %d" % (host, port)
    sock.listen(1)
    # serves forever..
    while 1:
        conn, addr= sock.accept()
        logfile.write("%s - %s requested a connection\n" % (strftime("%Y-%m-%d %H:%M:%S"), addr[0]))
        while 1:
            data= conn.recv(1024)
            if not data: break
            try:
                return_xml= parse_xml(data)
                if return_xml:
                    conn.send(return_xml)
                else:
                    conn.send("OK")
            except ExpatError:
                logfile.write("%s - There has been an error, data was: %s\n" % (strftime("%Y-%m-%d %H:%M:%S"), data))

if __name__ == '__main__':
    main()

