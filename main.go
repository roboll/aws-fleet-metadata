package main

import (
	"flag"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/ec2metadata"
	"github.com/aws/aws-sdk-go/service/ec2"
)

var (
	outputFile string
)

func init() {
	flag.StringVar(&outputFile, "o", "", "output file")
}

func main() {
	flag.Parse()

	output := []string{}

	instanceId, region := getInstanceIdAndRegion()
	output = append(output, "instance-id="+*instanceId)
	output = append(output, "region="+*region)

	tags := getTags(region, instanceId)
	for _, tag := range tags {
		output = append(output, tag)
	}

	if outputFile != "" {
		file, err := os.Create(outputFile)
		if err != nil {
			log.Fatal(err)
		}

		file.WriteString("FLEET_METADATA=" + strings.Join(output, ","))
	} else {
		os.Stdout.WriteString("FLEET_METADATA=" + strings.Join(output, ","))
	}
}

func getInstanceIdAndRegion() (*string, *string) {
	metadata := ec2metadata.New(&ec2metadata.Config{
		HTTPClient: &http.Client{
			Timeout: time.Duration(1 * time.Second),
		},
	})

	if !metadata.Available() {
		log.Fatal("AWS Metadata Service is not reachable.")
	}

	instanceId, err := metadata.GetMetadata("instance-id")
	if err != nil {
		log.Fatal(err)
	}

	region, err := metadata.Region()
	if err != nil {
		log.Fatal(err)
	}

	return &instanceId, &region
}

func getTags(region *string, instanceId *string) []string {
	output := []string{}

	service := ec2.New(&aws.Config{
		Region: region,
	})

	instances, err := service.DescribeInstances(&ec2.DescribeInstancesInput{
		InstanceIds: []*string{instanceId},
	})
	if err != nil {
		log.Fatal(err)
	}

	if len(instances.Reservations) > 1 {
		// more than one reservation isn't expected
		log.Fatal("Not Expected: Reservations > 1")
	}
	for _, res := range instances.Reservations {
		if len(res.Instances) > 1 {
			// more than one instance isn't expected
			log.Fatal("Not Expected: Instances > 1")
		}
		for _, instance := range res.Instances {
			for _, tag := range instance.Tags {
				output = append(output, *tag.Key+"="+*tag.Value)
			}
		}
	}
	return output
}
