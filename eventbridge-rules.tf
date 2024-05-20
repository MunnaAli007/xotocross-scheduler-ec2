resource "aws_cloudwatch_event_rule" "xotocross-cloudwatch-start" {
    name = "xotocross-${var.xotocross-bucket-name}-cloudwatch-start"
    description = "xotocross trigger Lambda function to start EC2 instances"
    schedule_expression = "cron(*/19 * * * ? *)"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_event_rule" "xotocross-cloudwatch-stop" {
    name = "xotocross-${var.xotocross-bucket-name}-cloudwatch-stop"
    description = "xotocross trigger Lambda function to stop EC2 instances"
    schedule_expression = "cron(*/23 * * * ? *)"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_event_target" "xotocross-start" {
    arn = aws_lambda_function.xotocross-lambda-start-stop.arn
    rule = aws_cloudwatch_event_rule.xotocross-cloudwatch-start.name
    input = <<JSON
    {"operation":"start"}
JSON
}

resource "aws_cloudwatch_event_target" "xotocross-stop" {
    arn = aws_lambda_function.xotocross-lambda-start-stop.arn
    rule = aws_cloudwatch_event_rule.xotocross-cloudwatch-stop.name
    input = <<JSON
    {"operation":"stop"}
JSON
}

resource "aws_lambda_permission" "xotocross-start-permission" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.xotocross-lambda-start-stop.arn
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.xotocross-cloudwatch-start.arn
}

resource "aws_lambda_permission" "xotocross-stop-permission" {
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.xotocross-lambda-start-stop.arn
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.xotocross-cloudwatch-stop.arn
}