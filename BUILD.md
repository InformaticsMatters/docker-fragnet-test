# Build instructions for the 3.5.25-xchem-combi-sample-2021-02 data

This file contains specific instructions for building our standard test
container image. The [README.md]() contains more general information.

## About the data

This is a small sample dataset expected to be used for testing.
It comprises the 768 molecules from the XChem DSI Poised library plus
500,000 molecules from ChemSpace.

The graph has...

-   1796195 nodes
-   6532060 relationships (edges)

The image size is about 3-4GiB.

We have also published this database to Docker Hub:

    informaticsmatters/fragnet-test:3.5.25-xchem-combi-sample-2021-02

## Fetching the data

The dataset can be found at: -

    s3://im-fragnet/extract/combination/xchem_combi_sample_2021_02/

To get the files from our bucket you can use the [AWS CLI]
(assuming you have suitable AWS credentials): -

    $ DATA_PATH=extract/combination/xchem_combi_sample_2021_02
    $ aws s3 sync s3://im-fragnet/"$DATA_PATH" data-loader

>   The input files go into the directory `data-loader`. This is not committed
to Git and it (and the compiled data tha we'll build) is excluded by the
project's `.gitignore`.

The above fileset (about 360MB) should contain 23 files, consisting
of a shell-script, 11 data files and 11 associated header files: -

    $ ls -1 data-loader | wc -l
    23

## Building the image

Ensure that you have no pre-existing graph by deleting the data directory it
creates (you may have to use sudo) and any pre-existing graph container: -

    $ rm -rf data
    $ docker rm fragnet-test

Now, build the custom graph image and start it...

    $ docker-compose build
    $ docker-compose up

The graph is ready to be used after you see the following on stdout: -

    fragnet-test | (cypher-runner.sh) [...] Finished.

You can use the graph now - it will be available at `http://localhost:7474`
with the username `neo4j` and password `test123`.

You can also stop (ctrl-c) and now quickly restart the graph
(`docker-compose up`), as the graph has been compiled into the local `data`
directory.

### Publishing the graph
If you need to publish the graph (to Docker Hub for example), for others to use,
you will need to build a new container image using the pre-compiled data
from the first.

The published image does not contain the original files, it just contains
the compiled database.

To build the container for publishing first stop (ctrl-c) the first graph.

>   The compiled graph files will be in the `data` directory of this project.

Now build the second container (providing a custom image tag) with: -

    $ rm data/databases/store_lock
    $ docker-compose -f docker-compose-two.yml rm graph-2
    $ IMAGE_TAG=3.5.25-xchem-combi-sample-2021-02 \
        docker-compose -f docker-compose-two.yml build

You can now start the new pre-compiled image with: -

    $ IMAGE_TAG=3.5.25-xchem-combi-sample-2021-02 \
        docker-compose -f docker-compose-two.yml up

Again, the graph is ready to use when you see the following: -

    fragnet-test-2 | (cypher-runner.sh) [...] Finished.

You can now also push the 2nd graph to docker hub. Remember that
this image is quite large at about 3-4GiB.

    $ IMAGE_TAG=3.5.25-xchem-combi-sample-2021-02 \
        docker-compose -f docker-compose-two.yml push

## Running a prebuilt container image
If all you want to do is run the prebuilt images do it like this:

    $ docker run -it -p 7474:7474 -p 7687:7687 -e GRAPH_PASSWORD=test123 \
        informaticsmatters/fragnet-test:3.5.25-xchem-combi-sample-2021-02

Then access it at [http://localhost:7474]()