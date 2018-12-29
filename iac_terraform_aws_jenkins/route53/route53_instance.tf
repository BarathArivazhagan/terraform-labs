resource "aws_route53_record" "jenkins_route53_record" {
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.master_record_name}"
  type    = "A"

  alias {
    name                   = "${var.elb_dns_name}"
    zone_id                = "${var.elb_zone_id}"
    evaluate_target_health = false
  }
}


