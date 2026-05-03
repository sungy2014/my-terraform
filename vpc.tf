# ------------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge({
    Name        = var.vpc_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Elastic IPs for NAT Gateways
# ------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = merge({
    Name        = "${var.vpc_name}-nat-eip-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# NAT Gateways (one per AZ for high availability)
# ------------------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge({
    Name        = "${var.vpc_name}-nat-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)

  depends_on = [aws_internet_gateway.this]
}

# ------------------------------------------------------------------------------
# Public Subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge({
    Name        = "${var.vpc_name}-public-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Private Subnets
# ------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge({
    Name        = "${var.vpc_name}-private-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Public Route Table
# ------------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge({
    Name        = "${var.vpc_name}-public-rt"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Public Route Table Associations
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ------------------------------------------------------------------------------
# Private Route Tables (one per AZ)
# ------------------------------------------------------------------------------
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge({
    Name        = "${var.vpc_name}-private-rt-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Private Route Table Associations
# ------------------------------------------------------------------------------
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ------------------------------------------------------------------------------
# VPC Flow Logs (security best practice)
# ------------------------------------------------------------------------------
resource "aws_flow_log" "this" {
  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.this.id

  tags = merge({
    Name        = "${var.vpc_name}-flow-logs"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  name              = "/aws/vpc/${var.vpc_name}/flow-logs"
  retention_in_days = 30

  tags = merge({
    Name        = "${var.vpc_name}-flow-logs-lg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_iam_role" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge({
    Name        = "${var.vpc_name}-flow-logs-role"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

resource "aws_iam_role_policy" "flow_logs" {
  name = "${var.vpc_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# Default Security Group - deny all traffic
# ------------------------------------------------------------------------------
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  ingress = []
  egress  = []

  tags = merge({
    Name        = "${var.vpc_name}-default-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# ------------------------------------------------------------------------------
# Default Network ACL - deny all traffic
# ------------------------------------------------------------------------------
resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress = []
  egress  = []

  tags = merge({
    Name        = "${var.vpc-name}-default-acl"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}