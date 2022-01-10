// This projects main separate function(s)

void loadData(int year, int limit) {

  Table data = loadTable(year + ".csv", "header");
  println(year);
  int dataLength = 0;

  // Compute data length
  for (int i = 0; i < limit; i++) {
    if (data.getFloat(i, "Count") != 0) {
      dataLength++;
    }
  }

  propData = new float [dataLength];

  for (int i = 0; i < dataLength; i++) {
    propData[i] = data.getFloat(i, "Count");
  }

  // Calculate sum of all frequencies
  float sum = 0;
  for (float f : propData) sum += f;

  // Convert amounts to percent factors
  for (int i = 0; i < dataLength; i++) {
    propData[i] = propData[i]/sum;
  }
}

void nextYear() {
  int iterationMax = endYear - startYear;
  maskData.clear();
  //background(0);
  if (systems.size() != 0) systems.remove(0);
  systems.add(new ChartSystem(0,0,millis()));
  if (systemIteration == iterationMax) {
    systemIteration = 0;
  } else {
    systemIteration++;
  }
  animDone = false;
}
