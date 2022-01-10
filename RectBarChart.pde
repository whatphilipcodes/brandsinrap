class RectBarChart {
  // Local object variabes
  PVector P;
  color testColor;
  float targetA;
  ArrayList<PVector> Verts = new ArrayList<PVector>();
  float lastXGrowth;
  float lastYGrowth;
  boolean isY;

  PShape chartShape;
  String brand;
  boolean highlight = true;


  RectBarChart(String brandName, PVector origin, color tCol, boolean Y) {
    brand = brandName;
    P = origin;
    testColor = tCol;
    isY = Y;
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
      Verts.add(Verts.get(index + 2));
    } else {
      // P index 0
      Verts.add(P);
      // Q index 1
      Verts.add(new PVector(P.x, P.y + (height - totalYGrowth)));
      // R index 2
      Verts.add(Verts.get(index + 1));
      // S index 3
      Verts.add(P);
    }
  }

  //Caculates target coordinates with propData at index
  void targetCoords() {
    targetA = calcTargetA();
    float offset;

    if (isY == true) {
      PVector PS = PVector.sub(Verts.get(index + 3), P);
      offset = targetA / PS.mag();
      // targetQ index 4
      Verts.add(new PVector(P.x, P.y + offset));
      // targetR index 5
      Verts.add(new PVector(Verts.get(index + 2).x, Verts.get(index + 4).y));

      lastYGrowth = offset;
      totalYGrowth = totalYGrowth + offset;
    } else {
      PVector PQ = PVector.sub(Verts.get(index + 1), P); //FEHLER HIER??? // Vektor AB -> B.x - A.x, B.y - A.y...? FIXED!
      offset = targetA / PQ.mag();
      // targetR index 4
      Verts.add(new PVector(P.x + offset, Verts.get(index + 1).y));
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

      PVector RtargetR = PVector.sub(Verts.get(index + 5), Verts.get(index + 2));
      float prox = RtargetR.mag();

      if (prox <= mergeThresh) {
        Verts.set(index + 1, Verts.get(index + 4));
        Verts.set(index + 2, Verts.get(index + 5));
      } else {
        // Q -> targetQ
        newQx = lerp(Verts.get(index + 1).x, Verts.get(index + 4).x, lerpSpeed); // Lerp x-coordinate
        newQy = lerp(Verts.get(index + 1).y, Verts.get(index + 4).y, lerpSpeed); // Lerp y-coordinate

        // R -> targetR
        newRx = lerp(Verts.get(index + 2).x, Verts.get(index + 5).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(index + 2).y, Verts.get(index + 5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(index + 1, new PVector(newQx, newQy));
        Verts.set(index + 2, new PVector(newRx, newRy));
      }
    } else {
      float newRx = 0;
      float newRy = 0;
      float newSx = 0;
      float newSy = 0;

      PVector StargetS = PVector.sub(Verts.get(index + 5), Verts.get(index + 3));
      float prox = StargetS.mag();

      if (prox <= mergeThresh) {
        Verts.set(index + 2, Verts.get(index + 4));
        Verts.set(index + 3, Verts.get(index + 5));
      } else {
        // R -> targetR
        newRx = lerp(Verts.get(index + 2).x, Verts.get(index + 4).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(index + 2).y, Verts.get(index + 4).y, lerpSpeed); // Lerp y-coordinate

        // S -> targetS
        newSx = lerp(Verts.get(index + 3).x, Verts.get(index + 5).x, lerpSpeed); // Lerp x-coordinate
        newSy = lerp(Verts.get(index + 3).y, Verts.get(index + 5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(index + 2, new PVector(newRx, newRy));
        Verts.set(index + 3, new PVector(newSx, newSy));
      }
    }
  }

  PVector newOrigin() {
    PVector newOrigin;
    if (isY == true) {
      newOrigin = new PVector(Verts.get(index).x, Verts.get(index).y + lastYGrowth);
    } else {
      newOrigin = new PVector(Verts.get(index).x + lastXGrowth, Verts.get(index).y);
    }
    return newOrigin;
  }

  void drawGraphic() {
    chartShape = createShape();
    //textureWrap(REPEAT);
    chartShape.beginShape();
    //s.textureMode(NORMAL);
    //s.texture(img);
    chartShape.noStroke();
    chartShape.fill(testColor);
    chartShape.vertex(Verts.get(index).x, Verts.get(index).y, 0, 0);
    chartShape.vertex(Verts.get(index + 1).x, Verts.get(index + 1).y, 2, 0);
    chartShape.vertex(Verts.get(index + 2).x, Verts.get(index + 2).y, 2, 2);
    chartShape.vertex(Verts.get(index + 3).x, Verts.get(index + 3).y, 0, 2);
    chartShape.endShape(CLOSE);
    //shape(s, 0, 0);
  }
}
