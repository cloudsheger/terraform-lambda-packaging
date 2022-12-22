output source_code_hash {
  value = data.archive_file.lambda_source.output_base64sha256
}

output file_name {
  value = data.archive_file.lambda_source.output_path
}

