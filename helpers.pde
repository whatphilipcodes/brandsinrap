// For small helper functions only

/*
// Calculates the Area of a face between the Vectors PQ and PS
float calcArea(PVector P, PVector Q, PVector S) {
  PVector PQ = PVector.add(P, Q);
  PVector PS = PVector.add(P, S);

  float A = PQ.mag() * PS.mag();

  return A;
}
*/

// Outputs random start value for isY
boolean initIsY() {
  float rando = random(-1, 1);
  boolean isStartY;
  if (rando >  0) {
    isStartY = true;
  } else {
    isStartY = false;
  }
  return isStartY;
}

// Outputs target Area at index iteration
float calcTargetA() {
  float totalA = width * height;
  float targetA = totalA * propData[bIndex];
  bIndex = bIndex + 1;
  return targetA;
}
