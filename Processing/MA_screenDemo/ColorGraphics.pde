/* ColorGraphics.pde - Dario Breitenstein 2016                                                   */
/* Begleitcode zur Maturarbeit "Surround-Licht fürs Heimkino: Entwicklung eines ’DIY’-Produktes" */
/*                                                                                               */
/* This class uses the PGraphics class to create a visual representation of four colors that     */
/* matches the zone layout used in ImageProcessing.                                              */

class ColorGraphics{

  public ColorGraphics(){
  }
  
  public PGraphics makeFrame(color[] colors, int w, int h){
    PGraphics out = createGraphics(w, h);
    //Create output Graphic
    
    out.beginDraw();
    
    out.noStroke();
    
    out.fill(colors[0]);
    
    out.beginShape();
    out.vertex(0    ,0    );
    out.vertex(w/2  ,0    );
    out.vertex(w/2  ,h/4  );
    out.vertex(w/8  ,h/4  );
    out.vertex(w/8  ,h/4*3);
    out.vertex(w/2  ,h/4*3);
    out.vertex(w/2  ,h    );
    out.vertex(0    ,h    );
    out.endShape(CLOSE);

    //Uses a polyshape to draw the left 'U' shape
    
    out.fill(colors[1]);
    
    out.beginShape();
    out.vertex(w/8  ,h/4  );
    out.vertex(w/2  ,h/4  );
    out.vertex(w/2  ,h/4*3);
    out.vertex(w/8  ,h/4*3);
    out.endShape(CLOSE);
    
    //Uses a polyshape to draw the left center shape

    out.fill(colors[2]);
    
    out.beginShape();
    out.vertex(w/2  ,h/4  );
    out.vertex(w/8*7,h/4  );
    out.vertex(w/8*7,h/4*3);
    out.vertex(w/2  ,h/4*3);
    out.endShape(CLOSE);
    
    //Uses a polyshape to draw the right center shape

    out.fill(colors[3]);
    
    out.beginShape();
    out.vertex(w/2  ,0    );
    out.vertex(w    ,0    );
    out.vertex(w    ,h    );
    out.vertex(w/2  ,h    );
    out.vertex(w/2  ,h/4*3);
    out.vertex(w/8*7,h/4*3);
    out.vertex(w/8*7,h/4  );
    out.vertex(w/2  ,h/4  );
    out.endShape(CLOSE);

    //Uses a polyshape to draw the right 'U' shape

    out.endDraw();
    
    return out;
  }
}