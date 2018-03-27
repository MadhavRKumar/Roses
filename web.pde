ArrayList<PVector> outerLayer; 
ArrayList<PVector> innerLayer;
PVector translate;
float radius;
float n = 5;

float off = 0;
float limit;
int count = 0;


color[] colors = {#5DD5ED, #FFB4AF, #2223A2, #B4EFFD, #efefef};
void setup() {
  fullScreen();
  background(#B4EFFD);
  //drawStem();
  reset();
}

void drawStem() {

  float y = height/2;
  float yInc = random(25, 100);
  strokeWeight(15);
  stroke(#333333);
  strokeCap(SQUARE);
  noFill();
  beginShape();

  while (y <= height + yInc) {
     yInc = random(25, 100);
    float xOff = random(-50, 50);
  
    vertex(width/2 + xOff, y);
    
    y += yInc;
  }
  endShape();
}

void reset() {
  limit = random(1, 10);
  radius = random(width/16, width/8); 

  translate = new PVector(random(width/4, 3*width/4), random(height/4, 3*height/4));
  outerLayer = new ArrayList<PVector>();
  generateLayer(outerLayer, radius);
}
void keyPressed() {

  if (key == 'r' || key == 'R') {
    reset();
  }
}

float dec = 0.75;
void draw() {
  strokeWeight(1);
  translate(translate.x, translate.y);
  if (radius > limit) {
    innerLayer = new ArrayList<PVector>();
    generateLayer(innerLayer, radius*dec);


    for (int i = 0; i < outerLayer.size(); i++) {
      color c = colors[(int)random(colors.length)];
      colorMode(HSB, 100);
      float bright = brightness(c);
      c = color(hue(c), saturation(c), map(noise(off), 0, 1, bright*0.9, bright));
      off += 0.1;
      stroke(c);
      fill(c);
      PVector outer1 = outerLayer.get(i);
      PVector outer2 = outerLayer.get((i+1)%(outerLayer.size()));

      PVector inner1 = innerLayer.get(i%innerLayer.size());
      PVector inner2 = innerLayer.get((i+1)%(innerLayer.size()));

      quad(outer1.x, outer1.y, outer2.x, outer2.y, inner2.x, inner2.y, inner1.x, inner1.y);
    }


    radius *= dec;
    outerLayer = new ArrayList(innerLayer);
  } else if (count < 30) {
    reset();
    count++;
  } else {
    saveFrame("roses-####.png");
    exit();
  }
}

void createCircle(ArrayList<PVector> arr) {

  for (int i = 0; i < arr.size(); i++) {
    PVector start = arr.get(i);
    PVector end = arr.get((i+1)%(arr.size()));

    line(start.x, start.y, end.x, end.y);
  }
}

void generateLayer(ArrayList<PVector> arr, float r) {
  float a = PI/random(1, n);

  for (float angle = 0; angle <= 2*PI; angle += a) {
    float div = 12;
    float x = cos(angle)*r + random(-r/div, r/div);
    float y = sin(angle)*r + random(-r/div, r/div);

    PVector point = new PVector(x, y);

    arr.add(point);
  }
}