#!/usr/bin/env bash

ME=cypher-runner.sh

if [ -f cypher.script ]
then

    echo "($ME) $(date) Processing cypher.script. Pre-neo4j pause..."
    sleep 4

    echo "($ME) $(date) Trying cypher.script..."
    until cat cypher.script | /var/lib/neo4j/bin/cypher-shell
    do
        echo "($ME) $(date) No joy, waiting..."
        sleep 4
    done
    echo "($ME) $(date) Script executed."

else
    echo "($ME) $(date) No cypher.script."
fi

echo "($ME) $(date) Finished."
