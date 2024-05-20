data "archive_file" "zip-python-code" {
    type = "zip"
    source_dir = "${path.module}/lambda_function/scheduler/"
    output_path = "${path.module}/lambda_function/scheduler/lambda_function.zip"
}

resource "aws_lambda_function" "xotocross-lambda-start-stop" {
    filename = "${path.module}/lambda_function/scheduler/lambda_function.zip"
    function_name = "xotocross-${var.xotocross-bucket-name}-lambda-start-stop"
    role = aws_iam_role.xotocross-role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
    tags = {
        name = "xotocross-${var.xotocross-bucket-name}-lambda-start-stop"
    }
}