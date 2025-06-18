# NeoCloud Event Launch Landing Page

This project creates a live countdown landing page for the NeoApp launch, with event registration and AWS infrastructure managed by Terraform.

## Features
- Live countdown timer to launch
- Registration form (submits to Lambda, sends email to two addresses)
- Hosted on S3, delivered via CloudFront, custom domain via Route 53
- Infrastructure as Code (Terraform)

## Architecture
See `Architecture (1).png` for a visual overview.

## Directory Structure
```
event-launch/
|-- index.html
|-- style.css
|-- neocloud-logo.png
|-- Architecture (1).png
|-- terraform/
|   |-- s3.tf
|   |-- cloudfront.tf
|   |-- route53.tf
|   |-- lambda.tf
|   |-- iam.tf
|-- README.md
```

## Project Files Overview

### index.html
- Main landing page for the NeoApp launch event.
- Displays the NeoCloud logo (`neocloud-logo.png`).
- Shows a live countdown timer to the launch date.
- Includes a registration form for users to sign up for the event.
- The form submits data to an AWS Lambda function via an API Gateway endpoint (update the fetch URL in the script section after deployment).

### style.css
- Provides all styling for the landing page, including layout, colors, fonts, and responsive design.

### neocloud-logo.png
- Logo image displayed at the top of the landing page.

### Architecture (1).png
- Visual diagram of the AWS infrastructure and event flow.

### terraform/
- Contains Terraform scripts to provision AWS resources (S3, CloudFront, Route 53, Lambda, IAM).

## Setup Instructions

### Prerequisites
- AWS CLI configured
- Terraform installed
- AWS SES verified for sender emails

### 1. Deploy Infrastructure
```
cd terraform
terraform init
terraform apply
```

### 2. Lambda Function
- Write your Lambda handler (see below for sample)
- Package as `lambda_function_payload.zip` (containing `lambda_function.py`)
- Upload to S3 or update the Terraform file to point to the zip
- Run `terraform apply` again to deploy Lambda

### 3. Upload Website
- Upload `index.html`, `style.css`, `neocloud-logo.png`, and `Architecture (1).png` to the S3 bucket created by Terraform

### 4. Update API Endpoint
- After deployment, update the `fetch` URL in the `<script>` section of `index.html` to your API Gateway endpoint:
  ```js
  // In index.html, replace this URL with your deployed API Gateway endpoint
  const response = await fetch('https://xvhu3wgaa6.execute-api.us-east-1.amazonaws.com/prod/register', { ... });
  ```

### 5. Test
- Visit `https://event.monarchfashion.click` (or your subdomain) to view the site

## Lambda Function Example (Python)
```python
import os
import json
import boto3

def lambda_handler(event, context):
    data = json.loads(event['body'])
    name = data.get('name')
    email = data.get('email')
    ses = boto3.client('ses')
    recipients = [os.environ['EMAIL_1'], os.environ['EMAIL_2']]
    subject = "New NeoApp Event Registration"
    body = f"Name: {name}\nEmail: {email}"
    ses.send_email(
        Source=os.environ['EMAIL_1'],
        Destination={'ToAddresses': recipients},
        Message={
            'Subject': {'Data': subject},
            'Body': {'Text': {'Data': body}}
        }
    )
    return {
        'statusCode': 200,
        'headers': {'Access-Control-Allow-Origin': '*'},
        'body': json.dumps({'message': 'Success'})
    }
```

## Notes
- Make sure SES is verified for the sender and recipient emails.
- For production, consider using a custom SSL certificate in CloudFront.
- Update the API endpoint in `index.html` after deploying your backend.

## Credits
Solomon and Wodis made this project.
