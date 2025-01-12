// Quadratic equation coefficients
float a = 0.01;
float b = -0.3;
float c = -200;

// Animation variables
float currentX; // Tracks the current x position being drawn
float maxX; // Maximum x value for the curve

void setup() {
  size(800, 800); // Set canvas size
  background(255); // Set background to white
  noFill(); // No fill for the shape
  stroke(0); // Set stroke color to black
  strokeWeight(2); // Set stroke thickness

  currentX = -width / 2; // Start from the leftmost point
  maxX = width / 2; // End at the rightmost point
}

void draw() {
  // Continue animating until the curve is fully drawn
  if (currentX <= maxX) {
    // Draw a small portion of the curve
    float startY = a * sq(currentX) + b * currentX + c;
    float nextX = currentX + 1; // Increment x to the next step
    float endY = a * sq(nextX) + b * nextX + c;

    // Map mathematical coordinates to screen coordinates
    float screenX1 = map(currentX, -width / 2, width / 2, 0, width);
    float screenY1 = map(startY, -height / 2, height / 2, height, 0);
    float screenX2 = map(nextX, -width / 2, width / 2, 0, width);
    float screenY2 = map(endY, -height / 2, height / 2, height, 0);

    // Draw the line segment
    line(screenX1, screenY1, screenX2, screenY2);

    // Update the current x position
    currentX = nextX;
  }
}
