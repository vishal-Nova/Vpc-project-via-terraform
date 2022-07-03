# Vpc-project-via-terraform
This Project create VPC and 2 instance 1 is web-database and 2nd is database


1) VPC with cidr block 10.0.0.0/16 ( class A network) 

2) Creat a subnet 
    a) public-subnet  : 10.0.0.0/24
    b) private-subnet : 10.0.1.0/24

3) Create a internet gateway 

4) Create Route table public and private route



1 database with private subnet ( internet via nat gateway ) 
1 web-instance with public subnet ( Internet via internet gateway ) 

(key for accesing both instance) 


