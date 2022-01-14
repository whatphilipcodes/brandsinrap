// "brandnames in rap music" by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow // //<>//

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);

void settings() {
  //size(resX, resY);
  fullScreen(1);
}
//////////////////////////////////////

// GLOBAL VARIABLES
float [] propData; // Stores converted proportional values from the data csv
PImage [] brandImg; // Stores source images to be glitched later
PGraphics [] glitchPGs; // Stores glitchted brand representaions
PGraphics [] maskPGs; // Stores individual masks for every brand on current table
ArrayList<ChartSystem> systems;
int systemIteration;
boolean animDone;

// SETTINGS
int startYear = 2015; // First year to be displayed (check csv folder)
int endYear = 2020;// Lsst year to be displayed (check csv folder)
int barDelay = 1400; // Set delay between individual bars here
float animSpeed = 0.06; // Controls lerp animation speed
String imgVariant = "two"; // Which variant should be displayed? ("one" or "two")

int glitchIntensity = 2; // How displaced the glitches are (source and destination)
int glitchAmount = 80000; // How many glitches per iteration
int glitchIterations = 10000; // How often the glitch method will run each iteration

void setup() {
  systems = new ArrayList<ChartSystem>();
  animDone = true;
  background(0);
  noCursor();
}

void draw() {
  if (systems.size() != 0) systems.get(0).run();
  if (animDone == true) nextYear();
  //println(frameRate);
}

///////////////////////////////////////////////////////////////////////////
// This projects main separate function(s)

void loadData(int year, int limit) {

  Table data = loadTable("csv/" + year + ".csv", "header");
  println(year);
  int dataLength = 0;

  // Compute data length
  for (int i = 0; i < limit; i++) {
    if (data.getFloat(i, "Count") != 0) {
      dataLength++;
    }
  }

  propData = new float [dataLength];
  brandImg = new PImage [dataLength];
  glitchPGs = new PGraphics [dataLength];
  maskPGs = new PGraphics [dataLength];
  

  for (int i = 0; i < dataLength; i++) {
    propData[i] = data.getFloat(i, "Count");
    brandImg[i] = loadImage("brands_"+imgVariant+"/" + data.getString(i, "Brand") + ".jpg");
    glitchPGs[i] = createGraphics(width, height);
    maskPGs[i] = createGraphics(width, height);
  }

  // Calculate sum of all frequencies
  float sum = 0;
  for (float f : propData) sum += f;

  // Convert amounts to percent factors
  for (int i = 0; i < dataLength; i++) {
    propData[i] = propData[i]/sum;
  }
}

void nextYear() {
  int iterationMax = endYear - startYear;
  //maskData.clear();
  if (systems.size() != 0) systems.remove(0);
  systems.add(new ChartSystem(0,0));
  if (systemIteration == iterationMax) {
    systemIteration = 0;
  } else {
    systemIteration++;
  }
  animDone = false;
}

void initializePGraphicsImage(PGraphics pg, PImage pi) {
  pg.beginDraw();
  pg.background(0);
  pg.image(pi, 0, 0, width, height);
  glitch(pg);
  pg.endDraw();
}

void glitch(PGraphics pg) {
  int glitchCount = 0;
  if (glitchCount < glitchIterations) {
    for (int i = 0; i < glitchAmount; ++i) {
      //source
      int x1 = (int) random(0, width);
      int y1 = (int) random(0, height);
      //destination
      int x2 = round(x1 + random( -glitchIntensity, glitchIntensity));
      int y2 = round(y1 + random( -glitchIntensity, glitchIntensity));
      //size of copyblock
      int w = round(random(50, 100));
      int h = round(random(50, 100));
      pg.copy(x1, y1, w, h, x2, y2, w, h);
    }
    glitchCount++;
  }
}
