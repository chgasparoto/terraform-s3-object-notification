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

| Name | Version |
|------|---------|
| terraform | >= 0.12.10 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.10 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
|ARN|Bucket ARN|