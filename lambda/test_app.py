import unittest
from moto import mock_dynamodb
import boto3

from app import lambda_handler

@mock_dynamodb
class TestLambdaFunction(unittest.TestCase):
    def setUp(self):
        self.dynamodb = boto3.resource('dynamodb', region_name='us-east-2')
        self.table_name = 'cloud-resume-stats'

        try:
            self.dynamodb.Table(self.table_name).delete()
        except self.dynamodb.meta.client.exceptions.ResourceNotFoundException:
            print("table doesn't exist")

        self.dynamodb.create_table(
            TableName=self.table_name,
            KeySchema=[{'AttributeName': 'ip_hash', 'KeyType': 'HASH'}],
            AttributeDefinitions=[{'AttributeName': 'ip_hash', 'AttributeType': 'S'}],
            ProvisionedThroughput={'ReadCapacityUnits': 1, 'WriteCapacityUnits': 1}
        )
        self.table = self.dynamodb.Table(self.table_name)
        # self.table.put_item(Item={"stats": "viewCount", "viewCount": 0})

    def test_get_req(self):
        event = {'httpMethod': 'GET', 'requestContext': {'identity' : {'sourceIp': '192.168.1.1'}}}
        response = lambda_handler(event, None)
        body = response['body']

        self.assertEqual(response['statusCode'], 200)
        self.assertEqual(1, body)

if __name__ == '__main__':
    unittest.main()