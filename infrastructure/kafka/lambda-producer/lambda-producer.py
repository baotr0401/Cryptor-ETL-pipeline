import json
from kafka import KafkaProducer, KafkaConsumer
from kafka.errors import NoBrokersAvailable
from typing import Any, Dict, List, Optional
import datetime
import logging
import sys
import requests
import json
import os
import time

topic = os.environ['TOPICS']
server = os.environ['BOOTSTRAP_SERVERS']
api_url = os.environ['API_URLS']
logger = logging.getLogger()
logger.setLevel(logging.INFO)
if len(logger.handlers) == 0:
    logger.addHandler(logging.StreamHandler())
class Broadcaster:

    def __init__(self):
        """
        Initial set up for the Kafka Producer
        """
        logger = logging.getLogger()
        logger.setLevel(logging.INFO)
        self.logger = logger

        while not hasattr(self, 'producer'):
            try:
                self.producer = KafkaProducer(bootstrap_servers=server)
    
            except NoBrokersAvailable as err:
                self.logger.error("Unable to find a broker: {0}".format(err))
                time.sleep(1)

    def push(self, message):
        """
        :param message: pushing messages to the kafka topics
        :return: None
        """
        self.logger.info("Publishing: {0}".format(message))
        try:
            if self.producer:
                self.producer.send(topic, bytes(json.dumps(message,default=str).encode('utf-8')
                                  ))
                self.producer.flush()
        except AttributeError:
            self.logger.error("Unable to send {0}. The producer does not exist."
                              .format(message))

def get_utc_from_unix_time(
    unix_ts: Optional[Any], second: int = 1000
) -> Optional[datetime.datetime]:
    return (
        datetime.datetime.utcfromtimestamp(int(unix_ts) / second)
        if unix_ts
        else None
    )   

def get_exchange_data() -> List[Dict[str, Any]]:
    url = api_url
    try:
        r = requests.get(url)
    except requests.ConnectionError as ce:
        logging.error(f"There was an error with the request, {ce}")
        sys.exit(1)
    data = r.json().get('data', [])
    for d in data:
        d['update_dt'] = get_utc_from_unix_time(d.get('updated'))
    return data

def post_event():
    dispatcher = Broadcaster()
        
    data = get_exchange_data()
    for request_json in data:
        logger.info("request had the following data: {0}".format(request_json))
        dispatcher.push(request_json)
        time.sleep(10)

def lambda_handler(event, context):
    # TODO implement
    post_event()
    print('sent')
    return {
        'statusCode': 200,
        'body': json.dumps('Sent')
    }
