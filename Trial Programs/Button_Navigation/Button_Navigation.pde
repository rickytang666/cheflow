import g4p_controls.*;

ArrayList<String> recipes = new ArrayList<>();
int[] currentPages = {0, 0, 0}; 
int buttonsPerPage = 9;
int[] totalPages = {0, 0, 0};
ArrayList<GButton> buttons = new ArrayList<>();
int layer = 0;
GButton prevButton, nextButton;
GLabel txt;
GButton back;

void setup() {
  size(1000, 700);
  
  for (int i = 1; i <= 50; i++) {
    recipes.add("Recipe " + i);
  }

  totalPages[0] = (int) ceil((float) recipes.size() / buttonsPerPage);
  
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
  
  
  if (layer == 0)
  {
    int startIndex = currentPages[0] * buttonsPerPage;
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
  else
  {
    txt = new GLabel(this, 100, 100, 200, 100, "Hahahaha");
    txt.setVisible(true);
    
    back = new GButton(this, 300, 300, 200, 100, "back");
    back.addEventHandler(this, "back_btn");
  }
  
  
  
}

public void handleButtonEvents(GButton button, GEvent event) {
  
  if (layer > 0)
    return;
  
  if (button == nextButton && event == GEvent.CLICKED) {
    if (currentPages[0] < totalPages[0] - 1) {
      currentPages[0]++;
      createButtons();
    }
  }
  else if (button == prevButton && event == GEvent.CLICKED) {
    if (currentPages[0] > 0) {
      currentPages[0]--;
      createButtons();
    }
  }
}


public void handleRecipesButton(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    println(button.getText());
    layer++;
    createButtons();
  }
}

public void back_btn(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    back.dispose();
    txt.dispose();
    layer--;
    
    createButtons();
  }
}
