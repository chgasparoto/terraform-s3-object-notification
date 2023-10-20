# Simple bucket with default settings

Configuration in this directory creates a simple S3 bucket with all default settings.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name      | Version  |
| --------- | -------- |
| terraform | >= 1.0.0 |
| aws       | >= 4.0   |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | >= 4.0  |

## Inputs

No input.

## Outputs

| Name | Description |
| ---- | ----------- |
| ARN  | Bucket ARN  |
