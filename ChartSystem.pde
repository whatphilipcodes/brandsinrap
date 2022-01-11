// System that manages indiviual bar masks

class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PGraphics maskBuffer;
  PVector currentOr;
  PVector growth;
  boolean isY;
  int timer;

  int chartIndex = 0;
  
  PImage testIMG; //TESTING

// Constructor
  ChartSystem(int x, int y, int t) {
    charts = new ArrayList<RectBarChart>();
    maskBuffer = createGraphics(width, height);
    loadData((startYear + systemIteration), 5);
    currentOr = new PVector(x, y);
    growth = new PVector(0, 0);
    isY = initIsY();
    initMskArray();
    timer = t;
    
    // Glitch stored images
    for (int i = 0; i < brandRep.length; i++) {
      brandRep[i].resize(width + rimMargin, height + rimMargin);
      brandRep[i] = glitch(brandRep[i]);
      brandRep[i].resize(width, height);
    }
  }

  // Runs the animation; this needs to sit in the draw() loop
  void run () {
    if ((chartIndex < propData.length) && (millis() > timer + chartIndex * barDelay)) {
      systems.get(0).addBar();
    }

    for (int i = 0; i < charts.size(); i++) {
      RectBarChart rbc = charts.get(i);
      rbc.morph(0.03, 0.1);
      rbc.createMaskShape(maskBuffer);
      rbc.drawMaskedRep(i);
    }
  }

  // Creates new RectBarChart object
  void addBar () {
    charts.add(new RectBarChart(currentOr, isY, chartIndex, growth));
    RectBarChart rbc = charts.get(chartIndex);
    rbc.initCoords();
    growth.add(rbc.targetCoords());
    currentOr = rbc.newOrigin();
    chartIndex++;
    isY = !isY;
  }
}
