#!/bin/env python3

#https://neurostars.org/t/parsing-exar-files/20237
import sqlite3
import sys
import zlib

filename = sys.argv[1]
table = 'Content'
if len(sys.argv) > 2:
    table = sys.argv[2]

con = sqlite3.connect(filename)
cur = con.cursor()
if True:
 cur.execute(f"SELECT * FROM {table}")
 rows = cur.fetchall()
 for row in rows:
     name = row[0]
     data = row[1]
     assert row[2] == 'DS'
     if data:
      ext = '.xml'
      with open(name + ext, 'wb') as f:
       unzipped = zlib.decompress(data, -zlib.MAX_WBITS)
       f.write(unzipped)
con.close()
