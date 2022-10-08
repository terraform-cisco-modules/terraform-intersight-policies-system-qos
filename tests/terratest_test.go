package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-policies-system-qos-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"apikey":        os.Getenv("IS_KEYID"),
		"secretkeyfile": os.Getenv("IS_KEYFILE"),
		"name":          instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	moid := terraform.Output(t, terraformOptions, "moid")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")

	//========================================================================
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"Name":        "{{ .name }}",
	"Description": "{{ .name }} System QoS Policy.",

	"Classes": [
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 10,
          "ClassId": "fabric.QosClass",
          "Cos": 255,
          "Mtu": 9216,
          "MulticastOptimize": false,
          "Name": "Best Effort",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": true,
          "Weight": 5
        },
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 14,
          "ClassId": "fabric.QosClass",
          "Cos": 1,
          "Mtu": 9216,
          "MulticastOptimize": false,
          "Name": "Bronze",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": true,
          "Weight": 7
        },
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 20,
          "ClassId": "fabric.QosClass",
          "Cos": 3,
          "Mtu": 2240,
          "MulticastOptimize": false,
          "Name": "FC",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": false,
          "Weight": 10
        },
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 18,
          "ClassId": "fabric.QosClass",
          "Cos": 4,
          "Mtu": 9216,
          "MulticastOptimize": false,
          "Name": "Gold",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": true,
          "Weight": 9
        },
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 20,
          "ClassId": "fabric.QosClass",
          "Cos": 5,
          "Mtu": 9216,
          "MulticastOptimize": false,
          "Name": "Platinum",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": false,
          "Weight": 10
        },
        {
          "AdminState": "Enabled",
          "BandwidthPercent": 18,
          "ClassId": "fabric.QosClass",
          "Cos": 2,
          "Mtu": 9216,
          "MulticastOptimize": true,
          "Name": "Silver",
          "ObjectType": "fabric.QosClass",
          "PacketDrop": true,
          "Weight": 8
        }
      ]
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/fabric/SystemQosPolicies/%s", moid), expectedJSONTemplate, vars)
}
