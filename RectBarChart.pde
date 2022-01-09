// Main code to construct bars from table data

class RectBarChart {
  // Local object variabes
  PVector P;
  color testColor;
  float targetA;
  ArrayList<PVector> Verts = new ArrayList<PVector>();
  float lastXGrowth;
  float lastYGrowth;
  boolean isY;
  PGraphics pg;
  PShape s;
  int chartNo;
  
  PImage testIMG;


  RectBarChart(PVector origin, color tCol, boolean Y, int cN) {
    P = origin;
    testColor = tCol;
    isY = Y;
    pg = createGraphics(width, height);
    chartNo = cN;
    testIMG = loadImage("testIMG.jpg");
    testIMG.resize(width, height);
  }

  // Sets up base coordinates
  void initCoords() {
    Verts.clear();
    if (isY == true) {
      // P index 0
      Verts.add(P);
      // Q index 1
      Verts.add(P);
      // R index 2
      Verts.add(new PVector(P.x + (width - totalXGrowth), P.y));
      // S index 3
      Verts.add(Verts.get(2));
    } else {
      // P index 0
      Verts.add(P);
      // Q index 1
      Verts.add(new PVector(P.x, P.y + (height - totalYGrowth)));
      // R index 2
      Verts.add(Verts.get(1));
      // S index 3
      Verts.add(P);
    }
  }

  //Caculates target coordinates with propData at index
  void targetCoords() {
    targetA = calcTargetA();
    float offset;

    if (isY == true) {
      PVector PS = PVector.sub(Verts.get(3), P);
      offset = targetA / PS.mag();
      // targetQ index 4
      Verts.add(new PVector(P.x, P.y + offset));
      // targetR index 5
      Verts.add(new PVector(Verts.get(2).x, Verts.get(4).y));
      
      lastYGrowth = offset;
      totalYGrowth = totalYGrowth + offset;
      
    } else {
      PVector PQ = PVector.sub(Verts.get(1), P); //FEHLER HIER??? // Vektor AB -> B.x - A.x, B.y - A.y...? FIXED!
      offset = targetA / PQ.mag();
      // targetR index 4
      Verts.add(new PVector(P.x + offset, Verts.get(1).y));
      // targetS index 5
      Verts.add(new PVector(P.x + offset, P.y));
      
      lastXGrowth = offset;
      totalXGrowth = totalXGrowth + offset;
    }
  }

  void morph(float lerpSpeed, float mergeThresh) {
    if (isY == true) {
      float newQx = 0;
      float newQy = 0;
      float newRx = 0;
      float newRy = 0;
      
      PVector RtargetR = PVector.sub(Verts.get(5),Verts.get(2));
      float prox = RtargetR.mag();
      
      if (prox <= mergeThresh) {
        Verts.set(1, Verts.get(4));
        Verts.set(2, Verts.get(5));
      } else {
        // Q -> targetQ
        newQx = lerp(Verts.get(1).x, Verts.get(4).x, lerpSpeed); // Lerp x-coordinate
        newQy = lerp(Verts.get(1).y, Verts.get(4).y, lerpSpeed); // Lerp y-coordinate

        // R -> targetR
        newRx = lerp(Verts.get(2).x, Verts.get(5).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(2).y, Verts.get(5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(1, new PVector(newQx, newQy));
        Verts.set(2, new PVector(newRx, newRy));
      }
    } else {
      float newRx = 0;
      float newRy = 0;
      float newSx = 0;
      float newSy = 0;
      
      PVector StargetS = PVector.sub(Verts.get(5),Verts.get(3));
      float prox = StargetS.mag();
      
      if (prox <= mergeThresh) {
        Verts.set(2, Verts.get(4));
        Verts.set(3, Verts.get(5));
      } else {
        // R -> targetR
        newRx = lerp(Verts.get(2).x, Verts.get(4).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(2).y, Verts.get(4).y, lerpSpeed); // Lerp y-coordinate

        // S -> targetS
        newSx = lerp(Verts.get(3).x, Verts.get(5).x, lerpSpeed); // Lerp x-coordinate
        newSy = lerp(Verts.get(3).y, Verts.get(5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(2, new PVector(newRx, newRy));
        Verts.set(3, new PVector(newSx, newSy));
      }
    }
  }
  
  PVector newOrigin() {
    PVector newOrigin;
    if (isY == true) {
      newOrigin = new PVector(Verts.get(0).x,Verts.get(0).y + lastYGrowth);
    } else {
      newOrigin = new PVector(Verts.get(0).x + lastXGrowth,Verts.get(0).y);
    }
    return newOrigin;
  }

  void createMask() {
    s = createShape();
    s.beginShape();
    s.noStroke();
    s.fill(255);
    s.vertex(Verts.get(0).x, Verts.get(0).y);
    s.vertex(Verts.get(1).x, Verts.get(1).y);
    s.vertex(Verts.get(2).x, Verts.get(2).y);
    s.vertex(Verts.get(3).x, Verts.get(3).y);
    s.endShape(CLOSE);
    shape(s,0,0);
    
    pg.beginDraw();
    pg.shape(s, 0, 0);
    pg.endDraw();
    maskData.set(chartNo, pg);
  }
  
  void drawTest() {
    testIMG.mask(maskData.get(chartNo));
    image(testIMG,0,0);
  }
}
