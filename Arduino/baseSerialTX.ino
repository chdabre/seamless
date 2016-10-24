/* baseSerialTX.ino - Dario Breitenstein 2016                                                    */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This Arduino code uses the RF24 library to relay color values received by serial to multiple  */
/* 2.4 GHz receivers.                                                                            */

#include <SPI.h>
#include "nRF24L01.h"
#include "RF24.h"
#include "printf.h"

RF24 radio(9,10);                         //Initialize radio on SPI pins 9,10

const uint64_t pipe = 0xF0F0F0F0E1LL;     //Define writing pipe address

struct COLORS{                            //Define payload structure
  uint8_t colors[4][3];                   //Colors array: 4 colors, each stored as 3 seperate bytes
};

void setup()
{
  
  Serial.begin(115200);                   //Initialize Serial connection at 115200 baud
  printf_begin();                         //Enable formatted serial output
  
  radio.begin();                          //Initialize radio

  radio.setRetries(15,15);                //Set retries and timeout for radio (15 x 4000us)
  radio.setChannel(100);                  //Set 2.4Ghz Channel
  
  radio.setPayloadSize(12);               //Define payload size as 12 bytes (4 x 3 byte color)

  radio.openWritingPipe(pipe);            //Initialize writing pipe
  radio.printDetails();                   //Print radio info to serial console
}

void loop() {
  if ( Serial.available() >= 14 )         //Wait until full data payload (12 bytes + Start/End byte is available from Serial buffer
  {
    if ( Serial.read() == 0xAA )          //Check if start byte is first byte in buffer 
    {  
      
      COLORS c;                           //Define Payload Object
  
      for ( int i = 0; i<4; i++ )         //Iterate through 4 x 3 byte colors
      {
        for ( int j = 0; j<3; j++ )
        {
          c.colors[i][j] = Serial.read(); //Read color info from Serial buffer and save to respective space in colors array
        }
      }

      if( Serial.read() == 0xBB )         //Check if End byte is final byte in buffer
      {
        /* START TRANSMISSION */
        radio.stopListening();            //For some reason, RF24 radios switch to write mode faster when switched manually
        
        radio.write( &c, sizeof(c) );     //Write payload to pipe
  
        radio.startListening();           //Switch back to read (= low power) mode 
        /* END TRANSMISSION */
      }
      else
      {
        Serial.println("ERROR: PAYLOAD END MISMATCH");
      }
    }
    else
    {
      Serial.println("ERROR: PAYLOAD START MISMATCH");
    }
  }
}
