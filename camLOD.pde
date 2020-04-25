/**
 * 
 * based on
 * ASCII Video
 * by Ben Fry. 
 *
 * 
 * [+] and [-] change the LOD (level of detail)
 * 
 */

import processing.video.*;

Capture video;
boolean cheatScreen;

float[] bright;

int inc = 8;

void setup() {
  size(720, 405);
 
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start();  
  
  int count = video.width * video.height;
  //println(count);

}


void captureEvent(Capture c) {
  c.read();
}


void draw() {
  background(0);

  pushMatrix();
  
  scale(width/video.width, height/video.height);
  
  int index = 0;
  video.loadPixels();
  
  for (int y = 0; y < video.height; y+=inc) {

    for (int x = 0; x < video.width; x+=inc) {

      if (index > video.pixels.length-1) index = video.pixels.length-1;
      int pixelColor = video.pixels[index];

      // Faster method of calculating r, g, b than red(), green(), blue() 
      int r = (pixelColor >> 16) & 0xff;
      int g = (pixelColor >> 8) & 0xff;
      int b = pixelColor & 0xff;

      int pixelBright = max(r, g, b);

      // flip the camera
      int xPixel = video.width-x-(video.width%inc);
      if (video.width%inc == 0) {
        xPixel -= inc;
      } 
      
      noStroke();
      //fill(pixelBright);
      fill(pixelColor);
      rect(xPixel, y, inc, inc);

      index += inc;
    }

    if (video.width%inc != 0) index -= inc-(video.width%inc);
    index += ((inc-1) * video.width);

    if (index > video.pixels.length-1) index = video.pixels.length-1;
  }
  
  popMatrix();


  if (cheatScreen) {
    //image(video, 0, height - video.height);
    // set() is faster than image() when drawing untransformed images
    set(0, height - video.height, video);
  }
}


/**
 * Handle key presses:
 * 'c' toggles the cheat screen that shows the original image in the corner
 * 'g' grabs an image and saves the frame to a tiff image
 * 'f' and 'F' increase and decrease the font size
 */
public void keyPressed() {
  switch (key) {
  case 'g': 
    saveFrame(); 
    break;
  case 'c': 
    cheatScreen = !cheatScreen; 
    break;
  case '=': 
    inc += 2; 
    if (inc>40) inc=40; 
    break;
  case '-': 
    inc -= 2; 
    if (inc<2) inc=2; 
    break;
  }
}
