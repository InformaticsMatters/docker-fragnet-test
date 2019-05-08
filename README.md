# A test database container image for fragnet-search
A graph database with built-in data based on our neo4j container image
used to run experimental tests with the fragnet search utility.

# The data-loader files
We rely on our [fragalysis] graph processing playbooks to generate this
material. The files contained here should be in our S3 graph storage,
copied here for convenient building (it is a very small data set after all).

The origin of the current set of files is: -

    s3://im-fragnet/build/vendor/molport/2018-11/build-4

Consisting of: -

-   1,000 molecules
-   Minimum HAC of 12
-   Maximum HAC of 23
 
To get the files you can use the [AWS CLI]
(assuming you have suitable AWS credentials): -

    $ cd data-loader
    $ aws s3 sync s3://im-fragnet/build/vendor/molport/2018-11/build-4 .

---

[aws cli]: https://pypi.org/project/awscli/
[fragalysis]: https://github.com/InformaticsMatters/fragalysis/tree/1-fragnet
