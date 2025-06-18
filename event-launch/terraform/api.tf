resource "aws_api_gateway_method" "options_register" {
  rest_api_id   = aws_api_gateway_rest_api.form_api.id
  resource_id   = aws_api_gateway_resource.register.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.options_register.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.options_register.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.options_register.http_method
  status_code = aws_api_gateway_method_response.options_register.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_method_response" "post_register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.post_register.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "post_register" {
  rest_api_id = aws_api_gateway_rest_api.form_api.id
  resource_id = aws_api_gateway_resource.register.id
  http_method = aws_api_gateway_method.post_register.http_method
  status_code = aws_api_gateway_method_response.post_register.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}
