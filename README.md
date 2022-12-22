# terraform-archive-python

## Packaging the Lambda
Our Lambda's dependencies to be packaged up with the source code so that aws_lambda_function can use it. Luckily, we can do this in Terraform using Terraform's null_resource and archive_file.