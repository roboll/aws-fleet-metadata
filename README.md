# aws-fleet-metadata

Expose aws tags and metadata as fleet metadata.

## Requirements

* Access to the aws metadata service. (available from aws instances)
* `ec2:DescribeInstances` permission, configured for aws cli. (instance profile recommended)

## Usage

`aws-fleet-metadata` should be run as a prerequisite to `fleet`. The sample [fleet-drop-in.conf](drop-in) shows how to do this with `cloud-config`.

Alternatively, `aws-fleet-metadata` can output the data to a file (passed to `-o`) which can be passed to `fleet` as an `EnvironmentFile`.
