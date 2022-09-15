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
  //return isStartY;
  return false;
}

// Outputs target Area at index iteration
float calcTargetA(int chartIndex) {
  float totalA = width * height;
  float targetA = totalA * propData[chartIndex];
  return targetA;
}

void keyReleased() {
  if (key ==  's' || key ==  'S') saveFrame("data/savedFrames/" + timestamp() + "_##.png");
}

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
