// "brandnames in rap music" by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);

void settings() {
  size(resX, resY);
  //fullScreen(2);
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
  background(0);
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
  }
}
