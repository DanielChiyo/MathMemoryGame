resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = format("%s VPC", var.project_name)
    Project = var.project_name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw"{
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = format("%s IGW", var.project_name)
    Project = var.project_name
    Environment = var.environment
  }
}

#Subnets
#Default creates 3 subnets
resource "aws_subnet" "public_subnets"{
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true 

  tags= {
    Name = format("%s Public Subnet %s", var.project_name, (count.index + 1))
    Project = var.project_name
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnets"{
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags= {
    Name = format("%s Private Subnet %s", var.project_name, (count.index + 1))
    Project = var.project_name
    Environment = var.environment
  }
}

#Route table and association

resource "aws_route_table" "rt_for_public_subnets" {
 vpc_id = aws_vpc.my_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
  tags = {
    Name = format("%s Route Table to IGW", var.project_name)
    Project = var.project_name
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_association" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.rt_for_public_subnets.id
}