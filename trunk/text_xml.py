#!/usr/bin/env python
# encoding: utf-8
"""
text_xml.py

Created by piros on 2010-01-01.
Copyright (c) 2010 __MyCompanyName__. All rights reserved.
"""
from xml.etree import ElementTree as ET
import sys
import os

string = """<root type="results">
	<file name="Eminem" size="5.0"/>
	<file name="50 Cent" size="12.0"/>
</root>"""

def main():
    element =ET.XML(string)
    print element.attrib
    for sub in element:
        print float(sub.attrib['size'])


if __name__ == '__main__':
    main()

