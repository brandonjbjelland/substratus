#!/bin/bash

set -e
set -u

# Required env variables:
: "$TOKEN $PROJECT $REGION $ZONE"

# Used by gcloud:
export CLOUDSDK_AUTH_ACCESS_TOKEN=${TOKEN}
# Used by terraform:
export GOOGLE_OAUTH_ACCESS_TOKEN=${TOKEN}

bucket=${PROJECT}-substratus

# TODO: Delete workspaces and wait for resources to be deleted before deleting cluster.

# Delete infrastructure.
cd terraform/gcp
echo "bucket = \"${bucket}\"" >>backend.tfvars
echo "project_id = \"${PROJECT}\"" >>terraform.tfvars
echo "region = \"${REGION}\"" >>terraform.tfvars
echo "zone = \"${ZONE}\"" >>terraform.tfvars
terraform init -upgrade --backend-config=backend.tfvars
terraform destroy
cluster=$(terraform output --raw cluster_name)
cd -