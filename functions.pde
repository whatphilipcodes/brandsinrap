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
  brandRep = new PImage [dataLength];
  maskBuffer = new PGraphics [dataLength];

  for (int i = 0; i < dataLength; i++) {
    propData[i] = data.getFloat(i, "Count");
    brandRep[i] = loadImage("brandRep/" + data.getString(i, "Brand") + ".jpg");
    maskBuffer[i] = createGraphics(width, height);
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
  systems.add(new ChartSystem(0,0,millis()));
  if (systemIteration == iterationMax) {
    systemIteration = 0;
  } else {
    systemIteration++;
  }
  animDone = false;
}

PImage glitch(PImage pimg) {
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
      pimg.copy(x1, y1, w, h, x2, y2, w, h);
    }
    glitchCount++;
  }
  return pimg;
}
