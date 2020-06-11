# A test database container image for fragnet-search
A graph database with built-in data based on our neo4j container image
used to run experimental tests with the fragnet search utility.

    $ docker-compose build
    $ docker-compose up
    
A simple test query for this database (and a screen shot of the results
when a few neighbouring nodes have been expanded) can be seen below: -

    match (a:Available {cmpd_id: 'MOLPORT:028-736-080'}) return a
    
![MOLPORT:028-736-080](028-736-080.png "MOLPORT:028-736-080")

## The data-loader files
We rely on our [fragalysis] graph processing playbooks to generate this
material. The files contained here should be in our S3 graph storage,
copied here for convenient building.

The origin of the current set of files is: -

    s3://im-fragnet/build/vendor/molport/2019-08/build-2

Consisting of: -

-   3,787 molecules
-   process_max_hac: 36
-   process_max_frag: 12
 
## Generating the data-loader files
We used the graph processor's Cylc `workflow` to run graph processing an a
small section of the original MolPort files. The parameters used
are in this project's `frag-processor-parameters` file and are run by placing
is file in the graph cluster's `~/play` directory.

## Getting the data-loader files
To get the files you can use the [AWS CLI]
(assuming you have suitable AWS credentials): -

    $ BUILD=build/vendor/molport/2019-08/build-2
    $ aws s3 sync s3://im-fragnet/"$BUILD" data-loader

The downloaded files may contain some extra files not needed by the graph
database. These have been excluded (not committed) so you wil need to do
the same if you install a new file-set...

    $ rm data-loader/nodes.csv.gz \
         data-loader/done \
         data-loader/*.prov \
         data-loader/*.txt \
         data-loader/*.html \
         data-loader/rejected* \
         data-loader/excluded* \
         data-loader/*.executed \
         data-loader/*.report \
    $ rm -rf data/*

## Publishing a compiled graph
The graph database may take a few minutes to build indexes etc. To speed
things up then you need to capture and publish a pre-built graph. To do
this you will need to run a two Docker build steps - one to start a graph
service and compile the data and the second to build an image from this
compiled data.

Follow the steps above to get your chosen data into the data-loader directory
and then run: -

    (sudo) rm -rf data
    docker-compose rm graph
    docker-compose build
    docker-compose up

Stop (ctrl-c) the running container after the database has compiled and the
cypher scripts have executed, i.e. after you see: -

    [...] Remote interface available at http://localhost:7474/

and...

    [...] Touching /data-loader/cypher-runner.executed...
    [...] Finished.

With the container stopped the compiled graph data will be in
the data directory of this project. Build the second container
with: -

    (sudo) rm data/databases/store_lock
    docker-compose -f docker-compose-two.yml rm graph-2
    IMAGE_TAG=3.5-xchem-v1-extract docker-compose -f docker-compose-two.yml build

You can start the new pre-compiled image with: -

    IMAGE_TAG=3.5-xchem-v1-extract docker-compose -f docker-compose-two.yml up

or push it to docker hub: -

    IMAGE_TAG=3.5-xchem-v1-extract docker-compose -f docker-compose-two.yml push
 
---

[aws cli]: https://pypi.org/project/awscli/
[fragalysis]: https://github.com/InformaticsMatters/fragalysis/tree/1-fragnet
