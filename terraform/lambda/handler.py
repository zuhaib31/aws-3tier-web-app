import urllib.parse
import boto3

s3 = boto3.client("s3")


def handler(event, context):
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = urllib.parse.unquote_plus(record["s3"]["object"]["key"])
        size = record["s3"]["object"].get("size", 0)
        print(f"New object uploaded: s3://{bucket}/{key} ({size} bytes)")

        try:
            head = s3.head_object(Bucket=bucket, Key=key)
            print(f"Content-Type: {head.get('ContentType')}")
        except Exception as e:
            print(f"Could not read object metadata: {e}")

    return {"statusCode": 200, "body": "processed"}
