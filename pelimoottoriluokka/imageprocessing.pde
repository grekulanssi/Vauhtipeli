/**
 *   blobfinder  -  detect blobs of given color and size in videoimage
 */

import processing.video.*;

Capture cam;
int numPixelsX,numPixelsY;
color myMovieColors[];
boolean videoready = false;

// arrays telling for each pixel...
float bw[][];  // ...the amount of searched color
float sums[][];  // ...cumulative sums of the color within the image
float correl[][];  // ...how much a block centered at this pixel matches with the searched blob

float row[], total, maxval, mincr, maxcr;
float average;


// Read new values from videocam
void captureEvent(Capture c)
{
  if(!c.available()) return;
  c.read();
  c.loadPixels();
  for (int j = 0; j < numPixelsY; j++) {
    for (int i = 0; i < numPixelsX; i++) {
      myMovieColors[j*numPixelsX + i] = c.get(i, j);
    }
  }
  calculatesums();
  videoready = true;
}

// preprocerssing for efficient correlation later
void calculatesums()
{
  for(int j=0;j<numPixelsY;j++)
  for(int i=0;i<numPixelsX;i++)
  {
    // first find the color of interest
    // encode its amount in this pixel into 'value'
    color c = myMovieColors[j*numPixelsX + i];
    float value;
    float b = brightness(c);
    float h = hue(c);
    float s = saturation(c);
    if(brightness(samplecolor) > 0) {
      float bs = brightness(samplecolor);
      float hs = hue(samplecolor);
      float ss = saturation(samplecolor);
      float toler = 50;
      // look if the pixel color is close enough to the sample color; tolerance of the comparison can be tuned
      if(b > bs-toler && h > hs-toler && h < hs+toler && s > ss-toler && s < ss+toler) value = b; else value = 0;
    }
    // looking for face color, if no other sample is defined
    else {
      if((h < 20 || h > 230) && (s > 50 && s < 150) && b > 30) value = b;
      else if(b > 200) value = 200;  // this is to include bright reflections on the skin
      else
      {
        float dh = min(h-30, 230-h) / 255;
        float ds = min(50-s, s-150) / 255;
        float db = 50-b / 255;        
        value = dh*ds * b;
      }
      // thresholding
      if(value < 100) value = 0;
    }
// value = b;  // if looking just for brightness
    bw[i][j] = value;

    // then make acculumated sums along rows
    // NOTE: sums[i][j] tells the total amount of right color (= value) within rectangle (0,0, i,j)
    if(i == 0) row[i] = value; else row[i] = row[i-1] + value;
    if(j == 0) sums[i][j] = row[i]; else sums[i][j] = sums[i][j-1] + row[i];
  }
  // total amount of value in the picture
  total = sums[numPixelsX-1][numPixelsY-1];
}


void findcorrelation(int w, int h, int x1, int x2, int y1, int y2)
// search within limits (x1,x2, y1,y2) the maximal match with a block of size w x h
// encode result to array correl[][] 
{
  average = total / (float)(numPixelsX * numPixelsY);
  mincr = 100000;
  maxcr = -mincr;
  int blocksize = w * h;
  xcr = ycr = -1;
  
  for(int i=x1;i<x2;i++)
  for(int j=y1;j<y2;j++) {
      float c = (correlate(i,j, w,h) / blocksize) - average;
      correl[i][j] = c;
      if(c < mincr) mincr = c;
      if(c > maxcr) { maxcr = c; xcr = i; ycr = j; }
  }  
}

float correlate(int cx, int cy, int w, int h)
// this implements correlation very efficiently!
{
  // looking for a block centered at (cx,cy), use (x,y) for left-up corner of the block
  int x = cx - w/2;
  int y = cy - h/2;
  if(x < 0 || y < 0 || x > numPixelsX-1-w || y > numPixelsY-1-h) return 0;
  float c = (sums[x][y] + sums[x+w][y+h] - sums[x+w][y] - sums[x][y+h]);
  return c;
}



