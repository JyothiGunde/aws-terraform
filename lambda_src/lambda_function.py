import json
import boto3

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    # Loop over all S3 records
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']

        print(f"New object uploaded: {object_key} in bucket: {bucket_name}")

        # Optional: read the file from S3
        # obj = s3_client.get_object(Bucket=bucket_name, Key=object_key)
        # data = obj['Body'].read()
        # print(f"First 100 bytes: {data[:100]}")

    return {
        'statusCode': 200,
        'body': json.dumps('S3 event processed successfully!')
    }
