#!/bin/env python3

#
# extract-exar1.py
#
# A small script to extract structure from SIEMENS exar1 file
#
# Usage: python3 extract-exar1.py "filename.exar1"
#

# https://neurostars.org/t/parsing-exar-files/20237
import sqlite3
import sys
import zlib
import json

filename = sys.argv[1]
table = 'Content'

con = sqlite3.connect(filename)
cur = con.cursor()
cur.execute(f"SELECT * FROM {table}")
rows = cur.fetchall()
for row in rows:
    name = row[0]
    data = row[1]
    assert data
    assert row[2] == 'DS'
    ext = '.json'
    unzipped = zlib.decompress(data, -zlib.MAX_WBITS)
    with open(name + ext, 'w') as f:
        str_data = unzipped.decode("utf-8")
        json_data = ''.join(str_data.splitlines(keepends=True)[1:])
        tmp = json.loads(json_data)
        f.write(json_data)
        if 'Data' in tmp:
            xml = tmp['Data']
            ext = '.xml'
            with open(name + ext, 'w') as f2:
                # XProtocol ?
                f2.write(xml)
con.close()
