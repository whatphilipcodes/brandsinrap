// Gucci Gang by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);

//glitch
boolean glitch = true;
int glitchIntensity = 10; //how displaced the glitches are (source and destination)
int glitchInterations = 2500; //how many glitches per frame
int glitchLength = 10; //how often the glitch method will run
int glitchCount = 0;
//masking
PImage img;
PGraphics bg;
PGraphics mask;

boolean debug = false;

void settings() {
  size(resX, resY, P2D);
  //fullScreen(2);
  smooth(2);
}
//////////////////////////////////////

// Global Variables
ChartSystem cs; // Stores the complete system of charts
float [] propData; // Stores converted proportional values from the data csv
PShape s;
int index = 0; // Gloabl iteration counter
int bIndex = 0;

float totalXGrowth;
float totalYGrowth;

int nDelay = 20;
int n = 3;

void setup() {
  loadData("fakeData");
  cs = new ChartSystem(new PVector(0, 0));
  background(125);

  //printArray(propData);

  img = loadImage("supreme.jpg");

  //
  bg = createGraphics(width, height);
  bg.beginDraw();
  bg.background(0);
  bg.image(img, 0, 0, width, height);
  render(bg);
  bg.endDraw();
  mask = createGraphics(width, height);
}

void draw() {
  if ( frameCount == nDelay * n) {
    cs.addBar(#A41AEB);
  } else if (frameCount == nDelay * (n + 1)) {
    cs.addBar(#701BF5);
  } else if (frameCount == nDelay * (n + 2)) {
    cs.addBar(#3923DE);
  } else if (frameCount == nDelay * (n + 3)) {
    cs.addBar(#1B3CF5);
  } else if (frameCount == nDelay * (n + 4)) {
    cs.addBar(#1A70EB);
  }
  cs.run();
  if (mousePressed) {
    bIndex = 0;
    totalXGrowth = 0;
    totalYGrowth = 0;
    frameCount = -1;
    glitchCount = 0;
  }

  ////add Stuff to the bg layer
  //bg.beginDraw();
  ////if (cs.charts.size() != 0) {
  //  //render(bg);
  ////}
  //bg.endDraw();

  //mask
  mask.beginDraw();
  maskShape(mask);
  mask.rectMode(CORNER);
  //mask.rect(width/2, 0, width/2, height);

  if (cs.charts.size() != 0) {
    PShape shape0 = cs.charts.get(0).s;
    mask.shape(shape0, 0, 0);
  }


  mask.endDraw();
  bg.mask(mask);
  image(bg, 0, 0);
}

void maskShape(PGraphics pimg) {
  //println(cs.charts.size());
  //if (cs.charts.size() != 0) println(cs.charts.get(0).s);
  //pimg.
}

void render(PGraphics pimg) {
  glitch(glitchInterations, pimg);
}

void glitch(int len, PGraphics pimg) {
  if (glitch && glitchCount < glitchLength) {
    for (int i = 0; i < len; ++i) {
      //source
      int x1 = (int) random(0, width);
      int y1 = (int) random(0, height);
      //destination
      int x2 = round(x1 + random( -glitchIntensity, glitchIntensity));
      int y2 = round(y1 + random( -glitchIntensity, glitchIntensity));
      //size of copyblock
      int w = round(random(50, 100));
      //int w = 1;
      int h = round(random(50, 100));
      pimg.copy(x1, y1, w, h, x2, y2, w, h);
    }
    glitchCount++;
    if (debug) println("glitch: " + glitchCount);
  }
}
