terraform {
  backend "s3" {
    bucket = "ana-terraform-state"
    key = "website-gawn/terraform.tfstate"
    profile = "default"
    region = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  region = "us-east-1"
  alias = "us-east-1"
}

module "website" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/static-website/"

  cert-domain = "gawn.uk"
  site-name = "website-gawn"
  site-domains = ["gawn.uk", "www.gawn.uk", "gawn.co.uk", "www.gawn.co.uk", "gawn.dev", "www.gawn.dev"]
  root = "index.html"
  github-repo = "https://github.com/jamesgawn/gawn.git"
}

data "aws_route53_zone" "gawn_uk" {
  name         = "gawn.uk."
}

module "gawn_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_uk.zone_id
  name = data.aws_route53_zone.gawn_uk.name
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}

module "www_gawn_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_uk.zone_id
  name = "www.${data.aws_route53_zone.gawn_uk.name}"
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}

data "aws_route53_zone" "gawn_co_uk" {
  name         = "gawn.co.uk."
}

module "gawn_co_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_co_uk.zone_id
  name = data.aws_route53_zone.gawn_co_uk.name
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}

module "www_gawn_co_uk" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_co_uk.zone_id
  name = "www.${data.aws_route53_zone.gawn_co_uk.name}"
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}

data "aws_route53_zone" "gawn_dev" {
  name         = "gawn.dev."
}

module "gawn_dev" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_dev.zone_id
  name = data.aws_route53_zone.gawn_dev.name
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}

module "www_gawn_dev" {
  source = "github.com/jamesgawn/ana-terraform-shared.git/dns/dualstackaliasrecord"

  zone_id = data.aws_route53_zone.gawn_dev.zone_id
  name = "www.${data.aws_route53_zone.gawn_dev.name}"
  alias-target = module.website.domain_name
  alias-hosted-zone-id = module.website.hosted_zone_id
}
