provider "aws" {
  region  = var.aws_region
  profile = "default"
}
resource "aws_cloudwatch_event_rule" "interval_rule" {
  name = "every-${var.rule_name}"
  description = var.description
  schedule_expression = var.expression
}

resource "aws_cloudwatch_event_target" "check_target" {
  rule = aws_cloudwatch_event_rule.interval_rule.name
  target_id = var.event_target_name
  arn = var.event_target_arn
    # module.lambda_function_producer_1.function_arn
}
