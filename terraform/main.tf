provider "aws" {
    region = "us-east-1"
}

#VPC
resource "aws_vpc" "main_vpc"{
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {Name = "ecommerce-vpc"}
}
#IGW
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.main_vpc.id
    tags = {Name = "ecommerce-igw"}
}
#PUBLIC SUBNET
resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {Name ="ecommerce-public-subnet"}
    map_public_ip_on_launch = true

}
#PRIVATE SUBNET
resource "aws_subnet" "private_subnet"{
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {Name ="ecommerce-private-subnet"}
}
#PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.main_vpc.id
        route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {Name = "ecommerce-public-rt"}
}
#ASSOCIATE PUBLIC SUBNET WITH ROUTE TABLE
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#SECURITY GROUP DB
resource "aws_security_group" "db_sg"{
    name = "ecommerce-db-sg"
    description = "Sadece vpc icinden erisilebilir"
    vpc_id = aws_vpc.main_vpc.id
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = [aws_vpc.main_vpc.cidr_block]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
}
#DB SUBNET GROUP
resource "aws_db_subnet_group" "default"{
    name = "ecommerce-db-subnet-group"
    subnet_ids = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]
    tags = { Name = "My DB Subnet Group" }
}
#RDS INSTANCE
resource "aws_db_instance" "default"{
    db_name = "ecommerce_db"
    allocated_storage = 20
    engine = "postgres"    
    instance_class = "db.t3.micro"
    username = "saitadmin"
    password = "Sait123456!"
    skip_final_snapshot = true
    publicly_accessible = false
    vpc_security_group_ids = [aws_security_group.db_sg.id]
    db_subnet_group_name = aws_db_subnet_group.default.name
}
#cıktı
output "db_endpoint" {
  value = aws_db_instance.default.endpoint
}
# --- BÖLÜM 3: BACKEND (LAMBDA & API GATEWAY) ---

# 11. IAM ROLE (Lambda'nın Kimliği)
resource "aws_iam_role" "lambda_role" {
  name = "ecommerce_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# 12. POLICY ATTACHMENT (Lambda'ya VPC'ye girme izni veriyoruz)
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# 13. ZIP FILE (Python kodunu paketle)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/backend"  # <-- DÜZELTİLEN YER (Klasör yolu)
  output_path = "lambda_function.zip"
}

# 14. LAMBDA FUNCTION (Aşçıyı Mutfağa Koyuyoruz)
resource "aws_lambda_function" "backend" {
  filename      = "lambda_function.zip"
  function_name = "ecommerce-backend"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10

  # KOD DEĞİŞİRSE GÜNCELLE
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # NETWORK AYARLARI (KRİTİK! Lambda'yı VPC'ye sokuyoruz)
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet.id]
    security_group_ids = [aws_security_group.db_sg.id]
  }

  # ORTAM DEĞİŞKENLERİ (Adresi buraya gömüyoruz)
  environment {
    variables = {
      DB_HOST = element(split(":", aws_db_instance.default.endpoint), 0)
      DB_PORT = "5432"
    }
  }
}

# 15. API GATEWAY (Dış Kapı - Lambda'yı İnternete Aç)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "ecommerce-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.backend.invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /" # Ana sayfaya gelince çalışsın
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# 16. PERMISSION (API Gateway Lambda'yı tetikleyebilsin)
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# 17. OUTPUT (Bize API Adresini Ver)
output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}
