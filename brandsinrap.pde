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
ArrayList<PGraphics> maskData; // Stores individual masks for every brand on current table

int bIndex = 0;
int countBars;
int amtBars = 0;

float totalXGrowth;
float totalYGrowth;

int nDelay = 20;
int n = 1;

void setup() {
  loadData("2011", 5);
  maskData = new ArrayList<PGraphics>();
  cs = new ChartSystem(0, 0);
  background(0);
}

void draw() {
  println(frameRate);
  if ((frameCount == nDelay * n) && (amtBars < countBars)) {
    cs.addBar(#A41AEB);
    amtBars++;
    n++;
  }
  cs.run();
}
