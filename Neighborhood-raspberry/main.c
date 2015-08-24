#include <stdio.h>

#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <parse.h>

float getTemperature()
{
    int FileDescriptor = open("/sys/bus/w1/devices/28-0000052c4b73/w1_slave", O_RDONLY);
    char buf[256];     // Data from device
    char tmpData[6];   // Temp C * 1000 reported by device
    read(FileDescriptor, buf, 256);
    strncpy(tmpData, strstr(buf, "t=") + 2, 5);
    float CurrentTemp = strtod(tmpData, NULL);
    CurrentTemp = CurrentTemp / 1000;
    close(FileDescriptor);
    return CurrentTemp;
}

int main(int argc, char *argv[])
{
    ParseClient client = parseInitialize("VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU", "XCPG2OTVrapoymNGS5XGQIhsRM3F2tnVUgaceyec");
    
    int childpid = fork();
    
    if (childpid == 0)
    {
        while (1)
        {
            float currentTemp = getTemperature();
            char data[256];
            sprintf(data, "{ \"temperature\": %f }", currentTemp);
            parseSendRequest(client, "POST", "/1/classes/Temperature", data, NULL);
        }
    }
    
    printf("CHILDPID: %d\n", childpid);
    
    return 0;
}

