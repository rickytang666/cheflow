import g4p_controls.*;

ArrayList<String> recipes;
int currentPage = 0;
int buttonsPerPage = 9;
int totalPages;
ArrayList<GButton> buttons = new ArrayList<>();

void setup() {
  size(1000, 700);
  recipes = new ArrayList<>();

  // Generate 50 test recipes
  for (int i = 1; i <= 50; i++) {
    recipes.add("Recipe " + i);
  }

  totalPages = (int) ceil((float) recipes.size() / buttonsPerPage);
  createButtons();
}

void draw()
{

}

void createButtons() {
  // Remove existing buttons
  for (GButton button : buttons) {
    button.dispose(); // Dispose of the button to remove it from the canvas
  }
  buttons.clear(); // Clear the button list to avoid lingering references

  // Create recipe buttons for the current page
  int startIndex = currentPage * buttonsPerPage;
  int endIndex = min(startIndex + buttonsPerPage, recipes.size());
  float buttonWidth = 300;
  float buttonHeight = 50;
  float buttonSpacing = 10;
  float buttonStartX = 350;
  float buttonStartY = 50;

  // Add buttons for current recipes
  for (int i = startIndex; i < endIndex; i++) {
    int buttonIndex = i - startIndex;
    float x = buttonStartX;
    float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
    GButton button = new GButton(this, x, y, buttonWidth, buttonHeight, recipes.get(i));
    button.addEventHandler(this, "handleButtonEvents");
    buttons.add(button);
  }

  // Add navigation buttons
  float navButtonWidth = 100;
  float navButtonHeight = 40;
  float navButtonY = height - 100;

  GButton prevButton = new GButton(this, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
  prevButton.addEventHandler(this, "handleButtonEvents");
  prevButton.setEnabled(currentPage > 0);
  buttons.add(prevButton);

  GButton nextButton = new GButton(this, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
  nextButton.addEventHandler(this, "handleButtonEvents");
  nextButton.setEnabled(currentPage < totalPages - 1);
  buttons.add(nextButton);
}


public void handleButtonEvents(GButton button, GEvent event) {
  if (button.getText().equals("Previous")) {
    if (currentPage > 0) {
      currentPage--;
      createButtons();
    }
  } else if (button.getText().equals("Next")) {
    if (currentPage < totalPages - 1) {
      currentPage++;
      createButtons();
    }
  } else {
    println("Clicked on " + button.getText());
  }
}