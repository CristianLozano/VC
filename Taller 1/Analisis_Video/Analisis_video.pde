import processing.video.*;
Movie myMovie, myGray;

void setup() {
    size(600, 900);
  myMovie = new Movie(this, "myVideo.mp4");

  myGray = new Movie(this, "myVideo.mp4");
  
  myMovie.loop();
  myGray.loop();
  
  frameRate(30);
}

void draw() {
  myMovie.loadPixels();
  myGray.loadPixels();
  
  //println(frameRate);
  image(myMovie, 0, 0, 600, 300);
  
   for (int x = 0; x < 600; x++) {
    for (int y = 0; y < 300; y++ ) {
     color c = get(x,y);
     float red = red(c);
     float green = green(c);
     float blue = blue(c);
     int grey =(int)(0.299*red + 0.587*green + 0.114*blue);
     color Color = color(grey,grey,grey);

     set(x,y+300,Color);
     //println(frameRate);
    }
  }
  
  
  
  for (int x = 0; x < myGray.width; x++) {
    for (int y = 0; y < myGray.height; y++ ) {
     int loc = x + y*myGray.width;
     color c = myMovie.pixels[loc];
     //Carga de pixel de pantalla
     //color c = get(x,y);
     float red = red(c);
     float green = green(c);
     float blue = blue(c);
     int grey =(int)(0.299*red + 0.587*green + 0.114*blue);
     color Color = color(grey,grey,grey);
     
     
     //----------------Acá se encuentra el error, al momento de guardar el pixel en el nuevo video
     myGray.pixels[loc] = Color;

     //Prueba de gray con pixel de pantalla
     //set(x,y+400,Color);
    }
  }
  
  image(myGray, 0, 600, 600, 300);
  String s = Float.toString(frameRate);
  s = "Frame Rate " + s;
  text(s, 10, 10, 70, 80);

  
  
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
