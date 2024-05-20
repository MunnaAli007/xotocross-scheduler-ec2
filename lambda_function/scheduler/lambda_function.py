import boto3
import json

region = 'eu-west-3'
instances = ['xotocross_bucket_name']
ec2 = boto3.client('ec2', region_name=region)

def get_instance_id(aws_bucket_instance_name):
    response = ec2.describe_instances()
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            if aws_bucket_instance_name in [tag["Value"] for tag in instance['Tags']]:
                return instance["InstanceId"]
    return None

def lambda_handler(event, context):
    instances_id = [get_instance_id(instance) for instance in instances]
    if 'operation' in event:
        if event['operation'] == 'start':
            ec2.start_instances(InstanceIds=instances_id)
            print('started your instances: ' + str(instances))
        elif event['operation'] == 'stop':
            ec2.stop_instances(InstanceIds=instances_id)
            print('stopped your instances: ' + str(instances))
        else:
            print('no operation matched')
    else:
        print('no operation detected')