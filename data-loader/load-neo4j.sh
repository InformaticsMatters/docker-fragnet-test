#!/usr/bin/env bash

ME=load-neo4j.sh

# Some entry diagnostics.
# Display key variables and the database and import directories...
echo "($ME) $(date) Running as $(id)"
echo "($ME) $(date) Starting (from $IMPORT_DIRECTORY)..."
echo "($ME) $(date) Importing to database $IMPORT_TO"
echo "($ME) $(date) Database root is $NEO4J_dbms_directories_data"
echo "($ME) $(date) Database root content is..."
ls -l $NEO4J_dbms_directories_data
if [ -d $NEO4J_dbms_directories_data/databases ]
then
    echo "($ME) $(date) Database root databases content is..."
    ls -l $NEO4J_dbms_directories_data/databases
fi
echo "($ME) $(date) Import content is..."
ls -l $IMPORT_DIRECTORY

# If the destination database exists
# then do nothing...
if [ ! -d $NEO4J_dbms_directories_data/databases/$IMPORT_TO.db ]
then
    echo "($ME) $(date) Importing into '$NEO4J_dbms_directories_data/databases/$IMPORT_TO.db'..."

    cd $IMPORT_DIRECTORY
    /var/lib/neo4j/bin/neo4j-admin import \
        --database $IMPORT_TO.db \
        --ignore-missing-nodes \
        --nodes "header-inchi-nodes.csv,inchi-nodes.csv.gz" \
        --nodes "header-isomol-nodes.csv,isomol-nodes.csv.gz" \
        --nodes "header-nodes.csv,nodes.csv.gz" \
        --nodes "header-suppliermol-nodes.csv,suppliermol-nodes.csv.gz" \
        --nodes "header-supplier-nodes.csv,supplier-nodes.csv.gz" \
        --relationships "header-edges.csv,edges.csv.gz" \
        --relationships "header-isomol-molecule-edges.csv,isomol-molecule-edges.csv.gz" \
        --relationships "header-isomol-suppliermol-edges.csv,isomol-suppliermol-edges.csv.gz" \
        --relationships "header-molecule-inchi-edges.csv,molecule-inchi-edges.csv.gz" \
        --relationships "header-molecule-suppliermol-edges.csv,molecule-suppliermol-edges.csv.gz" \
        --relationships "header-suppliermol-supplier-edges.csv,suppliermol-supplier-edges.csv.gz" 

    echo "($ME) $(date) Imported."
else
    echo "($ME) $(date) Database '$IMPORT_TO' already exists."
fi

echo "($ME) $(date) Finished."
