// Gucci Gang by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow //<>// //<>//
import java.util.Calendar;
import generativedesign.*;
import java.util.Map;
import ddf.minim.*; //<>// //<>//
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//Minim Sound Libary
Minim minim;
AudioOutput out;
Sampler sgucci;
Sampler slouisvuitton;
Sampler sysl;
Sampler snike;
Sampler ssupreme;
HashMap<String, Sampler> samples = new HashMap<String, Sampler>();

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);


int maxNumberOfBrands = 5;
boolean glitch = true;
boolean printOnce = true;
boolean debug = false;

//1-3,50000  1,100000  10,1000
//2, 50000
int glitchIntensity = 4; //how displaced the glitches are (source and destination)
int glitchInterations = 5000; //how many glitches per frame
int glitchLength = 10; //how often the glitch method will run
int glitchCount = 0;
//images, masking
PImage supreme;
PImage gucci;
PImage lv;
PImage dior;
PImage adidas;
PImage[] brandImages = new PImage[maxNumberOfBrands];

PGraphics mask0;
PGraphics mask1;
PGraphics mask2;
PGraphics mask3;
PGraphics mask4;
PGraphics pgImg0;
PGraphics pgImg1;
PGraphics pgImg2;
PGraphics pgImg3;
PGraphics pgImg4;

void settings() {
  size(resX, resY, P2D);
  //fullScreen(2);
  //smooth(2);
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
  //printArray(propData);
  cs = new ChartSystem(new PVector(0, 0));
  background(0);
  initializeImagesMasksBrandnames();

  //load audio data
  minim = new Minim(this);
  out = minim.getLineOut();

  ssupreme = new Sampler ("supreme.aif", 1, minim);
  sgucci = new Sampler ("gucci.aif", 1, minim);
  slouisvuitton = new Sampler ("louis vuitton.aif", 1, minim);
  sysl = new Sampler ("ysl.aif", 1, minim);
  snike = new Sampler ("nike.aif", 1, minim);
  ssupreme.patch(out);
  sgucci.patch(out);
  slouisvuitton.patch(out);
  sysl.patch(out);
  snike.patch(out);
  //put in hashmap
  samples.put("gucci", sgucci);
  samples.put("supreme", ssupreme);
  samples.put("louis vuitton", slouisvuitton);
  samples.put("yves saint laurent", sysl);
  samples.put("nike", snike);
}

void initializePGraphicsImage(PGraphics pg, PImage pi) {
  pg.beginDraw();
  pg.background(0);
  pg.image(pi, 0, 0, width, height);
  render(pg);
  pg.endDraw();
}

void initializeImagesMasksBrandnames() {
  //add BarCharts with brand names
  int ii = 0;
  for (TableRow row : data.rows()) {
    if (ii < maxNumberOfBrands) {
      String brandName = row.getString("Brand");
      print("img " + ii + ": "  + brandName);
      cs.addBar(brandName, #A41AEB);
      brandImages[ii] = loadImage(brandName + ".jpg");
    }
    ii++;
  }
  //create PGraphics for images and masks
  pgImg0 = createGraphics(width, height);
  pgImg1 = createGraphics(width, height);
  pgImg2 = createGraphics(width, height);
  pgImg3 = createGraphics(width, height);
  pgImg4 = createGraphics(width, height);
  mask0 = createGraphics(width, height);
  mask1 = createGraphics(width, height);
  mask2 = createGraphics(width, height);
  mask3 = createGraphics(width, height);
  mask4 = createGraphics(width, height);

  if (maxNumberOfBrands > 0) initializePGraphicsImage(pgImg0, brandImages[0]);
  if (maxNumberOfBrands > 1) initializePGraphicsImage(pgImg1, brandImages[1]);
  if (maxNumberOfBrands > 2) initializePGraphicsImage(pgImg2, brandImages[2]);
  if (maxNumberOfBrands > 3) initializePGraphicsImage(pgImg3, brandImages[3]);
  if (maxNumberOfBrands > 4) initializePGraphicsImage(pgImg4, brandImages[4]);
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
  //reset
  if (mousePressed) {
    bIndex = 0;
    totalXGrowth = 0;
    totalYGrowth = 0;
    frameCount = -1;
    glitchCount = 0;
  }

  if (maxNumberOfBrands > 0) drawMaskedPG(mask0, pgImg0, 0);
  if (maxNumberOfBrands > 1) drawMaskedPG(mask1, pgImg1, 1);
  if (maxNumberOfBrands > 2) drawMaskedPG(mask2, pgImg2, 2);
  if (maxNumberOfBrands > 3) drawMaskedPG(mask3, pgImg3, 3);
  if (maxNumberOfBrands > 4) drawMaskedPG(mask4, pgImg4, 4);

  //highlight charts & play samples
  if ( frameCount == nDelay * n) {
    playSample(0);
  } else if (frameCount == nDelay * (n + 10)) {
    playSample(1);
  } else if (frameCount == nDelay * (n + 20)) {
    playSample(2);
  } else if (frameCount == nDelay * (n + 30)) {
    playSample(3);
  } else if (frameCount == nDelay * (n + 40)) {
    playSample(4);
  }
}

void playSample(int index) {
  String brandName = cs.charts.get(index).brand;
  if (samples.get(brandName) != null) {
    println("playing: " + brandName);
    samples.get(brandName).trigger();
    cs.charts.get(index).highlight = false;
  }
}

void drawMaskedPG(PGraphics pmask, PGraphics pimg, int index) {
  PShape ps = cs.charts.get(index).chartShape;
  pmask.beginDraw();
  pmask.shape(ps, 0, 0);
  pmask.endDraw();
  pimg.mask(pmask);
  image(pimg, 0, 0);
  if (debug) {
    println("brand " + index + ": " + cs.charts.get(index).brand);
  }
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
    //if (debug) println("glitch: " + glitchCount);
  }
}

void keyReleased() {
  if (key=='s' || key=='S') saveFrame(timestamp()+"_##.png");
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
