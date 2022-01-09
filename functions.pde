// This projects functions

void loadData(String year) {
  data = loadTable(year+".csv", "header");
  float [] propRaw = new float [data.getRowCount()];
  propData = new float [data.getRowCount()];

  int rowCount = 0;
  int ii = 0;
  for (TableRow row : data.rows()) {
    if (ii < maxNumberOfBrands) {
      propRaw[rowCount] = row.getFloat("Count");
      rowCount++;
    }
    ii++;
  }

  // Calculate sum of all frequencies
  float sum = 0;
  for (float f : propRaw) sum += f;

  // Convert amounts to percent factors
  for (int i = 0; i < data.getRowCount(); i++) {
    propData[i] = propRaw[i]/sum;
  }
}
