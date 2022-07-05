# Vpc-project-via-terraform
This Project create VPC and 2 instance 1 is web-database and 2nd is database


1) VPC with cidr block 10.0.0.0/16 ( class A network) 

2) Creat a subnet 
    a) public-subnet  : 10.0.0.0/24
    b) private-subnet : 10.0.1.0/24

3)Public ip's for for nat and public-instance

4) Create a internet gateway 

5) Create Nat Gateway for database subnet (it will allow internet and stop internet to directrly associate to database ) 

6) Creating public and private route table for both subnet and igw

7) associate the 2 subnet to each route table

8) Create Scurity grp for vpc 

9) Create A key pair for both instance for connecting via ssh

10) Create A web instance in public subnet and database instance in private subnet


Note : For some how our database instance is not able to connect internet i am try to reslove this issue in futhure till you can use this single terraform script to create above infra in 1 go.
