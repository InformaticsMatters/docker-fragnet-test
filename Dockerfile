FROM informaticsmatters/neo4j:3.5

# Copy source data in (to be used to load the DB).
# This is the content of the data-loader directory.
COPY data-loader/ /data-loader/
RUN chmod 755 /data-loader/load-neo4j.sh

# Copy cypher-runner directory content
COPY cypher-script /cypher-script/

ENV NEO4J_dbms_directories_data /data
ENV IMPORT_DIRECTORY /data-loader
ENV IMPORT_TO graph
ENV EXTENSION_SCRIPT /data-loader/load-neo4j.sh

# We must always leave the WORKDIR
# to that expected by neo4j...
WORKDIR /var/lib/neo4j
