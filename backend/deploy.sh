#!/bin/bash

echo "=== Lambda Deploy Basliyor ==="
echo "Bu lambda fonksiyonu mock veri kullanılarak test için olusturuluyor."

FUNCTION_NAME="prestige-backend"
ROLE_NAME="prestige-backend-role"
ZIP_FILE="function.zip"

echo "[1] Kod zipleniyor..."
zip $ZIP_FILE index.py

echo "[2] IAM rolu olusturuluyor..."
aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document file://trust-policy.json

echo "[3] Policy ekleniyor..."
aws iam attach-role-policy \
  --role-name $ROLE_NAME \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

echo "[4] Rol ARN aliniyor..."
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query "Role.Arn" --output text)
echo "Rol ARN: $ROLE_ARN"

echo "AWS 15 saniye beklenecek"
sleep 15

echo "[5] Lambda fonksiyonu olusturuluyor..."
aws lambda create-function \
    --function-name $FUNCTION_NAME \
    --zip-file fileb://$ZIP_FILE \
    --handler index.lambda_handler \
    --runtime python3.9 \
    --role $ROLE_ARN

echo "[6] URL ekleniyor..."
aws lambda create-function-url-config \
  --function-name $FUNCTION_NAME \
  --auth-type NONE \
  --cors '{"AllowOrigins": ["*"], "AllowMethods": ["GET"]}'    

echo "[7] Public izin veriliyor..."
aws lambda add-permission \
    --function-name $FUNCTION_NAME \
    --action lambda:InvokeFunctionUrl \
    --statement-id AllowPublic \
    --principal "*" \
    --function-url-auth-type NONE

echo "[8] API URL'in:"
aws lambda get-function-url-config \
  --function-name $FUNCTION_NAME \
  --query "FunctionUrl" \
  --output text    