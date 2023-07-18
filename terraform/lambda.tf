data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_execution" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:UpdateItem"
    ]
    resources = [aws_dynamodb_table.stats-db.arn]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${terraform.workspace}-iam_role_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_execution" {
  name        = "${terraform.workspace}-lambda_execution"
  description = "IAM policy for lambda to update DynamoDB table"
  policy      = data.aws_iam_policy_document.lambda_execution.json
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_execution.arn
}

data "aws_iam_policy_document" "lambda_logging" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${terraform.workspace}-lambda_logging"
  description = "IAM policy for lambda to send logs to CloudWatch"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

data "archive_file" "visitor_count" {
  type        = "zip"
  source_file = "${path.root}/../lambda/app.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "visitor_count" {
  filename      = "lambda_function_payload.zip"
  function_name = "${terraform.workspace}_increment_visitor_count"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.lambda_handler"

  source_code_hash = data.archive_file.visitor_count.output_base64sha256

  runtime = "python3.10"
}

resource "aws_lambda_permission" "visitor_count" {
  statement_id  = "${terraform.workspace}-AllowVisitorCountAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_count.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitor_count.execution_arn}/*"
}
