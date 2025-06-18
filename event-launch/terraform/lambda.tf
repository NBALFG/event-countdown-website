resource "aws_lambda_function" "form_handler" {
  filename         = "lambda_function_payload.zip"
  function_name    = "event-form-handler"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
  environment {
    variables = {
      EMAIL_1 = "solomonobi277@gmail.com"
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.form_handler.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_rest_api" "form_api" {
  name        = "EventFormAPI"
  description = "API for event registration form submissions"
}

resource "aws_api_gateway_resource" "register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  parent_id   = aws_api_gateway_rest_api.form_api.root_resource_id
  path_part   = "register"
}

resource "aws_api_gateway_method" "post_register" {
  rest_api_id   = aws_api_gateway_rest_api.form_api.id
  resource_id   = aws_api_gateway_resource.register.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.post_register.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.form_handler.invoke_arn
}

resource "aws_api_gateway_deployment" "form_api_deployment" {
  depends_on = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.form_api.id
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.form_api.id
  deployment_id = aws_api_gateway_deployment.form_api_deployment.id
}
