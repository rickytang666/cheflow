import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;
import java.time.format.DateTimeFormatter;

ArrayList<Integer> daily_durations = new ArrayList<>();

// Fill with sample data for the past 365 days (replace with actual data)
void setup() 
{
  size(1200, 200);
  for (int i = 0; i < 365; i++) 
  {
    daily_durations.add((int)random(0, 20)); // Simulating random activity levels
  }

  drawHeatMap();
}

void drawHeatMap() 
{
  background(30);

  // Parameters for layout
  int cellSize = 18;
  int padding = 3;
  int topMargin = 40;
  int leftMargin = 50;

  // Date setup

  LocalDate today = LocalDate.now();
  LocalDate startDate = today.minusDays(364);
  int startDayOfWeek = startDate.getDayOfWeek().getValue() % 7;

  // Draw day-of-week labels
  String[] daysOfWeek = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
  for (int i = 0; i < daysOfWeek.length; ++i)
  {
    fill(255);
    textAlign(RIGHT, CENTER);
    text(daysOfWeek[i], leftMargin - 10, topMargin + i * (cellSize + padding) + cellSize / 2);
  }

  // Draw the heat map using rows and columns
  int numCols = ceil(365 / 7.0);
  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM d");
  
  for (int i = 0; i < daily_durations.size(); i++) 
  {
    int activity = daily_durations.get(i);

    // Determine row and column based on index
    int col = (i + startDayOfWeek) / 7;
    int row = (i + startDayOfWeek) % 7;

    // Calculate x and y position
    int x = leftMargin + col * (cellSize + padding);
    int y = topMargin + row * (cellSize + padding);

    // Draw the cell
    fill(getColor(activity));
    noStroke();
    rect(x, y, cellSize, cellSize, cellSize * 0.35);

    // Label the first cell of every 4th column with the date
    if (col % 4 == 0 && (col == 0 || row == 0)) 
    {
      fill(255);
      textAlign(CENTER, BOTTOM);
      String dateLabel = startDate.plusDays(i).format(formatter);
      text(dateLabel, x + cellSize / 2, topMargin - 5);
    }
  }
}

// Determine color based on activity level
color getColor(int activity) 
{
  float val = constrain(activity, 0, 20);

  color startColor = #fff5f5;
  color endColor = #ff2222;

  float t = val/20.0;

  return lerpColor(startColor, endColor, t);
}
