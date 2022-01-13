// Main code to construct bars from table data

class RectBarChart {
  // Local object variabes
  ArrayList<PVector> Verts = new ArrayList<PVector>();
  
  float lastXGrowth;
  float lastYGrowth;
  
  PShape mask;
  boolean isY;
  PVector P;
  
  int chartIndex;

  // Constructor
  RectBarChart(PVector origin, boolean Y, int cID, PVector growth) {
    lastXGrowth = growth.x;
    lastYGrowth = growth.y;
    chartIndex = cID;
    P = origin;
    isY = Y;
  }

  // Sets up initial coordinates
  void initCoords() {
    Verts.clear();
    if (isY == true) {
      // P index 0
      Verts.add(P);
      // Q index 1
      Verts.add(P);
      // R index 2
      Verts.add(new PVector(P.x + (width - lastXGrowth), P.y));
      // S index 3
      Verts.add(Verts.get(2));
    } else {
      // P index 0
      Verts.add(P);
      // Q index 1
      Verts.add(new PVector(P.x, P.y + (height - lastYGrowth)));
      // R index 2
      Verts.add(Verts.get(1));
      // S index 3
      Verts.add(P);
    }
  }

  // Caculates target coordinates using propData
  PVector targetCoords() {
    float targetA = calcTargetA(chartIndex);
    float offset;

    if (isY == true) {
      PVector PS = PVector.sub(Verts.get(3), P);
      offset = targetA / PS.mag();
      // targetQ index 4
      Verts.add(new PVector(P.x, P.y + offset));
      // targetR index 5
      Verts.add(new PVector(Verts.get(2).x, Verts.get(4).y));

      lastYGrowth = offset;
      return new PVector(0, offset);
      
    } else {
      PVector PQ = PVector.sub(Verts.get(1), P);
      offset = targetA / PQ.mag();
      // targetR index 4
      Verts.add(new PVector(P.x + offset, Verts.get(1).y));
      // targetS index 5
      Verts.add(new PVector(P.x + offset, P.y));

      lastXGrowth = offset;
      return new PVector(offset,0);
    }
  }

  // Animates the vertex data
  boolean morph(float lerpSpeed, float mergeThresh) {
    if (isY == true) {
      float newQx = 0;
      float newQy = 0;
      float newRx = 0;
      float newRy = 0;

      PVector RtargetR = PVector.sub(Verts.get(5), Verts.get(2));
      float prox = RtargetR.mag();

      if (prox <= mergeThresh) {
        Verts.set(1, Verts.get(4));
        Verts.set(2, Verts.get(5));
        return true;
      } else {
        // Q -> targetQ
        newQx = lerp(Verts.get(1).x, Verts.get(4).x, lerpSpeed); // Lerp x-coordinate
        newQy = lerp(Verts.get(1).y, Verts.get(4).y, lerpSpeed); // Lerp y-coordinate

        // R -> targetR
        newRx = lerp(Verts.get(2).x, Verts.get(5).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(2).y, Verts.get(5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(1, new PVector(newQx, newQy));
        Verts.set(2, new PVector(newRx, newRy));
        return false;
      }
    } else {
      float newRx = 0;
      float newRy = 0;
      float newSx = 0;
      float newSy = 0;

      PVector StargetS = PVector.sub(Verts.get(5), Verts.get(3));
      float prox = StargetS.mag();

      if (prox <= mergeThresh) {
        Verts.set(2, Verts.get(4));
        Verts.set(3, Verts.get(5));
        return true;
      } else {
        // R -> targetR
        newRx = lerp(Verts.get(2).x, Verts.get(4).x, lerpSpeed); // Lerp x-coordinate
        newRy = lerp(Verts.get(2).y, Verts.get(4).y, lerpSpeed); // Lerp y-coordinate

        // S -> targetS
        newSx = lerp(Verts.get(3).x, Verts.get(5).x, lerpSpeed); // Lerp x-coordinate
        newSy = lerp(Verts.get(3).y, Verts.get(5).y, lerpSpeed); // Lerp y-coordinate

        Verts.set(2, new PVector(newRx, newRy));
        Verts.set(3, new PVector(newSx, newSy));
        return false;
      }
    }
  }
  
  // Calculates origin for the next barchart
  PVector newOrigin() {
    PVector newOrigin;
    if (isY == true) {
      newOrigin = new PVector(Verts.get(0).x, Verts.get(0).y + lastYGrowth);
    } else {
      newOrigin = new PVector(Verts.get(0).x + lastXGrowth, Verts.get(0).y);
    }
    return newOrigin;
  }
  
  // Translates vertices into mask (PGraphics)
  void createMaskShape(PGraphics pg) {
    mask = createShape();
    mask.beginShape();
    mask.noStroke();
    mask.fill(255); // Area that is visible after masking ( -> white)
    mask.vertex(Verts.get(0).x, Verts.get(0).y);
    mask.vertex(Verts.get(1).x, Verts.get(1).y);
    mask.vertex(Verts.get(2).x, Verts.get(2).y);
    mask.vertex(Verts.get(3).x, Verts.get(3).y);
    mask.endShape(CLOSE);

    pg.beginDraw();
    pg.shape(mask, 0, 0);
    pg.endDraw();
  }
}
