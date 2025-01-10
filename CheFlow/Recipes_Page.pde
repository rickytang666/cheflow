
/* GLOBAL VARIABLES OR CONSTANTS */

/* FUNCTIONS */

void set_recipes_page() 
{

  // Dispose everything in the screen

  for (Recipe r : recipes) 
  {
    if (r.button != null) 
    {
      r.button.dispose();
    }
    
    if (r.del_button != null)
    {
      r.del_button.dispose();
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

      if (i.del_button != null)
      {
        i.del_button.dispose();
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


  update_nav_gui();

  
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
      r.del_button = new GButton(this, x + buttonWidth + 10, y, 50, buttonHeight, "Delete");
      r.del_button.addEventHandler(this, "recipe_del_button_handler");
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

/* HANDLERS */

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


void recipe_del_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < recipes.size(); i++)
    {
      Recipe r = recipes.get(i);
      if (r.del_button == button)
      {
        println("Deleting " + r.name);
        r.delete();
        totalPages[0] = (int) ceil((float) recipes.size() / buttonsPerPage);
        currentPages[0] = constrain(currentPages[0], 0, totalPages[0] - 1);
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