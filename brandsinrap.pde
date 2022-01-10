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

// Global Variables
float [] propData; // Stores converted proportional values from the data csv
ArrayList<PGraphics> maskData; // Stores individual masks for every brand on current table
ArrayList<ChartSystem> systems;
int systemIteration;
boolean animDone;

int startYear = 2010;
int endYear = 2022;
int barDelay = 180; // Set delay between individual bars here
//int iterDelay = 200; // Set delay between system iterations here

boolean lastIMG = false; //TESTING

void setup() {
  maskData = new ArrayList<PGraphics>();
  systems = new ArrayList<ChartSystem>();
  background(0);
  animDone = true;
}

void draw() {
  if (systems.size() != 0) systems.get(0).run();
  if (animDone == true) nextYear();
}
