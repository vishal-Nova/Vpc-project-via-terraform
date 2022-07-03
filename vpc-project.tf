provider "aws" {
region = "us-east-1"
}
#This is our main vpc

resource "aws_vpc" "vishal-vpc" { 
  cidr_block = "10.0.0.0/16"
}


#create a 2 subnet within vpc

resource "aws_subnet" "public-net" {
  vpc_id     = aws_vpc.vishal-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "web-subnet"
  }
}
resource "aws_subnet" "private-net" {
  vpc_id     = aws_vpc.vishal-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "database-subnet"
  }
}

#Public ip's for for nat and public-instance

resource "aws_eip" "nat-eip" {
  vpc      = true
}
resource "aws_eip" "web-eip" {
  instance = aws_instance.web.id
  vpc      = true
}

#Create Internet gateway for public-subent

resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.vishal-vpc.id

  tags = {
    Name = "web-instance"
  }
}

#Create Nat gateway for private-subnet

resource "aws_nat_gateway" "db-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.private-net.id
  
  tags = {
    Name = "db-instance"
  }

}

#Creating public and private route for both subnet and igw

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vishal-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }
  tags = {
    Name = "public-rt"
  }
}


resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vishal-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.db-nat.id
  }
  tags = {
    Name = "private-rt"
   }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.public-net.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.private-net.id
  route_table_id = aws_route_table.private-rt.id
}


#create Secrity group 
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vishal-vpc.id

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

#cretae a key for both instance
resource "aws_key_pair" "production" {
  key_name   = "production-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCaD6MQAYLZ8TAIIUJhXs/PSgAj3NmPRx2wwFgXR8It4zLK+1DUdpEqDe5LftTOW6FKcxPro1WJasbao600C/4NAm/PNRUNF3WxiLP3mmFQLjcrBXQr6x9Q1F49Iw8zC/duYxcMmM3zmapD7a2TXRD9K+Cj6yA7M8RiF+S3I/i74vuUWMESwgQhP0mChXEU+Qb5lxEd/vvn1nIhcWsdEr6OLyVuqAuGcPAvHT1W2kd5C2lnRtKLOk9EdiDQI0ZzmO36/U7kviUehb3KtSV91FLH0Mqe/O4Kg5gzDNhCoPyrxMTwLfBTYuBMSl9ARcYYg+w98t9ebgwTqzqP609ZwS89nxAtLH0+pbtnC+JxfmBlCJrmcb9GV6SdGGGH+ms7LZWcw8QHXDHX5EC2Co1oCRVMzWy4WRCvht2LUQAAGjGyE5xKaAvrVvdNDMreqxj+2U8wp6KVSnO7egIrvVTMPjIwc0ISGQV30732DTTQuG4MOfHL4H1HyiD2LG9vzwewZ48= root@TEQO-LT-070"

}

#create instance web and database 

resource "aws_instance" "web" {
  ami           = "ami-0cff7528ff583bf9a" # us-east-1
  instance_type = "t2.micro" 
  subnet_id	= aws_subnet.public-net.id
  vpc_security_group_ids   =  [aws_security_group.allow_ssh.id]
  key_name	=  aws_key_pair.production.id



  tags =   {
  Name = "web-india"
}	
	}


resource "aws_instance" "db" {
  ami           = "ami-0cff7528ff583bf9a" # us-east-1
  instance_type = "t2.micro" 
  subnet_id	= aws_subnet.private-net.id
  vpc_security_group_ids   =  [aws_security_group.allow_ssh.id]
  key_name	=  aws_key_pair.production.id



  tags =   {
  Name = "db-india"
}	
	}







