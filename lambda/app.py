import json
import boto3


client = boto3.client("dynamodb")
table_name = "cloud-resume-stats"


def lambda_handler(event, context):
    global table_name
    data = client.update_item(
        TableName=table_name,
        Key={"stats": {"S": "viewCount"}},
        UpdateExpression="SET viewCount = viewCount + :i",
        ExpressionAttributeValues={":i": {"N": "1"}},
        ReturnValues="UPDATED_NEW",
    )

    return {"statusCode": 200, "body": json.dumps(data["Attributes"])}
