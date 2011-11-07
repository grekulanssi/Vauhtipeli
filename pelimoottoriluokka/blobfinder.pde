/**
 *   blobfinder  -  detect blobs of given color and size in videoimage
 */


  color samplecolor = color(185,0,0);  // the color we are looking for (if zero, face color is a default)
  
  int xcr, ycr; // center of a found blob
  
  int showmode = 0;  // 0 = original image, 1 = pixels with found color, 2 = cumulative sums, 3 = correlation with searched blob
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
    blobW = (int) (0.22 * width);
    blobH = (int) (0.4 * height);
    
    blobW = blobH = 50;
  
    numPixelsX = width;
    numPixelsY = height;
    myMovieColors = new color[numPixelsX * numPixelsY];
    bw = new float[numPixelsX][numPixelsY];
    sums = new float[numPixelsX][numPixelsY];
    correl = new float[numPixelsX][numPixelsY];
    row = new float[numPixelsX];
      
    time = millis();
  }
  
  void preprocess() {
    if(!videoready) return;
  
    findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
  }
  
  
  void piirra()
  {
    if(!videoready) return;
  
    findcorrelation(blobW,blobH, 0,numPixelsX, 0,numPixelsY);  // preprocessing
    
    background(0);
    // Flipataan videokuva ja blob x-akselin suhteen
    pushMatrix();
    translate(width, 0); // vaihtaa origon paikkaa
    scale(-1,1); // skaalataan pikselit
    image(cam, 0,0);
    
    if(showmode > 0)
    for (int j = 0; j < numPixelsY; j++) {
      for (int i = 0; i < numPixelsX; i++) {
        if(showmode == 1) stroke(bw[i][j]);
        if(showmode == 2) stroke(255 * sums[i][j]/total);
        if(showmode == 3) stroke(255*(correl[i][j] - mincr)/(maxcr-mincr));
        point(i,j);
      }
    }
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
    speedmeter();
    println(annaBlobinX()); // Printataan blobin korjatt x-koordinaatti
  }
  
  void speedmeter()
  // visually show the frame time in tens of milliseconds, to check efficiency
  {
    int now = millis();
    int frametime = now - time;
    time = now;
    if(frametime < 0) frametime += 1000;
    int tens = frametime / 10;
    // println(tens+" "+frametime);
    for(int i=0;i<tens;i++) {
      noStroke();
      fill(0,255,0);             // <  50ms / frame is optimal
      if(i > 5) fill(255,255,0);
      if(i > 10) fill(255,0,0);  // > 100ms / frame gets bad
      rect(width-5,20*i, 5,5);
     }
  }
  
  
  void mousePressed()
  {
    if(showmode > 0) return;
    // store the color of pointed pixel as a new search reference
    else samplecolor = myMovieColors[mouseY*numPixelsX + mouseX];
  }
  void keyPressed()
  {
    if(key == '0') showmode = 0;
    if(key == '1') showmode = 1;
    if(key == '2') showmode = 2;
    if(key == '3') showmode = 3;
    if(key == 'c') calibratesize = true;
  }
  
  int annaBlobinX(){
    
    int x = xcr*(-1) + (width/2);
    
    return x;
  }
}
