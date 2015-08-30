import json, httplib

temperatureClassName = 'Temperature'




if __name__ == '__main__':

    filepath = '/sys/devices/w1_bus_master1/28-0000052c4b73/w1_slave'
    f = open(filepath, 'r')
    data = f.read()

    print data
    print data

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