// This file contains helper functions that are used in multiple files
// The functions are used for various purposes
// The functions are designed to be reusable and modular

/* SORTING/SEARCHING RELATED */

// Function to sort the recipes based on the option provided

void sort_recipes(int option)
{
  /*
    1: Sort by id (descending)
    2: Sort by id (ascending)
    3: Sort by name (alphabetical)
  */

  // sorting syntax walkthrough
  // if the varaibles we compare are numeric, we can just subtract them. 
  // if the result is negative, maintain the order, if positive, swap

  // if the variables are strings, we can use the compareTo method
  // if the varaibles are self-defined objects, we can use the compareTo method as well (but define them in the class)

  if (option == 1)
  {
    recipes.sort((a, b) -> b.id - a.id);
  }
  else if (option == 2)
  {
    recipes.sort((a, b) -> a.id - b.id);
  }
  else if (option == 3)
  {
    recipes.sort((a, b) -> a.name.compareTo(b.name));
  }
}

// Levenshtein Distance: Measures how many single-character edits (insertions, deletions, substitutions) are needed to change one string into another.
// allows some fuzzy matching
// Link to research: https://www.geeksforgeeks.org/introduction-to-levenshtein-distance/

/* 
  Distance between "kitten" and "sitting" is 3:
  Replace 'k' with 's'.
  Replace 'e' with 'i'.
  Add 'g' at the end.
 */

int levenshtein_distance(String s1, String s2) 
{

  // Create a 2D array (DP table) to store the distances between substrings of the two strings

  // dp[i][j] stores the minimum number of edits required to transform the first i characters of s1 to the first j characters of s2

  int[][] dp = new int[s1.length() + 1][s2.length() + 1];

  for (int i = 0; i <= s1.length(); i++) 
  {
    for (int j = 0; j <= s2.length(); j++) 
    {
      if (i == 0) 
      {
        // if s1 is empty, we need to add all characters of s2

        dp[i][j] = j;
      } 
      else if (j == 0) 
      {
        // if s2 is empty, we need to remove all characters of s1

        dp[i][j] = i;
      } 
      else 
      {
        // If the current characters are the same, cost = 0
        // Otherwise, cost = 1 (we need a substitution)

        int cost = (s1.charAt(i - 1) == s2.charAt(j - 1)) ? 0 : 1;

        // Fill dp[i][j] with the minimum of three operations:
        // 1. Deletion (dp[i-1][j] + 1)
        // 2. Insertion (dp[i][j-1] + 1)
        // 3. Substitution (dp[i-1][j-1] + cost)
        
        dp[i][j] = min( min(dp[i - 1][j] + 1, dp[i][j - 1] + 1), dp[i - 1][j - 1] + cost );
      }
    }
  }

  // the minimum number of edits required to transform the entire s1 into s2 is stored here

  return dp[s1.length()][s2.length()];
}

// Function to calculate similarity between two strings based on the Levenshtein distance
/* 
  1.0 - exactly match
  0.9+ - very strict (minor differences)
  0.7+ - strict (some differences)
  0.5+ - lenient (many differences) allow partial overlap or rearrangement
  0.3+ - very lenient (major differences) allow partial overlap or rearrangement
  0.0-0.3 - almost no similarity
*/

float calculate_similarity(String s1, String s2) 
{
  int max_length = max(s1.length(), s2.length());
  int distance = levenshtein_distance(s1, s2);
  return 1.0 - (float) distance / max_length; // similarity as a percentage
}

// Recursive binary searching function

ArrayList<Recipe> recursive_search(int start, int end, String search)
{
  // handle wrong case

  if (start > end)
  {
    return new ArrayList<Recipe>();
  }

  // Base case: if there's only 1 recipe, we only check this

  if (start == end)
  {
    ArrayList<Recipe> result = new ArrayList<Recipe>();
    Recipe r = recipes.get(start);
    
    // split the name into words and just check for keyword

    String[] words = r.name.toLowerCase().split("\\s+"); // split by space (\\s+ is the regex for space, more robust than " ", since it can handle any whitespaces)
    for (String word : words)
    {
      float similarity = calculate_similarity(word, search);

      // either highly matched but not exactly, or partially matched but contains the keyword

      if (similarity >= 0.7 || (similarity >= 0.4 && word.contains(search)))
      {
        result.add(r);
        break;
      }
    }

    return result;
  }

  // split the list into 2 halves

  int mid = (start + end) / 2;

  // resurively search the left and right halves

  ArrayList<Recipe> left = recursive_search(start, mid, search);
  ArrayList<Recipe> right = recursive_search(mid + 1, end, search);

  // merge the results

  left.addAll(right);
  return left;

}

// Function to fill the search results based on the search string provided

void fill_search_results(String search)
{
  
  search_results.clear();

  if (search.equals("") || search.equals(" "))
  {
    // uneffective serach, return all recipes

    search_results.addAll(recipes);
  }
  else
  {
    // use the recursive search function to find the matching recipes
    search_results = recursive_search(0, recipes.size() - 1, search.toLowerCase());
  }
  
}



// Function to fill the matching results based on each recipe's calculations

void fill_matching_results()
{
  matching_results.clear();
  matching_results.addAll(recipes); // work on a copy, since the sorting will change the original list

  for (Recipe r : matching_results)
  {
    r.set_matching_score();
  }

  // float cannot be sorted directly, so we need to use the compare function

  matching_results.sort((a, b) -> Float.compare(b.matching_score, a.matching_score));
}

// Function to check if the recipe name is repeated

Boolean is_recipe_repeated(String name, ArrayList<Recipe> arr)
{

  // Loop through the recipes and check for repeated names

  for (Recipe r : arr)
  {
    if (r.name.equals(name))
    {
      return true;
    }
  }
  
  return false;
}

// Function to check if the ingredient name is repeated

Boolean is_ingredient_repeated(String name, int option)
{
  // option: 1 for current recipe, 2 for fridge

  // Loop through the array and check for repeated names
  
  if (option == 1)
  {
    for (IngredientStatus ing_status : current_r.ingredients)
    {
      if (ing_status.ingredient.name.equals(name))
      {
        return true;
      }
    }
  }
  else if (option == 2)
  {
    for (Ingredient ing : fridge)
    {
      if (ing.name.equals(name))
      {
        return true;
      }
    }
  }
  
  return false;

}

// Function to truncate text based on the maximum width (in case it exceeds)

String truncate_text(String text, float maxWidth) 
{
  maxWidth *= 0.8; // leave enough margin
  textFont(drawing_font); // set the font for the text for more accurate width calculation
  float w = textWidth(text);
  
  if (w <= maxWidth) 
  {
    return text;
  }
  
  String str = text + "...";
  int i = text.length() - 1;
  
  // keep removing characters until the width is less than the maximum width

  while(textWidth(str) > maxWidth)
  {
    --i;
    str = text.substring(0, i) + "...";
  }

  return str;
}

// Function to get the related recipes based on the ingredient name

ArrayList<String> get_related_recipes(String name)
{
  ArrayList<String> related_recipes = new ArrayList<String>();

  // Loop through the recipes and each ingredient array, and check for the ingredient name

  for (Recipe r : recipes)
  {
    for (IngredientStatus ing_status : r.ingredients)
    {
      if (ing_status.ingredient.name.equals(name))
      {
        related_recipes.add(r.name); // add the recipe name to the list
        break;
      }
    }
  }

  return related_recipes;
}

// Function to sort the log records from latest to oldest

void sort_log_records()
{
  // use the compare function to sort the log records based on the time finished (implemented in Time class)

  log_records.sort((a, b) -> b.time_finished.compareTo(a.time_finished));
}


/* CALCULATIONS */

// Function to get the color based on the matching score provided (red-yellow-green scale)

color get_color_from_value(float value)
{
  // red is 0, green is 100

  value = constrain(value, 0, 100); // Ensure the value is within the 0-100 range
  
  if (value <= 50) 
  {
    // Interpolate between Red and Yellow
    return lerpColor(color(255, 0, 0), color(255, 255, 0), value / 50.0);
  } 
  else 
  {
    // Interpolate between Yellow and Green
    return lerpColor(color(255, 255, 0), color(0, 255, 0), (value - 50) / 50.0);
  }
  
}

// Function to check if the given year is a leap year

Boolean is_leap_year(int input)
{
  // Leap year is divisible by 4, but not by 100 unless it is divisible by 400

  if (input % 4 == 0)
  {
    if (input % 100 == 0)
    {
      if (input % 400 == 0)
      {
        return true;
      }
      return false;
    }
    return true;
  }
  return false;
}

// Function to get the days in the month based on the month and year provided

int days_in_month(int month, int year)
{
  if (month == 2)
  {
    if (is_leap_year(year))
    {
      return 29;
    }
    return 28;
  }
  else if (month == 4 || month == 6 || month == 9 || month == 11)
  {
    return 30;
  }
  return 31;
}


/* VALIDATION RELATED */

// Function to check if the given time string is valid (YYYY-MM-DD HH:MM, and not later than the current time)

int validate_time_str(String timeStr) 
{
  // return values: 0 for valid, -1 for incorrect format, -2 for invalid date/time, -3 for later than the current time

  // Split the string into date and time

  String[] parts = timeStr.split(" ");
  if (parts.length != 2) 
  {
    return -1; // Incorrect format (missing space or parts)
  }

  String datePart = parts[0];
  String timePart = parts[1];

  // Validate the date part (YYYY-MM-DD)

  String[] dateParts = datePart.split("-");
  if (dateParts.length != 3) 
  {
    return -1; // Incorrect date format
  }

  // parse the numbers in the string. use try-catch to handle the NumberFormatException

  try 
  {
    int year = Integer.parseInt(dateParts[0]);
    int month = Integer.parseInt(dateParts[1]);
    int day = Integer.parseInt(dateParts[2]);

    if (month < 1 || month > 12) 
    {
      return -2; // Invalid month
    }

    // Check days in the month
    if (day < 1 || day > days_in_month(month, year)) 
    {
      return -2; // Invalid day
    }
  } 
  catch (NumberFormatException e) 
  {
    return -1; // Date part contains non-numeric values
  }

  // Validate the time part (HH:MM)
  String[] timeParts = timePart.split(":");
  if (timeParts.length != 2) 
  {
    return -1; // Incorrect time format
  }

  try 
  {
    int hour = Integer.parseInt(timeParts[0]);
    int minute = Integer.parseInt(timeParts[1]);

    if (hour < 0 || hour > 23) 
    {
      return -2; // Invalid hour
    }

    if (minute < 0 || minute > 59) 
    {
      return -2; // Invalid minute
    }
  } 
  catch (NumberFormatException e) 
  {
    return -1; // Time part contains non-numeric values
  }

  // Check if the gvien time is later than the current time

  Time current_time = new Time();
  Time given_time = new Time(timeStr);

  if (given_time.compareTo(current_time) > 0) 
  {
    return -3; // Given time is later than the current time
  }

  // All checks passed

  return 0;
}


/* STATISTICS & INSIGHTS RELATED */

// Function to get the average duration of the activities in the last n days (for the insights page in home page)

float get_average_duration(int days)
{
  if (days <= 0)
  {
    return 0; // Invalid input
  }

  update_daily_durations(); // Ensure the daily durations are up-to-date

  float sum = 0.0;

  for (int i = daily_durations.size() - days; i < daily_durations.size(); i++)
  {
    sum += daily_durations.get(i);
  }

  return sum / days;
}

// Function to get the total duration of the activities in the last n days (for the insights page in home page)

int get_longest_streak()
{
  if (log_records.size() == 0)
  {
    return 0; // impossible to have a streak without any records
  }

  ArrayList<Log> data = new ArrayList<Log>();
  data.addAll(log_records); // work on a copy, to maintain the original list unchanged
  data.sort((a, b) -> a.time_finished.compareTo(b.time_finished));

  int max_streak = 1, current_streak = 1;

  for (int i = 1; i < data.size(); i++) // start from the second element
  {
    Log prev = data.get(i - 1);
    Log curr = data.get(i);

    if (curr.time_finished.days_difference(prev.time_finished) == 0)
    {
      // streak maintains (same day)
      continue;
    }
    else if (curr.time_finished.days_difference(prev.time_finished) == 1)
    {
      // next day, streak grow
      current_streak++;
    }
    else
    {
      // streak broken since the days difference is more than 1
      max_streak = max(max_streak, current_streak); // update the max streak
      current_streak = 1; // reset the current streak
    }
  }

  max_streak = max(max_streak, current_streak); // update the max streak for the last streak

  return max_streak;

}


/* GRAPHING & REGRESSION RELATED */

// Function to draw the scatter plot based on the last n days of data, with the option of regression

void draw_scatter_plot(PApplet appc, int n, String option) 
{
  // Constrain n between 7 and 365
  n = constrain(n, 7, 365);
  
  float circle_size = map(float(n), 7, 365, 8, 3); // Point size based on the number of days

  // Background and axis setup
  final float right_margin = 70;
  appc.background(30);
  appc.stroke(255);
  appc.strokeWeight(2);
  appc.fill(255);

  // Draw axes
  int xAxis = 60; // Left margin
  int yAxis = appc.height - 50; // Bottom margin

  // X-axis
  appc.line(xAxis, yAxis, appc.width - right_margin, yAxis);
  // Y-axis
  appc.line(xAxis, yAxis, xAxis, 50);

  // Calculate max duration for mapping
  float maxDuration = 0;
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  {
    maxDuration = max(maxDuration, daily_durations.get(i));
  }

  // Draw scatter plot
  appc.fill(#00FFFF); // Cyan color
  appc.noStroke();
  // plot the points
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  {
    float duration = daily_durations.get(i);

    float x = map(i - (daily_durations.size() - n), 0, n - 1, xAxis, appc.width - right_margin);
    float y = map(duration, 0, maxDuration, yAxis, 50);
    appc.circle(x, y, circle_size);
  }

  
  // Draw regression

  if (option.equals("quadratic"))
  {
    quadratic_regression(appc, n, maxDuration, xAxis, yAxis);
  }
  else if (option.equals("exponential"))
  {
    exponential_regression(appc, n, maxDuration, xAxis, yAxis);
  }
  else
  {
    linear_regression(appc, n, maxDuration, xAxis, yAxis);
  }


  // Label axes

  appc.textFont(drawing_font);
  appc.fill(255);
  appc.textAlign(CENTER, CENTER);
  appc.textSize(20);

  // X-axis labels (start date and now)

  Time now = new Time();
  Time start = now.subtract_days(n - 1);

  String str1 = start.get_date_str();
  String str2 = now.get_date_str();

  appc.text(str1, xAxis, yAxis + 20);
  appc.text(str2, appc.width - right_margin, yAxis + 20);
  appc.textAlign(CENTER);
  appc.text("Date", (appc.width - right_margin + xAxis) / 2, yAxis + 30);

  // Y-axis labels (0 and max duration)
  
  appc.textAlign(RIGHT);
  appc.text("0", xAxis - 10, yAxis);
  appc.text((int) maxDuration, xAxis - 10, 50);

  // Rotate the text for the Y-axis labelS

  appc.pushMatrix(); // Save the current transformation matrix
  appc.translate(xAxis - 40, yAxis/2); // Move to the center of the Y-axis
  appc.rotate(-PI/2); // Rotate the text
  appc.textAlign(CENTER, CENTER); // Align the text to the center
  appc.text("Duration (minutes)", 0, 0); // Draw the text
  appc.popMatrix(); // Restore the transformation matrix
  
}

// Function to draw linear regression line

void linear_regression(PApplet appc, int n, float maxDuration, int xAxis, int yAxis)
{
  // Calculate linear regression

  float[] coefficients = calculate_linear_coefficients(n);

  float slope = coefficients[0];
  float intercept = coefficients[1];

  // Map regression line to canvas

  float yStart = slope * 0 + intercept;
  float yEnd = slope * (n - 1) + intercept; // n - 1 since the index starts from 0

  float xStartMapped = xAxis;
  float xEndMapped = appc.width - 50;
  float yStartMapped = map(yStart, 0, maxDuration, yAxis, 50);
  float yEndMapped = map(yEnd, 0, maxDuration, yAxis, 50);

  // Draw linear regression line
  appc.stroke(0, 255, 0); // Green color
  appc.strokeWeight(1.5);
  appc.line(xStartMapped, yStartMapped, xEndMapped, yEndMapped);
}

// Function to calculate the linear regression coefficients for drawing the line

float[] calculate_linear_coefficients(int n)
{
  // Link to the reserach: https://youtu.be/P8hT5nDai6A?si=ltKouPhcpJ1ocL_N

  float n_data = n; // just a float version of n

  float sumX = 0, sumY = 0, sumXY = 0, sumX_squared = 0;
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  {
    float x = i - (daily_durations.size() - n);
    float y = daily_durations.get(i);
    sumX += x;
    sumY += y;
    sumXY += x * y;
    sumX_squared += x * x;
  }

  float m = (n_data * sumXY - sumX * sumY) / (n_data * sumX_squared - sumX * sumX);
  float b = (sumY - m * sumX) / n_data;

  float coefficients[] = {m, b};

  return coefficients;

}

// Function to draw quadratic regression curve

void quadratic_regression(PApplet appc, int n, float max_duration, int xAxis, int y_axis)
{
  // Calculate quadratic regression
  
  float[] coefficients = calculate_quadratic_coefficients(n);
  float a = coefficients[0];
  float b = coefficients[1];
  float c = coefficients[2];
  
  // Draw quadratic regression curve

  appc.stroke(255, 0, 0);
  appc.strokeWeight(1.5);
  appc.noFill();

  // Loop through every picxel along the x-axis and evaluate the quadratic function

  for (int i = xAxis; i < appc.width - 50; i++) 
  {
    float x1 = map(i, xAxis, appc.width - 50, 0, n - 1);
    float x2 = map(i + 1, xAxis, appc.width - 50, 0, n - 1);

    // evaluate the 2-points y values and connect them using short lines

    float y1 = a * pow(x1, 2) + b * x1 + c;
    float y2 = a * pow(x2, 2) + b * x2 + c;

    // map them

    float y1_mapped = map(y1, 0, max_duration, y_axis, 50);
    float y2_mapped = map(y2, 0, max_duration, y_axis, 50);

    appc.line(i, y1_mapped, i + 1, y2_mapped);
  }

}

// Function to calculate the quadratic regression coefficients for drawing the curve

float[] calculate_quadratic_coefficients(int n)
{
  // Link to research: https://youtu.be/Tx9Qr3kK7Ls?si=Oyh0YWv_D7hNX25l

  float nData = n; // just a float version of n

  int startIndex = daily_durations.size() - n;

  float sumX = 0, sumY = 0, sumX2 = 0, sumX3 = 0, sumX4 = 0, sumXY = 0, sumX2Y = 0;

  for (int i = startIndex; i < daily_durations.size(); ++i) 
  {
    int x = i - startIndex;
    int y = daily_durations.get(i);

    sumX += x;
    sumY += y;
    sumX2 += pow(x, 2);
    sumX3 += pow(x, 3);
    sumX4 += pow(x, 4);
    sumXY += x * y;
    sumX2Y += pow(x, 2) * y;
  }

  float sumXX = sumX2 - pow(sumX, 2) / nData;
  sumXY = sumXY - (sumX * sumY) / nData;
  float sumXX2 = sumX3 - (sumX * sumX2) / nData;
  sumX2Y = sumX2Y - (sumX2 * sumY) / nData;
  float sumX2X2 = sumX4 - pow(sumX2, 2) / nData;

  float a = (sumX2Y * sumXX - sumXY * sumXX2) / (sumXX * sumX2X2 - pow(sumXX2, 2));
  float b = (sumXY * sumX2X2 - sumX2Y * sumXX2) / (sumXX * sumX2X2 - pow(sumXX2, 2));
  float c = (sumY/nData) - (b * sumX/nData) - (a * sumX2/nData);

  float[] coefficients = {a, b, c};

  return coefficients;

}

// Function to draw exponential regression curve

void exponential_regression(PApplet appc, int n, float maxDuration, int xAxis, int yAxis)
{
  // Calculate exponential regression

  float[] coefficients = calculate_exponential_coefficients(n);

  float m = coefficients[0], b = coefficients[1];

  float a = exp(b); // A = exp(intercept)

  appc.stroke(255, 0, 255);
  appc.strokeWeight(1.5);
  appc.noFill();

  for (int i = xAxis; i < appc.width - 50; ++i)
  {
    // same as quadratic, evaluate the 2-points y values and connect them using short lines

    float x1 = map(i, xAxis, appc.width - 50, 0, n - 1);
    float x2 = map(i + 1, xAxis, appc.width - 50, 0, n - 1);

    float y1 = a * exp(m * x1); // Y = A * exp(m * x)
    float y2 = a * exp(m * x2);

    // map the y values

    float y1_mapped = map(y1, 0, maxDuration, yAxis, 50);
    float y2_mapped = map(y2, 0, maxDuration, yAxis, 50);

    appc.line(i, y1_mapped, i + 1, y2_mapped);
  }

}

// Function to calculate the exponential regression coefficients for drawing the curve

float[] calculate_exponential_coefficients(int n)
{

  // Link to research: https://www.omnicalculator.com/statistics/exponential-regression
  int startIndex = daily_durations.size() - n;

  float sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
  int valid_points = 0;

  for (int i = startIndex; i < daily_durations.size(); ++i) 
  {
    float x = i - startIndex;
    float y = daily_durations.get(i);

    if (y <= 0) {
      continue; // Skip non-positive values
    }

    valid_points++;

    float log_y = log(y); // Transform y to ln(y)

    sumX += x;
    sumY += log_y;
    sumXY += x * log_y;
    sumX2 += x * x;
  }

  // Avoid divide-by-zero errors by adding a check
  float denominator = (valid_points * sumX2 - sumX * sumX);
  float tolerance = 1e-6; // A small value to avoid division by zero
  if (abs(denominator) < tolerance) 
  {
    println("Error: Denominator in slope calculation is zero.");
    return new float[]{0, 0}; // Return zero coefficients as a fallback
  }

  float slope = (valid_points * sumXY - sumX * sumY) / denominator; // B = slope
  float intercept = (sumY - slope * sumX) / valid_points; // A = intercept

  float[] coefficients = {slope, intercept};

  return coefficients;
}
