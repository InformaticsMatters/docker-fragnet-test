# A custom Fragment Network graph database
This repository contains the commands necessary to create a Neo4j graph
database based on our [customised neo4j] container image that contains a
Fragment Network graph database. For information on the Fragment Network
look [here](https://fragnet.informaticsmatters.com/).

You will need to supply your own data - don't worry we provide
a recipe here based on some sample data we can provide - or you can ask
us for some data that suits your needs.

The resultant graph can be used locally to run experimental tests or
published to a container registry and then pulled elsewhere for others to use.

>   To build the sample dataset image you will need a _decent_ workstation
(at least 4 cores, 16Gi RAM) and at least 5GiB of free disk-space.

## The data files
This repository does not generally contain the actual graph data as the files are
typically huge. The data you use is a choice you have to make.

Our _sample data_ is held on AWS S3. You will need S3 credentials for access.

>   We rely on our [fragmentor] graph processing playbooks to generate input
data. The process produces nodes and relationships and corresponding
headers as well as a shell-script that is understood by our custom graph
image that bulk-loads the files. Informatics Matters have libraries that
can be used directly available on S3, but beware that these/graphs
generated from these source files can be very large.

The exceptions are those on the `dsip` branches where you will find a small sample dataset
that you can use to build a small database.

Other branches do not contain any data, but instead provide instructions for
obtaining it and for building the container images. Look at the `BUILD.md` file
on those branches for specific instructions.

Individual libraries are stored in our S3 bucket using a path
reflecting their `<vendor><version>` or `<vendor><library><version>`
name. Typically: -

    s3://im-fragnet/extract/molport/2020-12/
    s3://im-fragnet/extract/xchem/dsip/v1/

Combinations of libraries are stored under a suitable name in the bucket's
`extract/combination` folder.

The small sample dataset can be found at: -

    s3://im-fragnet/extract/combination/xchem_combi_sample_2021_02/

Look at the `xchem_combi_sample_2021_02` branch for instructions on building this.
The image is pushed to DockerHub as
`informaticsmatters/fragnet-test:3.5.25-xchem-combi-sample-2021-02`.
The image size is about 3-4GiB.

## Building your own image
Specific instructions are provided in each branch in the `BUILD.md` file.

## General process
Input files containing the node and edge Fragment Network data in CSV format
are placed in the `data-loader` directory.

This directory is mounted into our `informaticsmatters/fragnet-test:latest` container
image and load scripts do a bulk import into the Neo4j database and set the password
to the required value. See [https://github.com/InformaticsMatters/docker-neo4j/tree/master]()
for more details.

Those operations are performed by running

    docker compose up --build

The database files that are created are stored in a volume that is mounted from
`data` so once the import is complete and the container stopped that directory
contains a set of fully viable database files.

You can then access the graph at http://127.0.0.1:7474/browser/ and use the
default login and password (ne4j/neo4j) where you are forced to set a new password
that you can use for suture sessions.

With a password set you can also use `demo.py` that connects to the graph
to print the number of nodes. It assumes you have Python and a suitable neo4j package: -

    ./demo.py blob1234

Once that is complete a new container can be created that
copies the contents of the `data` directory to where Neo4j expects its database
files. That is done by running:

    $ docker compose -f docker-compose-two.yml build

The `IMAGE_TAG` environment variable specifies the tag name of the image that is
created. That image can be used locally or pushed to an image repository such as
DockerHub. The resulting image contains a fully initialised database, but does not
contain the CSV files that were imported, so it is relatively small and starts up
very quickly.

Specific instructions are found on the branches in the `BUILD.md` file.'
See, in particular the `dsip` and `xchem_combi_sample_2021_02` branches.

---

[aws cli]: https://pypi.org/project/awscli/
[xchem]: https://www.diamond.ac.uk/industry/Techniques-Available/Integrated-Structural-Biology/Fragment-Screening---XChem/Fragment-Libraries.html
[chemspace]: https://chem-space.com
[customised neo4j]: https://github.com/InformaticsMatters/docker-neo4j
[fragmentor]: https://github.com/InformaticsMatters/fragmentor
