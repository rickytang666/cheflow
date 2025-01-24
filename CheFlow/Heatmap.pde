// This file is for drawing the heat map of the past 365 days of activity

// Function for drawing the heat map given the PAplet object (Gitub-like, past 365 days)

void drawHeatMap(PApplet appc) 
{

  // set up font/background

  appc.background(30);
  appc.textFont(drawing_font);
  appc.textSize(14);

  // Parameters for layout

  final float topMargin = 40;
  final float leftMargin = 50;
  final float rightMargin = 20;
  final float padding = 4; // distance between cells
  final int numCols = ceil(365 / 7.0);
  
  // compute the size of cells given the parameters

  float cellSize = (appc.width - leftMargin - rightMargin - (numCols - 1) * padding) / float(numCols);

  // Date setup

  LocalDate today = LocalDate.now();
  LocalDate startDate = today.minusDays(364); // since we are using today as the last day, we need to go back 364 days
  int startDayOfWeek = startDate.getDayOfWeek().getValue() % 7; // 0 is Sunday, 1 is Monday, ..., 6 is Saturday

  // Draw day-of-week labels

  String[] daysOfWeek = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
  for (int i = 0; i < daysOfWeek.length; ++i)
  {
    appc.fill(255);
    appc.textAlign(RIGHT, CENTER);
    appc.text(daysOfWeek[i], leftMargin - 10, topMargin + i * (cellSize + padding) + cellSize / 2);
  }

  // Draw the heat map using rows and columns
  
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d"); // format for the date labels
  
  for (int i = 0; i < daily_durations.size(); i++) 
  {
    int activity = daily_durations.get(i);

    // Determine row and column based on index

    int col = (i + startDayOfWeek) / 7; // integer division can be handy here
    int row = (i + startDayOfWeek) % 7;

    // Calculate x and y position

    float x = leftMargin + col * (cellSize + padding);
    float y = topMargin + row * (cellSize + padding);

    // Draw the cell

    appc.fill(getColor(activity));
    appc.noStroke();
    appc.rect(x, y, cellSize, cellSize, cellSize * 0.3);
    appc.textSize(15);

    // Label the first cell of every 4th column with the date

    if ((i == 0) || (col % 4 == 0 && row == 0)) // absolute first cell / first cell of every 4th column
    {
      appc.fill(255);
      appc.textAlign(CENTER, BOTTOM);
      String dateLabel = startDate.plusDays(i).format(formatter);
      appc.text(dateLabel, x + cellSize / 2, topMargin - 10);
    }
  }
}

// Function to determine color based on the duration length

color getColor(int value) 
{
  float val = constrain(value, 0, 240); // 4 hours is already full marks, for the criteria of this app

  color startColor = #fff5f5; // a very very faint red
  color endColor = #ff2222; // saturated red

  float t = val/300;

  // Use linear interpolation to determine the color

  return lerpColor(startColor, endColor, t);
}
