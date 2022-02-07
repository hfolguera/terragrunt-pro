locals {
  # Extract the needed variables for easy access on this file
  environment    = "pro"
  region         = "eu-frankfurt-1"
  os_namespace   = "frdv3joeh99d"
  os_bucket_name = "os-terraform-pro-001"
}

# Generate an OCI provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "oci" {
  region       = "${local.region}"
  # tenancy_ocid, user_ocid, fingerprint and private_key_path or private_key variables must be declared as environment variables
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an Object Storage bucket
remote_state {
  backend = "s3"
  config = {
    bucket                      = local.os_bucket_name
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = local.region
    endpoint                    = "https://${local.os_namespace}.compat.objectstorage.${local.region}.oraclecloud.com"
    encrypt                     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY variables must be declared as environment variables
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure root level configuration that all resources can inherit.
terraform {
  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=15m"]
  }
  extra_arguments "parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

