output "eventbridge_arn"{
    value = aws_cloudwatch_event_rule.interval_rule.arn
}