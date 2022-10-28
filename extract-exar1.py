#!/bin/env python3

#
# extract-exar1.py
#
# A small script to extract structures from SIEMENS exar1 file
# It will generate one JSON for each entry in the Content table.
# And sometimes an XML if json['Data'] attribute is found.
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
    name = row[0]  # unique hash ?
    deflate_data = row[1]
    assert deflate_data
    assert row[2] == 'DS'  # wotsit ?
    unzipped = zlib.decompress(deflate_data, -zlib.MAX_WBITS)
    str_data = unzipped.decode("utf-8")
    # skip first line:
    # 'EDF V1: ContentType=syngo.MR.ExamDataFoundation.Data.EdfAddInConfigContent;'
    lines = str_data.splitlines(keepends=True)
    json_str = ''.join(lines[1:])
    # make sure this is JSON before writing it:
    json_data = json.loads(json_str)
    with open(name + '.json', 'w') as f1:
        f1.write(json_str)
        if 'Data' in json_data:
            xml_data = json_data['Data']
            # Always write with XML file extension, even for XProtocol
            with open(name + '.xml', 'w') as f2:
                f2.write(xml_data)
con.close()
