# aws-fleet-metadata

Expose aws tags as fleet metadata.

## Requirements

* Access to the aws metadata service. (available from aws instances)
* `ec2:DescribeInstances` permission, configured for aws cli. (instance profile recommended)

## Usage

This container must be run before the fleet service starts. It will write fleet metadata to `/etc/fleet/aws-metadata`, which should then be passed to fleet as an `EnvironmentFile`. See the sample [service file](aws-fleet-metadata.service) and [fleet drop-in](21-aws-metadata.conf).

## Run

```
    docker run -v /etc/fleet:/etc/fleet roboll/aws-fleet-metadata
```

output: `/etc/fleet/aws-metadata`
