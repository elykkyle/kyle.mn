import json
import os
import boto3
import logging
import ipaddress

def lambda_handler(event, context):
    table_name = os.environ.get("TABLE_NAME") or 'cloud-resume-stats'

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)


    try:
        ip_address = event['requestContext']['identity']['sourceIp']
        ip_address = ipaddress.ip_address(ip_address)
        ip_hash = str(hash(ip_address))
        try:
            get_ip_hash = table.get_item(Key={
                'ip_hash': ip_hash
            })

            if 'Item' not in get_ip_hash.keys():
                print(f'Adding new item. Hash: {ip_hash}')
                req = table.put_item(
                    Item={
                        'ip_hash': ip_hash,
                    })
        except Exception as e:
            logging.exception("Error while updating table: ", e)
            return {
                'statusCode': 500,
                'body': json.dumps('Oops! Something went wrong!')
            }
    except ValueError:
        logging.exception(f'Address is invalid: {ip_address}')

    response = table.scan()

    if 'Items' in response.keys():
        items = response['Items']
        return {
            'statusCode': 200,
            'body': len(items)
        }
    else:
        return {
            'statusCode': 200,
            'body': 0
        }