# aws-fleet-metadata

Expose aws tags and metadata as fleet metadata.

## Requirements

* Access to the aws metadata service. (available from aws instances)
* `ec2:DescribeInstances` permission, configured for aws cli. (instance profile recommended)

## Usage

`aws-fleet-metadata` should be run as a prerequisite to `fleet.service`. The sample [drop-in](fleet-drop-in.conf) and [service file](aws-fleet-metadata.service) show how to do this with `cloud-config`. `aws-fleet-metadata` outputs to stdout by default, but accepts a flag `-o` to output to file (general use case, to be used by `EnvironmentFile`).
