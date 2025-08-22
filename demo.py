#!/usr/local/bin/python
#
# Given a neo4j password this utility simply prints the
# number of nodes on the graph at localhost:-
#
#   $ ./demo.py blob1234
#   <Record count (n)=10972>

import sys
from neo4j import GraphDatabase

if len(sys.argv) != 2:
    print("Error: Missing password")
    print("Usage: demo.py <neo4j-password>")
    sys.exit(1)

password = sys.argv[1]

driver  = GraphDatabase.driver("neo4j://localhost:7687", auth=("neo4j", password))
assert driver

def all(tx):
    for record in tx.run("match (n) return count (n)"):
       print(record)

with driver.session() as session:
    session.read_transaction(all)
