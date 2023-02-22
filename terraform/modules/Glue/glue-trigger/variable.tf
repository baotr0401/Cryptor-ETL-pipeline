variable "name" {
  description = "name of trigger"
  type = string
}
variable "glue_job_name" {
  description = "name of glue job for triggering"
  type = string
}


variable "cron_expressions" {
  description = "triggered every 10 minutes"
  type = string
  default  = "cron(0/10 * * * ? *)"
}

variable "trigger_type" {
  description = "scheduled vs conditional"
  type = string
  default  = "SCHEDULED"
}
