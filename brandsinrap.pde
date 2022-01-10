// "brandnames in rap music" by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow //<>//

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
float [] propData; // Stores converted proportional values from the data csv
ArrayList<PGraphics> maskData; // Stores individual masks for every brand on current table
ArrayList<ChartSystem> systems;
int systemIteration;

int startYear = 2010;
int iterationMax = 12;
int Delay = 180; // Set animation delay here

void setup() {
  maskData = new ArrayList<PGraphics>();
  systems = new ArrayList<ChartSystem>();
  background(0);
}

void draw() {
  if (systems.size() != 0) systems.get(0).run();
}

void mousePressed() {
  maskData.clear();
  background(0);
  if (systems.size() != 0) systems.remove(0);
  systems.add(new ChartSystem(0,0,millis()));
  if (systemIteration == iterationMax) {
    systemIteration = 0;
  } else {
    systemIteration++;
  }
}
