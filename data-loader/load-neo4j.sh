#!/usr/bin/env bash

ME=load-neo4j.sh

echo "($ME) $(date) Starting (from $IMPORT_DIRECTORY)..."
echo "($ME) $(date) Database root is $NEO4J_dbms_directories_data"

# If the destination database exists
# then do nothing...
if [ ! -d $NEO4J_dbms_directories_data/databases/$IMPORT_TO.db ]
then
    echo "Running as $(id)"
    echo "($ME) $(date) Importing into '$NEO4J_dbms_directories_data/databases/$IMPORT_TO.db'..."

    cd $IMPORT_DIRECTORY
    /var/lib/neo4j/bin/neo4j-admin import \
        --database $IMPORT_TO.db \
        --ignore-missing-nodes \
        --nodes "nodes-header.csv,molport-augmented-nodes.csv.gz" \
        --nodes "molport-suppliermol-nodes.csv.gz" \
        --nodes "molport-supplier-nodes.csv.gz" \
        --nodes "molport-isomol-nodes.csv.gz" \
        --relationships "edges-header.csv,edges.csv.gz" \
        --relationships "molport-suppliermol-supplier-edges.csv.gz" \
        --relationships "molport-isomol-suppliermol-edges.csv.gz" \
        --relationships "molport-molecule-suppliermol-edges.csv.gz" \
        --relationships "molport-isomol-molecule-edges.csv.gz" 

    echo "($ME) $(date) Imported."
else
    echo "($ME) $(date) Database '$IMPORT_TO' already exists."
fi

echo "($ME) $(date) Finished."
