/**
 *   blobfinder  -  detect blobs of given color and size in videoimage
 */


  color samplecolor = color(165,169,144);//color(185,0,0);  // the color we are looking for (if zero, face color is a default)
  
  int xcr, ycr; // center of a found blob
  
  boolean HALFSIZE = true;
  boolean calibratesize = false;
  
  int blobW, blobH;  // size of colored block to be searched for  
  int time;
  
class Blobfinder {
  
  Blobfinder(PApplet parent)
  {
    //if(HALFSIZE) size(320,240);  // this is faster
    //else size(640, 480, P2D);
    cam = new Capture(parent, 200, 150);
  
    // default blob size (useful for nearby face)
    blobW = (int) (20);
    blobH = (int) (20);
  
    numPixelsX = width;
    numPixelsY = height;
    myMovieColors = new color[numPixelsX * numPixelsY];
    bw = new float[numPixelsX][numPixelsY];
    sums = new float[numPixelsX][numPixelsY];
    correl = new float[numPixelsX][numPixelsY];
    row = new float[numPixelsX];
      
    time = millis();
  }
  
  /*
  void preprocess() {
    if(!videoready) return;
  
    findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
  }
  */
  
  void piirraLaatikko(int x, int y) {
    
    if(!videoready) return;
  
    findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
    
    imageMode(CORNER);
    pushMatrix();
    translate(width, 0); // vaihtaa origon paikkaa
    scale(-1,1); // skaalataan pikselit
    image(cam, x, y, 200, 150);
    
    
        // if a blob is found, show it
    if(xcr > 0) {
      //siirretään blob kohdilleen
      xcr = x+xcr;
      ycr = y+ycr;
      println(xcr + " " + ycr);
      fill(255,255,50,100);
      ellipse(xcr,ycr, 10,10);
      stroke(255,255,50);
      noFill();
      beginShape();
      vertex(xcr-blobW/2, ycr-blobH/2);
      vertex(xcr-blobW/2, ycr+blobH/2);
      vertex(xcr+blobW/2, ycr+blobH/2);
      vertex(xcr+blobW/2, ycr-blobH/2);
      endShape(CLOSE);
      noStroke();
    }
      
      
    popMatrix();
    
    

  }
  
  /*
  void piirra()
  {
    if(!videoready) return;
  
    findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
    
    //background(0);
    // Flipataan videokuva ja blob x-akselin suhteen
    pushMatrix();
    translate(width, 0); // vaihtaa origon paikkaa
    scale(-1,1); // skaalataan pikselit
    image(cam, 0,0);
    
    
    // if a blob is found, show it
    if(xcr > 0) {
      fill(255,255,50,100);
      ellipse(xcr,ycr, 10,10);
      stroke(255,255,50);
      noFill();
      beginShape();
      vertex(xcr-blobW/2, ycr-blobH/2);
      vertex(xcr-blobW/2, ycr+blobH/2);
      vertex(xcr+blobW/2, ycr+blobH/2);
      vertex(xcr+blobW/2, ycr-blobH/2);
      endShape(CLOSE);
      noStroke();
  
  // this part tries to adaptively optimize the blob size - still experimental but may be developed...
      if(calibratesize) {    
      // check how well the blob size fits
      float maxfit = 0;
      for(int h=10;h<height;h+=5) {
        int w = (int)(h/sqrt(2));
        int s = w * h;
        // float c = correlate(xcr, ycr, w,h) / s;
        findcorrelation(w,h, 0,numPixelsX, 0,numPixelsY);
        if(maxcr > maxfit) maxfit = 0.8*maxcr + 0.2*maxfit;
        if(maxfit > 0 && maxcr < 0.5*maxfit) {
          blobW = w; blobH = h;
          break;
        }
        stroke(255,255,50);
        point(w,maxcr);
         stroke(h,0,255-h);
         point(xcr,ycr);
      }
      calibratesize = false;
      }
    }
    popMatrix(); // Matrix ulos
    videoready = false;
    //println(annaBlobinX()); // Printataan blobin korjatt x-koordinaatti
  }
  
  */
  
  int annaBlobinX(){
    
    int x = xcr*(-1) + (width/2);
    
    return x;
  }
  
}
