# Terraform Infrastructure Project

## Overview

This project uses Terraform to create and manage AWS infrastructure components for hosting a simple web application. The infrastructure includes a Virtual Private Cloud (VPC), subnets, an AWS Internet Gateway, and security groups. Additionally, it deploys an EC2 server that installs Docker and runs an Nginx container using a shell script.

## Project Structure

The Terraform project is organized as follows:

feature/deploy-to-ec2-default-components branch - contains raw terraform project
feature/modules - contains the modularized terraform project
