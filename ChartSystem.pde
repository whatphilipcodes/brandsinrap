// System that manages indiviual bar masks

class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PVector currentOr;
  boolean isY;
  
  int chartNo = 0;

  ChartSystem(int x, int y) {
    currentOr = new PVector(x, y);
    charts = new ArrayList<RectBarChart>();
    isY = initIsY();
  }

  void addBar (color testColor) {
    charts.add(new RectBarChart(currentOr, testColor, isY, chartNo));
    RectBarChart rbc = charts.get(chartNo);
    rbc.initCoords();
    rbc.targetCoords();
    currentOr = rbc.newOrigin();
    isY = !isY;
    
    maskData.add(new PGraphics());
    chartNo++;
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
