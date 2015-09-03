import json, httplib, time, logging

temperatureClassName = 'Temperature'

import sys, os, time, atexit
from signal import SIGTERM

class Daemon:
    
    def __init__(self, pidfile, stdin='/dev/null', stdout='/dev/null', stderr='/dev/null'):
        
        self.stdin = stdin
        self.stdout = stdout
        self.stderr = stderr
        self.pidfile = pidfile

    def daemonize(self):
        
        try:
            
            pid = os.fork()
            if pid > 0:
                sys.exit(0)
    
        except OSError, e:
            
            sys.stderr.write("fork #1 failed: %d (%s)\n" % (e.errno, e.strerror))
            sys.exit(1)
        
        os.chdir("/")
        os.setsid()
        os.umask(0)
        
        try:
            
            pid = os.fork()
            if pid > 0:
                sys.exit(0)

        except OSError, e:
            
            sys.stderr.write("fork #2 failed: %d (%s)\n" % (e.errno, e.strerror))
            sys.exit(1)
        
        sys.stdout.flush()
        sys.stderr.flush()
        
        si = file(self.stdin, 'r')
        so = file(self.stdout, 'a+')
        se = file(self.stderr, 'a+', 0)
        
        os.dup2(si.fileno(), sys.stdin.fileno())
        os.dup2(so.fileno(), sys.stdout.fileno())
        os.dup2(se.fileno(), sys.stderr.fileno())
        
        atexit.register(self.delpid)
        pid = str(os.getpid())
        file(self.pidfile, 'w+').write("%s\n" % pid)

    def delpid(self):
        
        os.remove(self.pidfile)

    def start(self):
        
        try:
            
            pf = file(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        
        except IOError:
            
            pid = None

        if pid:
            
            message = "pidfile %s already exist. Daemon already running?\n"
            sys.stderr.write(message % self.pidfile)
            sys.exit(1)
        
        self.daemonize()
        self.run()

    def stop(self):
        
        try:
            
            pf = file(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        
        except IOError:
            
            pid = None

        if not pid:
            message = "pidfile %s does not exist. Daemon not running?\n"
            sys.stderr.write(message % self.pidfile)
            return
        
        try:
            
            while 1:
                os.kill(pid, SIGTERM)
                time.sleep(0.1)

        except OSError, err:
            
            err = str(err)
            if err.find("No such process") > 0:
                if os.path.exists(self.pidfile):
                    os.remove(self.pidfile)
            else:
                print str(err)
                sys.exit(1)

    def restart(self):
        
        self.stop()
        self.start()

    def status(self):

        try:
    
            pf = file(self.pidfile,'r')
            pid = int(pf.read().strip())
            pf.close()
        
        except IOError:
            
            pid = None

        if not pid:
            print 'Daemon is not running'
            return
                
        print 'Daemon is running'

    def run(self):

        logging.info('Started main loop')

        worker = ParseWorker()
        previousValue = worker.getLastTemperature()
        
        logging.info('Last temperature was: ' + str(previousValue))
        
        while 1:
            
            value = hardware.getTemperature()
            
            logging.debug('value - ' + str(value) + ' previous value - ' + str(previousValue))
            
            if abs(previousValue - value) > 0.5:
                previousValue = value
                worker.pushTemperatureValue(value)


class hardware:
    
    @staticmethod
    def getTemperature():
        
        filepath = '/sys/devices/w1_bus_master1/28-0000052c4b73/w1_slave'
        f = open(filepath, 'r')
        data = f.read()
        f.close()
        
        return float(data[data.find('t=')+2:])/1000

class ParseWorker:

    tail = {'X-Parse-Application-Id': 'VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU', 'X-Parse-REST-API-Key': 'v7WQplcOjunw6bTEM4P73k8P4HJqeiNenDxggrtw', 'Content-Type': 'application/json'}

    def __init__(self):
        
        self.connection = httplib.HTTPSConnection('api.parse.com', 443)
        self.connection.connect()

    def pushTemperatureValue(self, value):
        
        try:
            
            self.connection.request('POST', '/1/classes/' + temperatureClassName, json.dumps( {'value': value}), self.tail)
            self.connection.getresponse().read()

        except Exception as e:
            
            logging.warning(e)

    def getLastTemperature(self):
        
        self.connection.request('GET', '/1/classes/' + temperatureClassName, '', self.tail)
        result = json.loads(self.connection.getresponse().read())
        
        logging.debug('Retrived: ' + str(result))
        
        try:
            array = result['results']
            if len(array):
                return array[0]['value']

        except Exception as e:
            
            logging.warning(e)
            return 0

if __name__ == '__main__':

    daemon = Daemon('/tmp/neighborhood.pid')
    
    logfile = '/home/pi/neighbourhood.log'
    
    if os.path.exists(logfile):
        os.remove(logfile)
    
    logging.basicConfig(format = '%(levelname)s:%(asctime)s:%(message)s' ,level = logging.INFO, filename = logfile)

    if len(sys.argv) == 2:
        
        if 'start' == sys.argv[1]:
            daemon.start()
        
        elif 'stop' == sys.argv[1]:
            daemon.stop()
        
        elif 'restart' == sys.argv[1]:
            daemon.restart()
        
        elif 'status' == sys.argv[1]:
            daemon.status()
        
        else:
            print "Unknown command"
            sys.exit(2)
        
        sys.exit(0)

    else:
        
        print "usage: %s start|stop|restart|status" % sys.argv[0]
        sys.exit(2)


