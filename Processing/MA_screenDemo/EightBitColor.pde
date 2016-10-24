/* ColorGraphics.pde - Dario Breitenstein 2016                                                   */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This class uses bit shifting to round 24-bit colors to 8-bit colors.                          */
/* The output is always a quantified 24-bit color value.                                         */

class EightBitColor{
  private color eightBitColor;
  
  public EightBitColor(color rgb){
    eightBitColor = toEightBit(rgb);
  }
  
  public color getColor(){
    return toRGB();
  }

  private color toRGB(){
    int inR =  eightBitColor              >> 5;
    int inG = (eightBitColor << 3 & 0xFF) >> 5;
    int inB = (eightBitColor << 6 & 0xFF) >> 6; 
  
    inR = round(map(inR,0,7,0,255));
    inG = round(map(inG,0,7,0,255));
    inB = round(map(inB,0,3,0,255));
    //use the map command to interpolate 8-bit values to 24-bit values

    return color(inR,inG,inB);
  }
  
  private color toEightBit(color rgb){
    int inR = rgb >> 16 & 0xFF;
    int inG = rgb >> 8  & 0xFF;
    int inB = rgb       & 0xFF; 
  
    return    ((inR >> 5) << 5) 
            + ((inG >> 5) << 2) 
            +  (inB >> 6);

    //use some bit shifting to drop digits from the 24-bit color value.
  }
  
}