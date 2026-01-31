output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
}

output "lambda_function_name" {
  value = aws_lambda_function.user_data_lambda.function_name
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.user_profiles.name
}
