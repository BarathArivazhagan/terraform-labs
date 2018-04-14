data "aws_iam_role" "ecr_iam_role" {
   count = "${signum(length(var.roles)) == 1 ? length(var.roles) : 0}"
   name  = "${element(var.roles, count.index)}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "EC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecr_token_policy" {
  statement {
    sid     = "ECRGetAuthorizationToken"
    effect  = "Allow"
    actions = ["ecr:*"]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "default_ecr" {
  count = "${signum(length(var.roles)) == 1 ? 0 : 1}"

  statement {
    sid    = "ecr"
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${aws_iam_role.default.arn}",
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]
  }
}

data "aws_iam_policy_document" "resource" {
  count = "${signum(length(var.roles))}"

  statement {
    sid    = "ecr"
    effect = "Allow"

    principals = {
      type = "AWS"

      identifiers = [
        "${data.aws_iam_role.ecr_iam_role.*.arn}",
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
    ]
  }
}

resource "aws_ecr_repository" "repository" {
  name = "${var.ecr_name}"
}

resource "aws_ecr_repository_policy" "default" {
  count      = "${signum(length(var.roles))}"
  repository = "${aws_ecr_repository.repository.name}"
  policy     = "${data.aws_iam_policy_document.resource.json}"
}

resource "aws_ecr_repository_policy" "default_ecr" {
  count      = "${signum(length(var.roles)) == 1 ? 0 : 1}"
  repository = "${aws_ecr_repository.repository.name}"
  policy     = "${data.aws_iam_policy_document.default_ecr.json}"
}

resource "aws_iam_policy" "default" {
  name        = "${var.ecr_name}"
  description = "Allow IAM Users to call ecr:GetAuthorizationToken"
  policy      = "${data.aws_iam_policy_document.ecr_token_policy.json}"
}

resource "aws_iam_role" "default" {
  count              = "${signum(length(var.roles)) == 1 ? 0 : 1}"
  name               = "${var.ecr_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "default_ecr" {
  count      = "${signum(length(var.roles)) == 1 ? 0 : 1}"
  role       = "${aws_iam_role.default.name}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = "${signum(length(var.roles)) == 1 ? length(var.roles) : 0}"
  role       = "${element(var.roles, count.index)}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_instance_profile" "default" {
  count = "${signum(length(var.roles)) == 1 ? 0 : 1}"
  name  = "${var.ecr_name}"
  role  = "${aws_iam_role.default.name}"
}

resource "aws_ecr_lifecycle_policy" "default" {
  repository = "${aws_ecr_repository.repository.name}"

  policy = <<EOF
{
  "rules": [{
    "rulePriority": 1,
    "description": "Rotate images when reach ${var.max_image_count} images stored",
    "selection": {
      "tagStatus": "tagged",
      "tagPrefixList": ["${var.environment}"],
      "countType": "imageCountMoreThan",
      "countNumber": ${var.max_image_count}
    },
    "action": {
      "type": "expire"
    }
  }]
}
EOF
}

data "template_file" "docker_build_template" {
  template = "${var.template_source_path}"

  vars {
    ecr_repository_url = "${aws_ecr_repository.repository.repository_url}"
    ecr_repository_name = "${aws_ecr_repository.repository.name}"
  }
}


resource "null_resource" "docker_configuration" {


  provisioner "file" {
    destination = "${var.template_destination_path}"
    content = "${data.template_file.docker_build_template.rendered}"
  }

  provisioner "local-exec" {
    command = "sh ${var.template_destination_path}"
  }

  connection {


    type = "ssh"
    user = "${var.user}"
    private_key = "${file(var.private_key_path)}"
  }

}