import g4p_controls.*;
import java.awt.Font;
import java.awt.FontFormatException;
import java.io.File;
import java.io.IOException;

GLabel label;

void setup() {
  size(400, 200);

  // Load the San Francisco font from the project directory
  Font sfFont = null;
  try {
    sfFont = Font.createFont(Font.TRUETYPE_FONT, new File(dataPath("GoogleSans-BoldItalic.ttf"))).deriveFont(16f); // 16-point font
  } catch (FontFormatException | IOException e) {
    e.printStackTrace();
    exit();
  }

  // Create a GLabel and set the custom font
  label = new GLabel(this, 50, 50, 300, 30);
  label.setText("Hello, San Francisco!");
  label.setFont(sfFont); // Set the loaded font
  label.setTextBold();
  label.setOpaque(false); // Optional: Transparent background
}

void draw() {
  background(240); // Light background for better visibility
}
