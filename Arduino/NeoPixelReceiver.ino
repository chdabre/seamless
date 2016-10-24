/* NeoPixelReceiver.ino - Dario Breitenstein 2016                                                */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This Arduino code uses the RF24 and FastLED libraries to display color data received through  */
/* a 2.4 GHz pipe using NeoPixels.                                                               */

#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include "printf.h"

#include <FastLED.h>

#define BTN_PIN     5

#define DATA_PIN    6
#define NUM_LEDS    7
#define LED_TYPE    WS2812
#define COLOR_ORDER GRB

#define BRIGHTNESS  255

#define GAMMA 2.8

const CRGB zoneColors[] = {CRGB(255,0,0), CRGB(0,255,0), CRGB(0,0,255), CRGB(255,0,255)};

CRGB leds[NUM_LEDS];

RF24 radio(9,10);

struct COLORS
{
  uint8_t colors[4][3];
};

const uint64_t pipe = 0xF0F0F0F0E1LL;

unsigned long timeout = 0;
int zone = 0;

void setup()
{
  pinMode( BTN_PIN, INPUT_PULLUP );
  
  FastLED.addLeds< LED_TYPE, DATA_PIN, COLOR_ORDER >( leds, NUM_LEDS ).setCorrection(TypicalLEDStrip);
  FastLED.setBrightness( BRIGHTNESS );

  allLeds( CRGB(0,0,0) );
  FastLED.show();

  Serial.begin(57600);
  printf_begin();
  
  radio.begin();
  radio.setRetries(15,15);
  radio.setChannel(100);

  radio.setPayloadSize(12);
  
  radio.openReadingPipe( 1, pipe );

  radio.startListening();
  
  radio.printDetails();
}


void loop() {
  pollButtons();
  
  if ( radio.available() )
  {
    timeout = millis();    
    
    COLORS c_got;
    bool done = false;
    while ( !done )
    {
      done = radio.read( &c_got, sizeof(c_got) );
        
      printf( "Got payload!" );
      delay(20);
    }

    allLeds( applyGamma_video( CRGB( c_got.colors[zone][0], c_got.colors[zone][1], c_got.colors[zone][2] ), GAMMA ) );

    FastLED.show();
  }
  else if ( millis() - timeout > 2000)
  {
    timeout = millis();
    
    if ( leds[0] != CRGB(0,0,0) ) fadeToBlack(30);
  }
}

void pollButtons(){
  if( digitalRead(BTN_PIN) == 0 )
  {
    zone++;
    if (zone > 3) zone = 0;

    printf( "Changing zone to %i", zone );
    
    allLeds( zoneColors[zone] );
    FastLED.show();
    
    delay(250);
    
    fadeToBlack(0);
  }
}

void allLeds(CRGB color)
{
  for(int i=0;i<NUM_LEDS;i++) 
  {
    leds[i] = color;
  }
}

void fadeToBlack(int d){
  for(int k = 0; k<20; k++){
      for(int i=0;i<NUM_LEDS;i++) 
      {
        leds[i].fadeToBlackBy(64);
        FastLED.show();
      }
      delay(d);
   }
}


