import g4p_controls.*;

int recipeID = 1;
int ingredientID = 1;
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
float buttonHeight = 40;
float buttonSpacing = 10;
float buttonStartX = 350;
float buttonStartY = 100;
Recipe currentR;
Ingredient currentIngredient;

void setup() 
{
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
  
  back = new GButton(this, 100, 100, 70, 50, "back");
  back.addEventHandler(this, "handleButtonEvents");
  
  set_recipes_page();
}

void draw()
{
  background(220);
}

void set_recipes_page() 
{
  for (Recipe r : recipes) 
  {
    if (r.button != null) 
    {
      r.button.dispose();
    }
  }
  
  if (currentR != null)
  {
    if (currentR.renamer != null)
    {
      currentR.renamer.dispose();
    }
    
    for (Ingredient i : currentR.ingredients)
    {
      if (i.button != null)
      {
         i.button.dispose();
      }
    }
  }

  if (currentIngredient != null)
  {
    if (currentIngredient.renamer != null)
    {
      currentIngredient.renamer.dispose();
    }
    
    if (currentIngredient.label != null)
    {
      currentIngredient.label.dispose();
    }
  }


  back.setEnabled(layer > 0);
  prevButton.setEnabled(layer < 2 && currentPages[layer] > 0);
  nextButton.setEnabled(layer < 2 && currentPages[layer] < totalPages[layer] - 1);

  
  if (layer == 0)
  {
    
    int startIndex = currentPages[0] * buttonsPerPage;
    int endIndex = min(startIndex + buttonsPerPage, recipes.size());
    
    
    for (int i = startIndex; i < endIndex; i++) 
    {
      Recipe r = recipes.get(i);
      int buttonIndex = i - startIndex;
      float x = buttonStartX;
      float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
      r.button = new GButton(this, x, y, buttonWidth, buttonHeight, r.name);
      r.button.addEventHandler(this, "recipe_button_handler");
    }
  }
  else if (layer == 1)
  {
        
    int startIndex = currentPages[1] * buttonsPerPage;
    int endIndex = min(startIndex + buttonsPerPage, currentR.ingredients.size());
    
    currentR.renamer = new GTextField(this, 350, 20, 200, 50, G4P.SCROLLBARS_HORIZONTAL_ONLY);
    currentR.renamer.setText(currentR.name);
    currentR.renamer.addEventHandler(this, "recipe_renamer_handler");  
    
    for (int i = startIndex; i < endIndex; i++) 
    {
      Ingredient ing = currentR.ingredients.get(i);
      int buttonIndex = i - startIndex;
      float x = buttonStartX;
      float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);
      ing.button = new GButton(this, x, y, buttonWidth, buttonHeight, ing.name);
      ing.button.addEventHandler(this, "ingredient_button_handler"); // Add event handler
      ing.button.setEnabled(true); // Enable the button
    }
    
  }
  else if (layer == 2)
  {
    currentIngredient.label = new GLabel(this, 200, 100, 800, 500, currentIngredient.content);
    currentIngredient.renamer = new GTextField(this, 350, 20, 200, 50, G4P.SCROLLBARS_HORIZONTAL_ONLY);
    currentIngredient.renamer.setText(currentIngredient.name);
    currentIngredient.renamer.addEventHandler(this, "ingredient_renamer_handler");  
    
  }
  
  
}

public void handleButtonEvents(GButton button, GEvent event) 
{
  
  if (button == nextButton && event == GEvent.CLICKED) 
  {
    if (currentPages[layer] < totalPages[layer] - 1) 
    {
      currentPages[layer]++;
      set_recipes_page();
    }
  }
  else if (button == prevButton && event == GEvent.CLICKED) 
  {
    if (currentPages[layer] > 0) 
    {
      currentPages[layer]--;
      set_recipes_page();
    }
  }
  else if (button == back && event == GEvent.CLICKED)
  {
    currentPages[layer] = 0;
    totalPages[layer] = 0;
    layer--;
    
    set_recipes_page();
  }
}


public void recipe_button_handler(GButton button, GEvent event) 
{
  if (event == GEvent.CLICKED) 
  {
    for (int i = 0; i < recipes.size(); i++) 
    {
      Recipe r = recipes.get(i);
      if (r.name.equals(button.getText())) 
      {
        println(button.getText());
        currentR = r;
        layer = 1;
        totalPages[layer] = (int) ceil((float) r.ingredients.size() / buttonsPerPage);
        set_recipes_page();
        break;
      }
    }
  }
}


public void recipe_renamer_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && currentR != null)
  {
    currentR.name = source.getText();
  }
}


public void ingredient_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < currentR.ingredients.size(); i++)
    {
      Ingredient ing = currentR.ingredients.get(i);
      if (ing.name.equals(button.getText()))
      {
        currentIngredient = ing;
        layer = 2;
        set_recipes_page();
        break;
      }
    }
  }
}


public void ingredient_renamer_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && currentIngredient != null)
  {
    currentIngredient.name = source.getText();
  }
}
