# A test database container image for fragnet-search
A graph database with built-in data based on our neo4j container image
used to run experimental tests with the fragnet search utility.

A simple test query for this database (and a screen shot of the results
when a few neighbouring nodes have been expanded) can be seen below: -

    match (a:Available {cmpd_id: 'MOLPORT:028-736-080'}) return a
    
![MOLPORT:028-736-080](028-736-080.png "MOLPORT:028-736-080")

# The data-loader files
We rely on our [fragalysis] graph processing playbooks to generate this
material. The files contained here should be in our S3 graph storage,
copied here for convenient building (it is a very small data set after all).

The origin of the current set of files is: -

    s3://im-fragnet/build/vendor/molport/2019-08/build-1

Consisting of: -

-   3,787 molecules
-   process_max_hac: 36
-   process_max_frag: 12
 
To get the files you can use the [AWS CLI]
(assuming you have suitable AWS credentials): -

    $ cd data-loader
    $ aws s3 sync s3://im-fragnet/build/vendor/molport/2019-08/build-1 .

>   The build may contain some extra files not needed by teh graph database
    These have been excluded (not committed).
    
1.  Importantly ... once downloaded make sure the `if` test early in the
    script checks for a database at `/data/databases`
    (it may be using ` /neo4j/graph`).
1.  The `supplier` nodes have been adjusted to contain a new `label` property.

## Generating the data-loader files
We used the `frag-processor` playbooks to run graph processing an a small
section of the original MolPort files . The parameters used
are in this project's `frag-processor-parameters` file and run using the
`run-graph-processor.sh` convenience script of the frag-processor utility
to produce **build-1**.

---

[aws cli]: https://pypi.org/project/awscli/
[fragalysis]: https://github.com/InformaticsMatters/fragalysis/tree/1-fragnet
