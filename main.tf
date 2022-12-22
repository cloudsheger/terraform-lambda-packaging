# Create a new variable "lambda_root" to set python function relative path
variable "lambda_root" {
  type        = string
  description = "The relative path to the source of the lambda"
  default     = "./src"
}

# This will install python dependencies
resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${var.lambda_root}/requirements.txt -t ${var.lambda_root}/"
  }
  
  triggers = {
    dependencies_versions = filemd5("${var.lambda_root}/requirements.txt")
    source_versions = filemd5("${var.lambda_root}/function.py")
  }
}

resource "random_uuid" "lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset(var.lambda_root, "function.py"),
      fileset(var.lambda_root, "requirements.txt")
    ):
        filename => filemd5("${var.lambda_root}/${filename}")
  }
}

  data "archive_file" "lambda_source" {
  depends_on = [null_resource.install_dependencies]
  excludes   = [
    "__pycache__",
    "venv",
  ]

  source_dir  = var.lambda_root
  output_path = "${random_uuid.lambda_src_hash.result}.zip"
  type        = "zip"
}
