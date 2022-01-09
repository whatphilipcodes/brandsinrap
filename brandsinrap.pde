// Gucci Gang by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow
import java.util.Calendar;
import generativedesign.*;

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);

//glitch
boolean glitch = true;
//1-3,50000  1,100000  10,1000
//2, 50000
int glitchIntensity = 2; //how displaced the glitches are (source and destination)
int glitchInterations = 5000; //how many glitches per frame
int glitchLength = 10; //how often the glitch method will run
int glitchCount = 0;

//images, masking
PImage supreme;
PImage gucci;

PGraphics bg;
PGraphics mask;
int numImagesA = 2;
PImage[] imgA = new PImage[numImagesA];

PShape shape0;




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
Table data;
PShape s;
int index = 0; // Gloabl iteration counter
int bIndex = 0;

float totalXGrowth;
float totalYGrowth;

int nDelay = 20;
int n = 3;

void setup() {
  loadData("2019");
  printArray(propData);

  cs = new ChartSystem(new PVector(0, 0));
  background(125);

  for (TableRow row : data.rows()) {
    String brandName = row.getString("Brand");
    //print(brandName);
    cs.addBar(brandName, #A41AEB);
  }

  supreme = loadImage("supreme.jpg");
  gucci = loadImage("gucci.jpg");


  //
  bg = createGraphics(width, height);
  bg.beginDraw();
  bg.background(0);
  bg.image(supreme, 0, 0, width, height);
  render(bg);
  bg.endDraw();
  mask = createGraphics(width, height);
}

void draw() {

  //if ( frameCount == nDelay * n) {
  //  cs.addBar("supreme", #A41AEB);
  //} else if (frameCount == nDelay * (n + 1)) {
  //  cs.addBar("gucci", #701BF5);
  //} else if (frameCount == nDelay * (n + 2)) {
  //  cs.addBar("prada", #3923DE);
  //} else if (frameCount == nDelay * (n + 3)) {
  //  cs.addBar("louis", #1B3CF5);
  //} else if (frameCount == nDelay * (n + 4)) {
  //  cs.addBar("moncleur", #1A70EB);
  //}
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

  //Mask
  mask.beginDraw();
  maskShape(mask);
  //mask.rectMode(CORNER);
  //mask.rect(0, 0, width, height);


  if (cs.charts.size() != 0) {
    //PShape 
    for (int i = 0; i < cs.charts.size(); i++) {
      //println(cs.charts.get(i).brand);
      PShape chartShape = cs.charts.get(i).chartShape;
      mask.shape(chartShape, 0, 0);
    }
  }

  mask.endDraw();
  bg.mask(mask);
  image(bg, 0, 0); //<>//
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
      int h = round(random(50, 100));
      pimg.copy(x1, y1, w, h, x2, y2, w, h);
    }
    glitchCount++;
    if (debug) println("glitch: " + glitchCount);
  }
}

void keyReleased() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
