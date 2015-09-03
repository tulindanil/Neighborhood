import json, httplib
import time

temperatureClassName = 'Temperature'

class hardware:
    
    @staticmethod
    def getTemperature():
        
        filepath = '/sys/devices/w1_bus_master1/28-0000052c4b73/w1_slave'
        f = open(filepath, 'r')
        data = f.read()
        f.close()
        
        return float(data[data.find('t=')+2:])/1000

class ParseWorker:

    parseapi = 'api.parse.com'

    tail = {'X-Parse-Application-Id': 'VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU', 'X-Parse-REST-API-Key': 'v7WQplcOjunw6bTEM4P73k8P4HJqeiNenDxggrtw', 'Content-Type': 'application/json'}
    connection = httplib.HTTPSConnection('api.parse.com', 443)

    def __init__(self):

        self.connection.connect()

    def pushTemperatureValue(self, value):

        self.connection.request('POST', '/1/classes/' + temperatureClassName, json.dumps( {'value': value}), self.tail)


if __name__ == '__main__':

    worker = ParseWorker()
    worker.pushTemperatureValue(hardware.getTemperature())