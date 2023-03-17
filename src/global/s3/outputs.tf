output "s3_bucket_arm" {
  value       = aws_s3_bucket.terraform-state.arn
  description = "The ARN of the S3 bucket"
}
output "dynaodb_table_arm" {
  value       = aws_dynamodb_table.terraform-locks.arn
  description = "The ARN of the DynamoDB table"
}