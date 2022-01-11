// "brandnames in rap music" by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow // //<>//

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

// GLOBAL VARIABLES
float [] propData; // Stores converted proportional values from the data csv
PImage [] brandRep; // Stores source images to be glitched later
ArrayList<PGraphics> maskData; // Stores individual masks for every brand on current table
ArrayList<ChartSystem> systems;
int systemIteration;
boolean animDone;

// SETTINGS
int startYear = 2016; // First year to be displayed (check csv folder)
int endYear = 2020;// Lsst year to be displayed (check csv folder)
int barDelay = 180; // Set delay between individual bars here
//int iterDelay = 200; // Set delay between system iterations here

int glitchIntensity = 4; // How displaced the glitches are (source and destination)
int glitchAmount = 10000; // How many glitches per iteration
int glitchIterations = 1000; // How often the glitch method will run each iteration
int rimMargin = 100; // Crops uneven sides

void setup() {
  maskData = new ArrayList<PGraphics>();
  systems = new ArrayList<ChartSystem>();
  animDone = true;
  background(0);
}

void draw() {
  if (systems.size() != 0) systems.get(0).run();
  if (animDone == true) nextYear();
}
