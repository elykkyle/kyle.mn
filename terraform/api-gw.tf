resource "aws_apigatewayv2_api" "visitor_count" {
  name          = "visitor-count-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["https://${terraform.workspace}.kyle.mn"]
  }
}

resource "aws_apigatewayv2_integration" "visitor_count" {
  api_id           = aws_apigatewayv2_api.visitor_count.id
  integration_type = "AWS_PROXY"

  description        = "Lambda visitor count."
  integration_method = "POST"
  integration_uri    = aws_lambda_function.visitor_count.invoke_arn
}

resource "aws_apigatewayv2_route" "visitor_count" {
  api_id    = aws_apigatewayv2_api.visitor_count.id
  route_key = "GET /visitorCount"
  target    = "integrations/${aws_apigatewayv2_integration.visitor_count.id}"
}

resource "aws_apigatewayv2_stage" "visitor_count" {
  api_id      = aws_apigatewayv2_api.visitor_count.id
  name        = "v1"
  auto_deploy = "true"
  route_settings {
    route_key              = aws_apigatewayv2_route.visitor_count.route_key
    throttling_burst_limit = "50"
    throttling_rate_limit  = "25"
  }
}

output "invoke_url" {
  value = aws_apigatewayv2_stage.visitor_count.invoke_url
}
output "api_uri" {
  value = aws_apigatewayv2_api.visitor_count.api_endpoint
}

output "api_id" {
  value = aws_apigatewayv2_api.visitor_count.id
}

output "api_route" {
  value = aws_apigatewayv2_route.visitor_count.route_key
}