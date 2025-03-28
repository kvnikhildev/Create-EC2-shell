#!/bin/bash

##############################################
# create EC2 instace using shell command 
# Auther :Nikhil
# Date :10/10/2020
# Version: V1 
#
############################################

#variable assigning 
AMI_ID="ami-084568db4383264d4"
Instance_type="t2.micro"
Key_name=KeypairCLI  # your pem key location 
Region="us-east-1"
security_group_name="ec2.ssh.access"

#set -x   display the use if needed 

#create default vpc to a variable
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[?IsDefault==\`true\`].VpcId" --output text)
echo "Default VPC pulled "

#Create security group in default vpc 

security_group_id=$(aws ec2 create-security-group --description "security group for AWS EC2" --group-name $security_group_name --vpc-id $VPC_ID --query "GroupId" --output text)
echo "Security group is created with default VPC"

#add rule to Security group
aws ec2 authorize-security-group-ingress --group-id $security_group_id --protocol tcp --port 22 --cidr 0.0.0.0/0
echo "Security group rules added."


#lanch instance 
instance_id=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $Instance_type --key-name $Key_name --region $Region --query "Instances[0].InstanceId" --output text)

#echo "instance is created "



#Extract public IP and private ip
Public_IP=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
Private_IP=$(aws ec2 describe-instances --instance-ids $instance_id --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)

#print instance ID
echo "instance_Id :$instance_id" > instance_details.txt

#print Ip adress 
echo "Public IP adress :$Public_IP" >> instance_details.txt
echo "Private IP adress :$Private_IP" >> instance_details.txt

# Security group ID
echo "security Group ID :$security_group_id" >> instance_details.txt
