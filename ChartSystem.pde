// System that manages indiviual bar masks

class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PVector currentOr;
  boolean[] status;
  PVector growth;
  boolean isY;
  int timer;

  int chartIndex = 0;

  // Constructor
  ChartSystem(int x, int y) {
    charts = new ArrayList<RectBarChart>();
    loadData((startYear + systemIteration), 5);
    status = new boolean [propData.length];
    currentOr = new PVector(x, y);
    growth = new PVector(0, 0);
    animDone = false;
    isY = initIsY();

    // Glitch stored images
    for (int i = 0; i < brandImg.length; i++) {
      brandImg[i].resize(width, height);
      initializePGraphicsImage(glitchPGs[i], brandImg[i]);
    }
    timer = millis();
  }

  // Runs the animation; this needs to sit in the draw() loop
  void run () {
    if ((chartIndex < propData.length) && (millis() > timer + chartIndex * barDelay)) {
      systems.get(0).addBar();
    }

    for (int i = 0; i < charts.size(); i++) {
      if (status[i] == false) {
        RectBarChart rbc = charts.get(i);
        status[i] = rbc.morph(animSpeed, 0.99);
        rbc.createMaskShape(maskPGs[i]);
        glitchPGs[i].mask(maskPGs[i]);
        image(glitchPGs[i], 0, 0);
      }
    }
    animDone = checkStatus();
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

  boolean checkStatus() {
    for (int i = 0; i < status.length; ++i) {
      boolean b = status[i];
      if (!b)  return false;
    }
    return true;
  }
}
