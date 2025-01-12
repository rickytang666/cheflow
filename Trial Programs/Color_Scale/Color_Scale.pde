void setup() {
  size(400, 50);
  noLoop();
}

void draw() {
  for (int i = 0; i < width; i++) {
    float value = map(i, 0, width, 0, 100);
    stroke(redYellowGreenGradient(value));
    line(i, 0, i, height);
  }
}

color redYellowGreenGradient(float value) {
  value = constrain(value, 0, 100); // Ensure the value is within the 0-100 range
  
  if (value <= 50) {
    // Interpolate between Red and Yellow
    return lerpColor(color(255, 0, 0), color(255, 255, 0), value / 50.0);
  } else {
    // Interpolate between Yellow and Green
    return lerpColor(color(255, 255, 0), color(0, 255, 0), (value - 50) / 50.0);
  }
}
