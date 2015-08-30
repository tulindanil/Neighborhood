import json, httplib
import time

temperatureClassName = 'Temperature'

class Hardware:

    @staticmethod
    def getTemperature():

        filepath = '/sys/devices/w1_bus_master1/28-0000052c4b73/w1_slave'
        f = open(filepath, 'r')
        data = f.read()
        f.close()

        return data.find('t=')[2]


if __name__ == '__main__':
    
    while 1:
        print Hardware.getTemperature()
        time.sleep(2)

#    connection = httplib.HTTPSConnection('api.parse.com', 443)
#
#    try:
#
#        connection.connect()
#        connection.request('POST', '/1/classes/' + temperatureClassName, json.dumps( {'value': 24.57}), {
#                           'X-Parse-Application-Id': 'VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU',
#                           'X-Parse-REST-API-Key': 'v7WQplcOjunw6bTEM4P73k8P4HJqeiNenDxggrtw',
#                           'Content-Type': 'application/json'
#                           })
#        results = json.loads(connection.getresponse().read())
#        print results
#
#    except:
#
#        print 'No internet connection'