class ChartSystem {
  // Local object variabes
  ArrayList<RectBarChart> charts;
  PVector currentOr;
  boolean isY;

  ChartSystem(PVector or) {
    currentOr = or.copy();
    charts = new ArrayList<RectBarChart>();
    isY = initIsY();
  }

  void addBar (color testColor) {
    int cIndex = charts.size();
    charts.add(new RectBarChart(currentOr, testColor, isY));
    RectBarChart rbc = charts.get(cIndex);
    rbc.initCoords();
    rbc.targetCoords();
    currentOr = rbc.newOrigin();
    isY = !isY;
  }

  void run () {
    for (int i = charts.size()-1; i >= 0; i--) {
      RectBarChart rbc = charts.get(i);
      rbc.morph(0.03, 0.1);
      rbc.drawGraphic();
    }
  }

  void reset () {
    
  }
}
