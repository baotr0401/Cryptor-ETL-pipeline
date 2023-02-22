
# create a scheduled trigger that runs the glue job every 10 minutes 
resource "aws_glue_trigger" "this" {
  name     =  var.name
  schedule =  var.cron_expressions
  type     =  var.trigger_type

  actions {
    job_name = var.glue_job_name
  }

}
