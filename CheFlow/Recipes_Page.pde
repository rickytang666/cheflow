
/* GLOBAL VARIABLES OR CONSTANTS */

/* FUNCTIONS */

void set_recipes_page() 
{

  // Dispose everything in the screen

  for (Recipe r : recipes) 
  {
    r.dispose_controls();
  }
  
  if (current_r != null)
  {

    for (Ingredient i : current_r.ingredients)
    {
      i.dispose_controls();
    }
  }

  if (current_ing != null)
  {
    current_ing.dispose_controls();
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
    int endIndex = min(startIndex + buttonsPerPage, current_r.ingredients.size());
    
    current_r.renamer = new GTextField(this, 350, 20, 200, 50, G4P.SCROLLBARS_HORIZONTAL_ONLY);
    current_r.renamer.setText(current_r.name);
    current_r.renamer.addEventHandler(this, "recipe_renamer_handler");  
    
    for (int i = startIndex; i < endIndex; i++) 
    {
      Ingredient ing = current_r.ingredients.get(i);
      int buttonIndex = i - startIndex;
      float x = buttonStartX;
      float y = buttonStartY + buttonIndex * (buttonHeight + buttonSpacing);

      ing.button = new GButton(this, x, y, buttonWidth, buttonHeight, ing.name);
      ing.button.addEventHandler(this, "ingredient_button_handler"); // Add event handler
      ing.button.setEnabled(true); // Enable the button

      ing.del_button = new GButton(this, x + buttonWidth + 10, y, 50, buttonHeight, "Delete");
      ing.del_button.addEventHandler(this, "ingredient_del_button_handler");
    }
    
  }
  else if (layer == 2)
  {
    current_ing.label = new GLabel(this, 350, 100, 400, 500, current_ing.content);
    current_ing.renamer = new GTextField(this, 350, 20, 200, 50, G4P.SCROLLBARS_HORIZONTAL_ONLY);
    current_ing.renamer.setText(current_ing.name);
    current_ing.renamer.addEventHandler(this, "ingredient_renamer_handler");  
    
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
        // println(button.getText());
        current_r = r;
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


public void recipe_renamer_handler(GTextField textControl, GEvent event)
{
  if (event == GEvent.CHANGED && current_r != null)
  {
    if (!name_is_repeated(textControl.getText(), 0))
    {
      current_r.name = textControl.getText();
    }
  }
}


public void ingredient_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < current_r.ingredients.size(); i++)
    {
      Ingredient ing = current_r.ingredients.get(i);
      if (ing.name.equals(button.getText()))
      {
        current_ing = ing;
        layer = 2;
        ing.set_contents();
        set_recipes_page();
        break;
      }
    }
  }
}


public void ingredient_del_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < current_r.ingredients.size(); i++)
    {
      Ingredient ing = current_r.ingredients.get(i);
      if (ing.del_button == button)
      {
        println("Deleting " + ing.name);
        current_r.delete_ingredient(i);
        totalPages[1] = (int) ceil((float) current_r.ingredients.size() / buttonsPerPage);
        currentPages[1] = constrain(currentPages[1], 0, totalPages[1] - 1);
        set_recipes_page();
        break;
      }
    }
  }
}


public void ingredient_renamer_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && current_ing != null)
  {

    if (!name_is_repeated(source.getText(), 1, current_r))
    {
      current_ing.set_name(source.getText());
      current_ing.set_contents();
    }
    
  }
}


public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) { /* code */ }
