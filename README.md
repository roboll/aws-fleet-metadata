# aws-fleet-metadata

Expose aws tags and metadata as fleet metadata.

## Requirements

* Access to the aws metadata service. (available from aws instances)
* `ec2:DescribeInstances` permission, configured for aws cli. (instance profile recommended)

## Usage

`aws-fleet-metadata` should be run as a prerequisite to `fleet`. The sample [drop-in](fleet-drop-in.conf) shows how to do this with `cloud-config`. `aws-fleet-metadata` outputs to stdout by default, but accepts a flag `-o` to output to file (general use case, to be used by `EnvironmentFile`).
