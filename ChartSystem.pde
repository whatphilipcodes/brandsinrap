// System that manages indiviual bar masks

class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PVector currentOr;
  PVector growth;
  boolean isY;
  int timer;

  int chartIndex = 0;

  PImage testIMG; //TESTING

  // Constructor
  ChartSystem(int x, int y, int t) {
    charts = new ArrayList<RectBarChart>();
    currentOr = new PVector(x, y);
    growth = new PVector(0, 0);
    loadData((startYear + systemIteration), 5);
    isY = initIsY();
    initMasksArray();
    timer = t;
    
    String title;
    if (lastIMG == true) {
      title = "testIMG";
      lastIMG = false;
    } else {
      title = "testIMG02";
      lastIMG = true;
    }
    
    testIMG = loadImage(title + ".jpg"); //TESTING
    testIMG.resize(width, height); //TESTING
  }

  // Runs the animation; this needs to sit in the draw() loop
  void run () {
    if ((chartIndex < propData.length) && (millis() > timer + chartIndex * Delay)) {
      systems.get(0).addBar();
    }

    for (int i = charts.size()-1; i >= 0; i--) {
      RectBarChart rbc = charts.get(i);
      rbc.morph(0.03, 0.1);
      rbc.createMaskShape();
      rbc.drawTest(testIMG);
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
