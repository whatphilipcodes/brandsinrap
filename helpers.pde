// For independent helper functions only

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
