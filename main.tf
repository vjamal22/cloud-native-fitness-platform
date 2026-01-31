# -----------------------------
# DynamoDB Table
# -----------------------------
resource "aws_dynamodb_table" "user_profiles" {
  name         = "user_profiles"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}

# -----------------------------
# IAM Role for Lambda
# -----------------------------
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# -----------------------------
# IAM Policy for Lambda
# -----------------------------
resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Allow Lambda to write logs and access DynamoDB user_profiles table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ]
        Resource = aws_dynamodb_table.user_profiles.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# -----------------------------
# Lambda Function
# -----------------------------
resource "aws_lambda_function" "user_data_lambda" {
  function_name = "user-data-handler"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  filename         = "../Lambda/lambda_function_payload.zip"
  source_code_hash = filebase64sha256("../Lambda/lambda_function_payload.zip")

  role = aws_iam_role.lambda_execution_role.arn
}
