import os
import json
import boto3

def lambda_handler(event, context):
    print("Received event:", event)
    data = json.loads(event['body'])
    name = data.get('name')
    email = data.get('email')
    ses = boto3.client('ses')
    recipient = os.environ['EMAIL_1']
    subject = "New NeoApp Event Registration"
    body = f"Name: {name}\nEmail: {email}"
    try:
        response = ses.send_email(
            Source=recipient,
            Destination={'ToAddresses': [recipient]},
            Message={
                'Subject': {'Data': subject},
                'Body': {'Text': {'Data': body}}
            }
        )
        print("SES response:", response)
    except Exception as e:
        print("SES error:", str(e))
        raise
    return {
        'statusCode': 200,
        'headers': {'Access-Control-Allow-Origin': '*'},
        'body': json.dumps({'message': 'Success'})
    }
