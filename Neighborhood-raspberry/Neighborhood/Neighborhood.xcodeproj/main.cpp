#include <iostream>
#include <fstream>

#include <fcntl.h>
#include <string>
#include <cstring>
#include <unistd.h>
//#include <parse.h>

class HardwareWorker
{
    
public:

    HardwareWorker()
    {
        #ifdef __arm__
        std::cout << "yop" << std:N:endl;
            in.open("/sys/bus/w1/devices/28-0000052c4b73/w1_slave");
        #endif
    }
    
    ~HardwareWorker()
    {
        #ifdef __arm__
            in.close();
        #endif
    }
    
    float getTemperature() const
    {
        std::string data = getRawTemperatureData();
        std::cout << data;
        return atoi(strstr("=t", data.c_str()) + 2);
    }
    
private:
    
    std::ifstream in;
    
    std::string getRawTemperatureData() const
    {
        std::string data;
        
        #ifdef __arm__
            data << in;
        #else
        
            int randomInstance = arc4random() % 10000 + 20000;
            data = "04 B3 43 t=" + std::to_string(randomInstance);
        
        #endif
        
        return data;
    }
    
};

float getTemperature()
{
    int FileDescriptor = open("/sys/bus/w1/devices/28-0000052c4b73/w1_slave", O_RDONLY);
    char buf[256];     // Data from device
    char tmpData[6];   // Temp C * 1000 reported by device
    tmpData[5] = '\0';
    read(FileDescriptor, buf, 256);
    strncpy(tmpData, strstr(buf, "t=") + 2, 5);
    float CurrentTempd = atoi(tmpData);
    float CurrentTemp = CurrentTempd / 1000;
    close(FileDescriptor);
    return CurrentTemp;
}

int main(int argc, char *argv[])
{
//    ParseClient client = parseInitialize("VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU", "XCPG2OTVrapoymNGS5XGQIhsRM3F2tnVUgaceyec");
//    
//    int childpid = fork();
//    
//    if (childpid == 0)
//    {
//        while (1)
//        {
//            float currentTemp = getTemperature();
//            char data[256];
//            sprintf(data, "{ \"value\": %f }", currentTemp);
//            parseSendRequest(client, "POST", "/1/classes/Temperature", data, NULL);
//        }
//    }
//    
//    printf("CHILDPID: %d\n", childpid);
    HardwareWorker worker;
    
    std::cout << worker.getTemperature();
    
    return 0;
}

