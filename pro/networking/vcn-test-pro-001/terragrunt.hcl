include {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "git::https://github.com/hfolguera/tf-module-vcn.git//."
}

inputs = {
    compartment_id   = "ocid1.compartment.oc1..aaaaaaaaf4l2fi7adshwd2pqsrdkwfxx7ffiv3mbvbdsig7si22uphizfmbq" # terraform_demo
    cidr_blocks  = ["192.168.2.0/24"]
    display_name = "vcn-test-pro-001"
}

