import g4p_controls.*;

ArrayList<String> recipes;
int currentPage = 0;
int buttonsPerPage = 9;
int totalPages;
ArrayList<GButton> buttons = new ArrayList<>();
GButton prevButton, nextButton;

void setup() {
  size(1000, 700);
  recipes = new ArrayList<>();

  // Generate 50 test recipes
  for (int i = 1; i <= 50; i++) {
    recipes.add("Recipe " + i);
  }

  totalPages = (int) ceil((float) recipes.size() / buttonsPerPage);
  
  float navButtonWidth = 100;
  float navButtonHeight = 40;
  float navButtonY = height - 100;
  
  prevButton = new GButton(this, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
  prevButton.addEventHandler(this, "handleButtonEvents");

  nextButton = new GButton(this, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
  nextButton.addEventHandler(this, "handleButtonEvents");
  
  createButtons();
}

void draw()
{
  background(220);
}

void createButtons() 
{
  for (GButton btn : buttons) {
    if (btn != null) {
      btn.dispose();
    }
  }
  
  buttons.clear();
  
  int startIndex = currentPage * buttonsPerPage;
  int endIndex = min(startIndex + buttonsPerPage, recipes.size());
  float buttonWidth = 300;
  float buttonHeight = 50;
  float buttonSpacing = 10;
  float buttonStartX = 350;
  float buttonStartY = 50;
  
  for (int i = startIndex; i < endIndex; i++) 
  {
    int buttonIndex = i - startIndex;
    float x = buttonStartX;
    float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
    GButton btn = new GButton(this, x, y, buttonWidth, buttonHeight, recipes.get(i));
    btn.addEventHandler(this, "handleRecipesButton");
    buttons.add(btn);
  }
  
}

public void handleButtonEvents(GButton button, GEvent event) {
  if (button == nextButton && event == GEvent.CLICKED) {
    if (currentPage < totalPages - 1) {
      currentPage++;
      createButtons();
    }
  }
  else if (button == prevButton && event == GEvent.CLICKED) {
    if (currentPage > 0) {
      currentPage--;
      createButtons();
    }
  }
}


public void handleRecipesButton(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    println(button.getText());
  }
}
