ARG from_tag=3.5
FROM informaticsmatters/neo4j:$from_tag

# Copy source data in (to be used to load the DB).
# This is the content of the data-loader directory.
WORKDIR /loaded-data
WORKDIR /graph-logs
COPY data-loader/ /data-loader/
RUN chmod 755 /data-loader/load-neo4j.sh && \
    chmod 777 /graph-logs

ENV NEO4J_dbms_directories_data /loaded-data
ENV NEO4J_dbms_directories_logs /graph-logs
ENV IMPORT_DIRECTORY /data-loader
ENV IMPORT_TO graph
ENV EXTENSION_SCRIPT /data-loader/load-neo4j.sh

# We must always leave the WORKDIR
# to that expected by neo4j...
USER 0
WORKDIR /var/lib/neo4j
