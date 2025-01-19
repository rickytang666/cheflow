import g4p_controls.*;

GImageToggleButton imgToggleButton;
boolean isOn = false; // Boolean to track toggle state

void setup() {
  size(1000, 800);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);

  // Create the image toggle button
  imgToggleButton = new GImageToggleButton(this, 150, 75, "toggle.png", 1, 2);
  imgToggleButton.setTip("Toggle", GAlign.WEST, GAlign.SOUTH, 50);
}

void handleToggleButtonEvents(GImageToggleButton button, GEvent event) {
  if (button == imgToggleButton) {
    // Update boolean state based on the button's value
    isOn = (imgToggleButton.getState() == 1);
    println("Button state: " + (isOn ? "ON" : "OFF"));
  }
}

void draw() {
  background(240);

  // Display the current state
  fill(0);
  textSize(20);
  textAlign(CENTER);
  text("Button State: " + (isOn ? "ON" : "OFF"), width / 2, height - 20);
}
