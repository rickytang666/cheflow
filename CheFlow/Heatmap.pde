
void drawHeatMap(PApplet appc) 
{
  appc.background(30);

  // Parameters for layout
  final float topMargin = 30;
  final float leftMargin = 40;
  final float rightMargin = 20;
  final float padding = 4;
  final int numCols = ceil(365 / 7.0);
  
  // compute the cellSize given the parameters

  float cellSize = (appc.width - leftMargin - rightMargin - (numCols - 1) * padding) / float(numCols);

  // Date setup

  LocalDate today = LocalDate.now();
  LocalDate startDate = today.minusDays(364);
  int startDayOfWeek = startDate.getDayOfWeek().getValue() % 7;

  // Draw day-of-week labels
  String[] daysOfWeek = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
  for (int i = 0; i < daysOfWeek.length; ++i)
  {
    appc.fill(255);
    appc.textAlign(RIGHT, CENTER);
    appc.text(daysOfWeek[i], leftMargin - 10, topMargin + i * (cellSize + padding) + cellSize / 2);
  }

  // Draw the heat map using rows and columns
  
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d");
  
  for (int i = 0; i < daily_durations.size(); i++) 
  {
    int activity = daily_durations.get(i);

    // Determine row and column based on index
    int col = (i + startDayOfWeek) / 7;
    int row = (i + startDayOfWeek) % 7;

    // Calculate x and y position
    float x = leftMargin + col * (cellSize + padding);
    float y = topMargin + row * (cellSize + padding);

    // Draw the cell
    appc.fill(getColor(activity));
    appc.noStroke();
    appc.rect(x, y, cellSize, cellSize, cellSize * 0.3);

    // Label the first cell of every 4th column with the date
    if (col % 4 == 0 && (col == 0 || row == 0)) 
    {
      appc.fill(255);
      appc.textAlign(CENTER, BOTTOM);
      String dateLabel = startDate.plusDays(i).format(formatter);
      appc.text(dateLabel, x + cellSize / 2, topMargin - 5);
    }
  }
}

// Determine color based on activity level
color getColor(int value) 
{
  float val = constrain(value, 0, 360);

  color startColor = #fff5f5;
  color endColor = #ff2222;

  float t = val/360;

  return lerpColor(startColor, endColor, t);
}
