terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "~> 4.16"
		}
	}
	
	required_version = ">= 1.2.0"
}

provider "aws" {
	region = "us-east-1"
}

resource "aws_db_instance" "blog-app" {
	instance_type = "t2.micro"
	availability_zone = "us-east-1a"
	ami = "ami-40d28157"

	user_data = <<-EOF
			#!/bin/bash
			sudo service apache2 start
			EOF
}

resource "aws_db_instance" "db" {
	allocated_storage = 10
	engine = "mysql"
	instance_class = "db.t2.micro"
	name = "blog-appdb"
	username = "admin"
	password = "password"

}

resource "aws_elb" "load_balancer" {
	name = "frontend-load-balancer"
	instances = ["${aws_instance.blog-app.id}"]
	availability_zones = ["us-east-1a"]

	listener {
		instance_port = 8000
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}
}

