/* ImageProcessing.pde - Dario Breitenstein 2016                                                 */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This class provides multiple Image processing tools for the screenDemo sketch.                */

class ImageProcessing{
  private PImage frame;
  public ArrayList<PImage> zones;
  
  public ImageProcessing(PImage inputFrame){
    this.frame = inputFrame;  
    
    zones = new ArrayList<PImage>();
  }
  
  public PImage getFrame(){
    return frame;
  }

  public color[] getAverageColors(){
    if(zones.size() == 0) splitZones();
    //If it hasn't already happened for this image, split it into the predefined zones.
    
    color[] tempColors = new color[8];
    //Create a container for the average colors

    for(PImage zone : zones){
      tempColors[zones.indexOf(zone)] = getAverageColor(zone.pixels);
      //Get average color for each of the pixel arrays
    }
    
    color[] leftSideColors = {tempColors[0], tempColors[1], tempColors[2]};
    color[] rightSideColors = {tempColors[5], tempColors[6], tempColors[7]};
    //Combine color averages for left and right 'U' shapes
    
    color leftSide  = getAverageColor(leftSideColors);
    color rightSide = getAverageColor(rightSideColors);
    //...and calculate the average between the three parts for each side
     
    color[] colors = {leftSide, tempColors[3], tempColors[4], rightSide};
    //tempColors 3 and 4 are the left and right center colors
    
    return colors;
  }
  
  private void splitZones(){   
    int w = frame.width;
    int h = frame.height;
    
    zones.add(frame.get(0    , 0    , w/2  , h/4));
    zones.add(frame.get(0    , h/4  , w/8  , h/2));
    zones.add(frame.get(0    , h/4*3, w/2  , h/4));
    //Left 'U'

    zones.add(frame.get(w/8  , h/4  , w/8*3, h/2));
    //Left center

    zones.add(frame.get(w/2  , h/4  , w/8*3, h/2));
    //Right center

    zones.add(frame.get(w/2  , 0    , w/2  , h/4));
    zones.add(frame.get(w/8*7, h/4  , w/8  , h/2));
    zones.add(frame.get(w/2  , h/4*3, w/2  , h/4));
    //Right 'U'

    //There are eight actual rectangular zones. Three are for each of the left/right 'U' shapes, and one each for the center zones.
  }
  
  public void convertToEightBit(){
    PImage temp = new PImage(frame.width,frame.height);

    frame.loadPixels();
  
    for(int i = 0; i < frame.pixels.length; i++){
      EightBitColor eightbitColor = new EightBitColor(frame.pixels[i]); 
      temp.pixels[i] = eightbitColor.getColor();
      //Use the EightBitColor class to transform all the pixels to 8-bit color.
    }
  
    temp.updatePixels();
  
    this.frame = temp;
  }
  
  private color getAverageColor(color[] pixel){
    int averageR = 0;
    int averageG = 0;
    int averageB = 0;
    //Create counter variables for the three color components
  
    for(int i = 0; i < pixel.length; i++){
      averageR += pixel[i] >> 16 & 0xFF;
      averageG += pixel[i] >> 8  & 0xFF;
      averageB += pixel[i]       & 0xFF;

      //add up each of the red, green and blue parts for all colors in the pixel array
    }
  
    averageR /= pixel.length;
    averageG /= pixel.length;
    averageB /= pixel.length;
    //divide by the amount of pixels to get average color
  
    return color(averageR, averageG, averageB);
  }

}