/* MA_screenDemo.pde - Dario Breitenstein 2016                                                   */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This Processing sketch takes screenshots, calculates color averages for 4 preset zones and    */
/* transmits them to an Arduino via Serial.                                                      */

import processing.serial.*;

import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Rectangle;

Serial serial;

void setup(){
  size(240,135,FX2D);
  surface.setAlwaysOnTop(true);
  //Open a very small window

   println(Serial.list());
   serial = new Serial(this, Serial.list()[3], 115200);
   //Initialize Serial connection at 115200 baud
}

void draw(){
  PImage thisFrame = screenShot();
  //Take a screeenshot and store it in a PImage Object

  thisFrame.resize(width,height);
  //Resize the Image to make processing faster. Resizing the image also helps smoothing by removing detail.
  
  ImageProcessing thisFrameProcessing = new ImageProcessing(thisFrame.get());
  //Initialize ImageProcessing Object with the current Frame
  
  thisFrameProcessing.convertToEightBit();
  //Convert Image to 8-bit colors

  color[] colors = thisFrameProcessing.getAverageColors();
  //Calculate average colors and store them in an array
  
  sendColors(colors);
  //Transmit color values
  
  image(new ColorGraphics().makeFrame(colors, width, height), 0, 0);
  //Create a visual representation of the colors in the Processing frame using the ColorGraphics Class
  
  println(frameRate);
  //Debug framerate
}

void sendColors(color[] colors) {
  serial.write(0xAA);
  //Write Start byte

  for(int c = 0; c<4; c++){
    //Iterate over colors array
    serial.write(colors[c] >> 16 & 0xFF);
    serial.write(colors[c] >> 8  & 0xFF);
    serial.write(colors[c]       & 0xFF);
    //Write red, green and blue parts
  }
  serial.write(0xBB);
  //Write stop byte
}

PImage screenShot() {
  PImage screenshot = new PImage(0,0,RGB);
  //Create container for screenshot
  try{
    Robot robot = new Robot();
    screenshot = new PImage(robot.createScreenCapture(new Rectangle(0,0,displayWidth,displayHeight)));
    //Use the Java AWT Robot class to take a screenshot and store it in the container
  }
  catch (AWTException e){
    println("Screenshot error");
  }
  return screenshot;
}