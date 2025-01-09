import g4p_controls.*;

ArrayList<Recipe> recipes = new ArrayList<Recipe>();
int[] currentPages = {0, 0, 0}; 
int buttonsPerPage = 9;
int[] totalPages = {0, 0, 0};
ArrayList<GButton> buttons = new ArrayList<>();
int layer = 0;
GButton prevButton, nextButton;
GLabel txt;
GButton back;
float buttonWidth = 300;
float buttonHeight = 50;
float buttonSpacing = 10;
float buttonStartX = 350;
float buttonStartY = 50;
Recipe currentR;

void setup() {
  size(1000, 700);
  
  for (int i = 1; i <= 50; i++) {
    Recipe r = new Recipe("Recipe " + i);
    recipes.add(r);
    buttons.add(r.button);
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
  for (Recipe r : recipes) {
    if (r.button != null) {
      r.button.dispose();
    }
  }
  
  if (currentR != null)
  {
    for (Ingredient i : currentR.ingredients)
    {
      if (i.button != null)
      {
         i.button.dispose();
      }
    }
  }

  
  if (layer == 0)
  {
    
    for (Recipe r : recipes) {
      if (r.button != null) {
        r.button.dispose();
      }
    }
    
    int startIndex = currentPages[0] * buttonsPerPage;
    int endIndex = min(startIndex + buttonsPerPage, recipes.size());
    
    
    for (int i = startIndex; i < endIndex; i++) 
    {
      Recipe r = recipes.get(i);
      int buttonIndex = i - startIndex;
      float x = buttonStartX;
      float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
      r.button = new GButton(this, x, y, buttonWidth, buttonHeight, r.name);
      r.button.addEventHandler(this, "handleRecipesButton");
    }
  }
  else if (layer == 1)
  {
    
    
    int startIndex = currentPages[1] * buttonsPerPage;
    int endIndex = min(startIndex + buttonsPerPage, currentR.ingredients.size());
    
    for (int i = startIndex; i < endIndex; i++) 
    {
      Ingredient ing = currentR.ingredients.get(i);
      int buttonIndex = i - startIndex;
      float x = buttonStartX;
      float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
      ing.button = new GButton(this, x, y, buttonWidth, buttonHeight, ing.name);
      ing.button.setEnabled(false);
    }
    
    txt = new GLabel(this, 300, 300, 200, 100, "Hahahaha");
    txt.setVisible(false);
    
    back = new GButton(this, 100, 100, 70, 50, "back");
    back.addEventHandler(this, "back_btn");
  }
  
  
  
}

public void handleButtonEvents(GButton button, GEvent event) {
  
  if (button == nextButton && event == GEvent.CLICKED) {
    if (currentPages[layer] < totalPages[layer] - 1) {
      currentPages[layer]++;
      createButtons();
    }
  }
  else if (button == prevButton && event == GEvent.CLICKED) {
    if (currentPages[layer] > 0) {
      currentPages[layer]--;
      createButtons();
    }
  }
}


public void handleRecipesButton(GButton button, GEvent event) {
  if (event == GEvent.CLICKED) {
    for (int i = 0; i < recipes.size(); i++) {
      Recipe r = recipes.get(i);
      if (r.button == button) {
        println(button.getText());
        int index = i;
        println(index);
        currentR = r;
        layer = 1;
        totalPages[layer] = (int) ceil((float) r.ingredients.size() / buttonsPerPage);
        createButtons();
        break;
      }
    }
  }
}

public void back_btn(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    back.dispose();
    txt.dispose();
    currentPages[layer] = 0;
    totalPages[layer] = 0;
    layer--;
    
    createButtons();
  }
}
