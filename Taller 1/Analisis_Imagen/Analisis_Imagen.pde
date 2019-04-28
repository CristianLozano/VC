PImage img, gr, th, bl;  


void setup() {
  size(1100,800);
  img = loadImage("myImage.jpeg");
  gr = loadImage("myImage.jpeg");
  th = loadImage("myImage.jpeg");
  bl = loadImage("myImage.jpeg");

  //gr.filter(GRAY);
  //th.filter(THRESHOLD,0.72569);
  bl.filter(BLUR, 5);
}

void hist(PImage entrada) {
  int[] histo = new int[256];
  int[] deriv = new int[255];
  int[] deriv2 = new int[255];
  
  int posy = 0;
  int resx = 0;
  int resy = 0;
  
  if(entrada==img){
    resx = 550;
    resy = 0;
  } else if(entrada==gr){
    posy = 200;
    resx = 550;
    resy = 200;
  } else if(entrada==th){
    posy = 400;
    resx = 550;
    resy = 400;
  }
  if(entrada==bl){
    posy = 600;
    resx = 550;
    resy = 600;
  }
  
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        int bright = int(brightness(get(i, j+posy)));
        histo[bright]++; 
      }
    }
    
    for (int i = 0; i < 255; i++) {
      deriv[i] = histo[i+1] - histo[i];
    }
    for (int i = 0; i < 254; i++) {
      deriv2[i] = deriv[i+1] - deriv[i];
    }
    
    int histMax = max(histo);


    for (int i = 0; i < entrada.width; i += 2) {
      stroke(0);
      int which = int(map(i, 0, entrada.width, 0, 255));
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(histo[which], 0, histMax, entrada.height, 0));
      line(i+resx, img.height+resy, i+resx, y+resy);
      if(i < 255 && deriv[i] == 0 ){
        stroke(255,0,0);
        line(i+resx, resy, i+resx, img.height+resy);
      }  
    }
}

void draw() {
  background(255);
  image(img,0,0);
  hist(img);
  
 
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
     int loc = x + y*img.width;
     color c = img.pixels[loc];
     float red = red(c);
     float green = green(c);
     float blue = blue(c);
     int grey =(int)(0.299*red + 0.587*green + 0.114*blue);
     color Color = color(grey,grey,grey);
     gr.pixels[loc]  = color(Color);
    }
  }
  image(gr,0,200);
  hist(gr);

  
  float threshold = 180;
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++ ) {
      int loc = x + y*img.width;
      if (brightness(img.pixels[loc]) > threshold) {
        th.pixels[loc]  = color(255);  // White
      }  else {
        th.pixels[loc]  = color(0);    // Black
      }
    }
  }
  image(th,0,400);
  hist(th);
 
  image(bl,0,600);
  hist(bl);
 
  
}
