import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;

// timing
TimingTask spinningTask;
boolean yDirection, antialiasing,shading;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = false;

color c1 = color(255,0,0);//color for vertex 1
color c2 = color(0,255,0);//color for vertex 2
color c3 = color(0,0,255);//color for vertex 3

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 10;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}


void setup() {
  //size(700, 700, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);
  strokeCap(SQUARE);
  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

/*
  The edgeFunction allows us to determine if a point is inside or outside the triangle based on the Pineda's method.
  With this we can also calculate the barycentric coordinates of a point p and also gives us the area of the subtriangle formed by the vectors a b c
*/

float edgeFunction( Vector a, Vector b, Vector c) 
{ 
    return (node.location(c).x() - node.location(a).x()) * (node.location(b).y() - node.location(a).y()) - (node.location(c).y() - node.location(a).y()) * (node.location(b).x() - node.location(a).x()); 
}
float edgeFunction( float a_x,  float a_y , float b_x, float b_y, float c_x,  float c_y) 
{ 
    return (((c_x - a_x) * (b_y - a_y)) - ((c_y - a_y) * (b_x - a_x))); 
}

boolean verify( int x, int y){
 float  K_v1v2 = edgeFunction(node.location(v1).x(), node.location(v1).y(), node.location(v2).x(), node.location(v2).y(), x, y ),
        K_v2v3 = edgeFunction(node.location(v2).x(), node.location(v2).y(), node.location(v3).x(), node.location(v3).y(), x, y ),
        K_v3v1 = edgeFunction(node.location(v3).x(), node.location(v3).y(), node.location(v1).x(), node.location(v1).y(), x, y );
        return (((K_v1v2 >=0  && K_v2v3 >= 0 && K_v3v1 >= 0) || (K_v1v2 <=0  && K_v2v3 <=0 && K_v3v1 <=0)  ) && ( -abs(K_v1v2) < 1.0 || -abs(K_v2v3) < 1.0 || -abs(K_v3v1) < 1.0  )  );
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  
  float begin=350-(width/pow(2, n))/2;//The points are traversed from left to right
  float area = edgeFunction(v1, v2, v3); // area of the triangle multiplied by 2 
  for(float i=-begin;i<=begin;i=i+width/pow(2, n)){
    for(float j=-begin;j<=begin;j=j+width/pow(2, n)){
      Vector p = new Vector(i,j);
      //we calculate the weights of each component of P
      float w0 = edgeFunction(v2, v3, p);
      float w1 = edgeFunction(v3, v1, p); 
      float w2 = edgeFunction(v1, v2, p); 
      
      if (w0 >= 0 && w1 >= 0 && w2 >= 0) {//Baricentric coordinates establish that if a point is inside the triangle the sum of its weights can not be greater than 1
        w0 /= area; //weights can be calculated as the ratio between the area of the subtriangle formed by an edge and the point, divided over the area of the triangle to be rasterized
        w1 /= area; 
        w2 /= area;
        
        //we interpolate to obtain the color weights of the point from the colors c1 c2 c3 of the triangule vertex's
        float tmp_c1 = w0 * red(c1) + w1 * red(c2) + w2 * red(c3); 
        float tmp_c2 = w0 * blue(c1) + w1 * blue(c2) + w2 * blue(c3); 
        float tmp_c3 = w0 * green(c1) + w1 * green(c2) + w2 * green(c3);
        pushStyle();
        stroke(round(tmp_c1), round(tmp_c2), round(tmp_c3), 175);
        //point(node.location(p).x(), node.location(p).x());
        popStyle();
      }
      
    }
  }
  
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    popStyle();
    
    pushStyle();
    stroke(255, 255, 255, 125);
    point(round(200), round(200));
    popStyle();
  }
  
  if(antialiasing){
    pushStyle();
    stroke(125, 125, 125, 125);
    int sizeGrid = (int) pow(2,n-1);
    for(int  i = -sizeGrid ; i < sizeGrid; i++ ){
      for(int j = -sizeGrid; j < sizeGrid; j++){
        if (verify(i,j))
              rect(i,j,1,1);
      }
    }
    popStyle();
  }
  
  if(shading){
    float shadeArea = edgeFunction(node.location(v1).x(), node.location(v1).y(), node.location(v2).x(), node.location(v2).y(), node.location(v3).x(), node.location(v3).y() );
    int sizeGrid = (int) pow(2,n-1);
    for(int  i = -sizeGrid ; i < sizeGrid; i++ ){
      for(int j = -sizeGrid; j < sizeGrid; j++){
        float K_v1v2 = edgeFunction(node.location(v1).x(), node.location(v1).y(), node.location(v2).x(), node.location(v2).y(), i, j ),
              K_v2v3 = edgeFunction(node.location(v2).x(), node.location(v2).y(), node.location(v3).x(), node.location(v3).y(), i, j ),
              K_v3v1 = edgeFunction(node.location(v3).x(), node.location(v3).y(), node.location(v1).x(), node.location(v1).y(), i, j );
          if ((K_v1v2 >=0  && K_v2v3 >= 0 && K_v3v1 >= 0) || (K_v1v2 <=0  && K_v2v3 <=0 && K_v3v1 <=0) ){
                pushStyle();
                colorMode(RGB, 1);
                stroke( K_v1v2/shadeArea, K_v2v3/shadeArea, K_v3v1/shadeArea);
                point(i,j);
                popStyle();
              }   
      }
    
    }
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  float xV1=random(low, high);
  float yV1=random(low, high);
  float xV2=random(low, high);
  float yV2=random(low, high);
  float xV3=random(low, high);
  float yV3=random(low, high);
  v1 = new Vector(xV1, yV1);
  float sum = (yV2 - yV1) * (xV3 - xV2) - (xV2 - xV1) * (yV3 - yV2);
  while(sum <0){//iterates until the vertices v1 v2 v3 have a clockwise orientation
    yV2=random(low, high);
    xV3=random(low, high);
    sum=(yV2 - yV1) * (xV3 - xV2) - (xV2 - xV1) * (yV3 - yV2);
  }
  v2 = new Vector(xV2, yV2);
  v3 = new Vector(xV3, yV3);
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  //stroke(c1);
  point(v1.x(), v1.y());
  //stroke(2);
  point(v2.x(), v2.y());
  //stroke(c3);
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
  if (key == 'a')
    antialiasing = !antialiasing;
  if (key == 's')
    shading = !shading;
}
