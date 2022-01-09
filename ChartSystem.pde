// System that manages indiviual bar masks

class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PVector currentOr;
  boolean isY;
  
  int chartIndex = 0;

  ChartSystem(int x, int y) {
    currentOr = new PVector(x, y);
    charts = new ArrayList<RectBarChart>();
    isY = initIsY();
  }

  void addBar () {
    charts.add(new RectBarChart(currentOr, isY, chartIndex));
    RectBarChart rbc = charts.get(chartIndex);
    rbc.initCoords();
    rbc.targetCoords();
    currentOr = rbc.newOrigin();
    isY = !isY;
    
    maskData.add(new PGraphics());
    chartIndex++;
  }

  void run () {
    for (int i = charts.size()-1; i >= 0; i--) {
      RectBarChart rbc = charts.get(i);
      rbc.morph(0.03, 0.1);
      rbc.createMask();
      rbc.drawTest();
    }
  }

  void reset () {
    bIndex = 0;
    totalXGrowth = 0;
    totalYGrowth = 0;
    amtBars = 0;
    n = 1;
  }
}
