#!/bin/env python3

#https://neurostars.org/t/parsing-exar-files/20237
import sqlite3
import sys

filename = sys.argv[1]

con = sqlite3.connect(filename)
cur = con.cursor()
if False:
 cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
 print(cur.fetchall())
if False:
 cur.execute("SELECT * FROM Instance")
 rows = cur.fetchall()
 for row in rows:
     #print(row)
     name = row[0]
     data = row[3]
     if data:
      print(name)
      print(data)
      with open(name, 'wb') as f:
       f.write(data)
if False:
 cur.execute("SELECT * FROM ElementToInstanceMap")
 rows = cur.fetchall()
 for row in rows:
     name = row[0]
     data = row[1]
     if data:
      print(name)
      print(data)
      with open(name, 'wb') as f:
       f.write(data)
if True:
 cur.execute("SELECT * FROM Content")
 rows = cur.fetchall()
 for row in rows:
     print(row)
     name = row[0]
     data = row[1]
     if data:
      print(name)
      print(data)
      with open(name + '.content', 'wb') as f:
       f.write(data)
con.close()
