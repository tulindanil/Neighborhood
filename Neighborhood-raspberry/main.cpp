#include <stdio.h>
#include <parse.h>

int main(int argc, char *argv[])
{
    ParseClient client = parseInitialize("VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU", "XCPG2OTVrapoymNGS5XGQIhsRM3F2tnVUgaceyec");
    
    char data[] = "{ \"value\": 165 }"; parseSendRequest(client, "POST", "/1/classes/Temperature", data, NULL);
    
    return 0;
}

