// "brandnames in rap music" by Philip Gerdes & Bernhard Hoffmann, supervised by Prof. Alexander Müller-Rakow // //<>//

import java.util.Calendar;
import generativedesign.*;
import java.util.Map;
import ddf.minim.*; 
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

//Minim Sound Libary
Minim minim;
AudioOutput out;

// SCREEN SETUP //////////////////////
int screenResX = 1080;
int screenResY = 1920;

float scaleFac = 0.5;

int resX = int(screenResX * scaleFac);
int resY = int(screenResY * scaleFac);

void settings() {
    size(resX, resY);
    //fullScreen(1);
    pixelDensity(2);
}
//////////////////////////////////////

// GLOBAL VARIABLES
float[] propData; // Stores converted proportional values from the data csv
PImage[] brandImg; // Stores source images to be glitched later
PGraphics[] glitchPGs; // Stores glitchted brand representaions
PGraphics[] maskPGs; // Stores individual masks for every brand on current table
ArrayList<ChartSystem> systems;
int systemIteration;
boolean animDone;
PImage titleScreen;

// SETTINGS
int startYear = 2015; // First year to be displayed (check csv folder)
int endYear = 2020;// Last year to be displayed (check csv folder)
int barDelay = 3000; // Set delay between individual bars here; SETTINGS: 3000; 2800
float animSpeed = 0.06; // Controls lerp animation speed
String imgVariant = "two"; // Which variant should be displayed? ("one" or "two")

// SETTING 01 prioritzes visual fidelity over performance which leads to long prerender times
// SETTING 02 aims to balance performace and visual fidelity for a fluent experience
int glitchIntensity = 2; // How displaced the glitches are (source and destination); SETTINGS: 2; 3
int glitchAmount = 80000; // How many glitches per iteration; SETTINGS: 80000; 28000
int glitchIterations = 10000; // How often the glitch method will run each iteration; SETTINGS: 10000; 1000

void setup() {
    systems = new ArrayList<ChartSystem>();
    animDone = true;
    minim = new Minim(this);
    out = minim.getLineOut();
    titleScreen = loadImage("titleScreen.png");
    background(0);
    noCursor();
    image(titleScreen, 0, 0, width, height);

}

void draw() {
    if (systems.size() != 0) systems.get(0).run();
    if (animDone == true) nextYear();
    //println(frameRate);
}

///////////////////////////////////////////////////////////////////////////
// This projects main separate function(s)


String[] loadData(int year, int limit) {
    
    Table data = loadTable("csv/" + year + ".csv", "header");
    println("current year: " + year);
    int dataLength = 0;
    
    //Compute data length
    for (int i = 0; i < limit; i++) {
        if (data.getFloat(i, "Count") != 0) {
            dataLength++;
        }
    }   
    // get brandnames from current years data csv file
    String[] brandNames = new String[dataLength];
    for (int i = 0; i < dataLength; i++) {
        brandNames[i] = data.getString(i, "Brand");
        println("brand" + i + ": " + brandNames[i] + " ");
    }
    
    
    propData = new float[dataLength];
    brandImg = new PImage[dataLength];
    glitchPGs = new PGraphics[dataLength];
    maskPGs = new PGraphics[dataLength];
    
    
    for (int i = 0; i < dataLength; i++) {
        propData[i] = data.getFloat(i, "Count");
        brandImg[i] = loadImage("brands_" + imgVariant + "/" + data.getString(i, "Brand") + ".jpg");
        glitchPGs[i] = createGraphics(width, height);
        maskPGs[i] = createGraphics(width, height);
    }
    
    //Calculate sum of all frequencies
    float sum = 0;
    for (float f : propData) sum += f;
    
    //Convert amounts to percent factors
    for (int i = 0; i < dataLength; i++) {
        propData[i] = propData[i] / sum;
    }
    
    return brandNames;  
}

void nextYear() {
    //reset app if end year is reached
    /*
    if (systems.size() != 0 && systems.get(0).chartSystemYear == endYear) {
        frameCount = -1;
    }
    */
    int iterationMax = endYear - startYear;
    // maskData.clear();
    if (systems.size() != 0) systems.remove(0);
    systems.add(new ChartSystem(0,0));
    if (systemIteration == iterationMax) {
        systemIteration = 0;
        frameCount = -1;
        println("cycle done");
    } else {
        systemIteration++;
    }
    animDone = false;
}
