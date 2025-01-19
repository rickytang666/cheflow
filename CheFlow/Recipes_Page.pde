
/** RECIPES_PAGE CLASS **/

class Recipes_Page extends Page
{
  /* SPECIFIC FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();

  GButton prev_button, next_button, back, search_button, add_button;
  GTextField search_bar;
  GOption search_toggle;

  GLabel title, entries_status, page_indicator;

  Boolean searching = false;
  

  /* CONSTRUCTOR */

  Recipes_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENT ABSTRACT METHODS */

  void setup()
  {

    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }
    
    total_page_nums[0] = (int) ceil((float) recipes.size() / buttons_per_page);

    set_nav_gui(); 
    set_recipes_page();
    
  }

  
  void die()
  {
    searching = false;

    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
      }
    }

    static_controls.clear();

    clear_variable_controls();
  }

  /* ADDITIONAL METHODS */

  void set_nav_gui()
  {

    title = new GLabel(parent, width/2 - 150, 70, 300, 40, "RECIPE PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setTextBold();
    title.setTextItalic();
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    float navButtonWidth = 100;
    float navButtonHeight = 40;
    float navButtonY = height - 50;
    
    prev_button = new GButton(parent, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
    prev_button.addEventHandler(parent, "handleButtonEvents");

    next_button = new GButton(parent, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
    next_button.addEventHandler(parent, "handleButtonEvents");
    
    back = new GButton(parent, 100, 200, 70, 50, "back");
    back.addEventHandler(parent, "handleButtonEvents");

    add_button = new GButton(parent, 800, 200, 70, 50, "+Item");
    add_button.addEventHandler(parent, "add_button_handler");

    search_bar = new GTextField(parent, width/2 - 100, 130, 200, 40, G4P.SCROLLBARS_HORIZONTAL_ONLY);
    
    search_button = new GButton(parent, width/2 + 110, 130, 60, 40, "Search");
    search_button.addEventHandler(parent, "search_button_handler");

    search_toggle = new GOption(parent, width - 200, 60, 100, 40);
    search_toggle.addEventHandler(parent, "search_mode_handler");
    search_toggle.setText("Search Mode");

    entries_status = new GLabel(parent, width - 200, 100, 100, 40);

    page_indicator = new GLabel(parent, width - 150, navButtonY, 100, navButtonHeight);

    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(back);
    static_controls.add(search_bar);
    static_controls.add(search_button);
    static_controls.add(search_toggle);
    static_controls.add(add_button);
    static_controls.add(entries_status);
    static_controls.add(page_indicator);
  }


  void update_nav_gui()
  {
    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    
    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);
    add_button.setEnabled(layer < 2 && (layer == 0 && !searching) || (layer == 1));
    add_button.setVisible(layer < 2 && (layer == 0 && !searching) || (layer == 1));
    search_toggle.setEnabled(layer == 0);
    search_bar.setEnabled(layer == 0 && searching);
    search_bar.setVisible(layer == 0 && searching);
    search_bar.setFocus(layer == 0 && searching);
    search_button.setEnabled(layer == 0 && searching);
    search_button.setVisible(layer == 0 && searching);

    entries_status.setVisible(layer < 2);
  }


  void clear_variable_controls()
  {
    for (Recipe r : recipes) 
    {
      r.dispose_controls();
    }
    
    if (current_r != null)
    {
      for (IngredientStatus i : current_r.ingredients)
      {
        i.dispose_controls();
      }
    }

    if (current_ing != null)
    {
      current_ing.dispose_controls();
    }
  }


  void set_recipes_page() 
  {

    clear_variable_controls();

    update_nav_gui();

        
    if (layer == 0)
    {
      
      ArrayList<Recipe> to_display = searching ? search_results : recipes;

      total_page_nums[0] = max(1, (int) ceil((float) to_display.size() / buttons_per_page));

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      entries_status.setText("Entries: " + to_display.size());

      int start = page_nums[0] * buttons_per_page;
      int end = min(start + buttons_per_page, to_display.size());
      
      for (int i = start; i < end; i++) 
      {
        Recipe r = to_display.get(i);
        int buttonIndex = i - start;
        float x = button_startX;
        float y = button_startY + buttonIndex * (button_height + button_spacing);

        r.button = new GButton(parent, x, y, button_width, button_height, r.name);
        r.button.addEventHandler(parent, "recipe_button_handler");

        
        r.del_button = new GButton(parent, x + button_width + 10, y, 50, button_height, "Delete");
        r.del_button.addEventHandler(parent, "recipe_del_button_handler");
      }
    }
    else if (layer == 1)
    {
      entries_status.setText("Ingredients: " + current_r.ingredients.size());

      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);

      int start = page_nums[1] * buttons_per_page;
      int end = min(start + buttons_per_page, current_r.ingredients.size());
      
      current_r.renamer = new GTextField(parent, width/2 - 100, 120, 200, 40, G4P.SCROLLBARS_HORIZONTAL_ONLY);
      current_r.renamer.setText(current_r.name);
      current_r.renamer.addEventHandler(parent, "recipe_renamer_handler");  

      current_r.duration_editor = new GTextField(parent, width/2 - 50, 170, 100, 20);
      current_r.duration_editor.setText(str(current_r.duration));
      current_r.duration_editor.addEventHandler(parent, "recipe_duration_handler");
      current_r.duration_editor.setNumeric(1, 60 * 24, 30);
      
      for (int i = start; i < end; i++) 
      {
        IngredientStatus ing_status = current_r.ingredients.get(i);
        Ingredient ing = ing_status.ingredient;
        int buttonIndex = i - start;
        float x = button_startX;
        float y = button_startY + buttonIndex * (button_height + button_spacing);

        ing.button = new GButton(parent, x, y, button_width, button_height, ing.name);
        ing.button.addEventHandler(parent, "ingredient_button_handler"); // Add event handler
        ing.button.setEnabled(true); // Enable the button

        ing.del_button = new GButton(parent, x + button_width + 10, y, 50, button_height, "Delete");
        ing.del_button.addEventHandler(parent, "ingredient_del_button_handler");

        ing_status.essential_toggle = new GOption(parent, x + button_width + 70, y, 40, 40, "Essen.");
        ing_status.essential_toggle.setSelected(ing_status.is_essential);
        ing_status.essential_toggle.addEventHandler(parent, "ingredient_essential_handler");
      }
      
    }
    else if (layer == 2)
    {
      String content = "This ingredient is used in " + current_ing.related_recipes.size() + " recipes\n";

      page_indicator.setText("Page " + (page_nums[2] + 1) + " of " + total_page_nums[2]);   
      
      current_ing.renamer = new GTextField(parent, width/2 - 100, 120, 200, 30, G4P.SCROLLBARS_HORIZONTAL_ONLY);
      current_ing.renamer.setText(current_ing.name);
      current_ing.renamer.addEventHandler(parent, "ingredient_renamer_handler");

      current_ing.label = new GLabel(parent, width/2 - 200, 180, 400, 20, content);
      current_ing.label.setTextAlign(GAlign.CENTER, GAlign.TOP);

      int start = page_nums[2] * buttons_per_page;
      int end = min(start + buttons_per_page, current_ing.related_recipes.size());

      for (int i = start; i < end; i++)
      {
        String recipe_name = current_ing.related_recipes.get(i);
        int index = i - start;
        float x = button_startX;
        float y = button_startY + index * (button_height + button_spacing);

        // just a GLabel

        GLabel label = new GLabel(parent, x, y, button_width, button_height, recipe_name);
        label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        label.setOpaque(true);
        current_ing.recipe_labels.add(label);
      }
    }
    
  }
  
}


/* EVENT HANDLERS */

public void handleButtonEvents(GButton button, GEvent event) 
{

  if (event == GEvent.CLICKED)
  {
    if (button == rp.next_button) 
    {
      page_nums[layer]++;
      rp.set_recipes_page();
    }
    else if (button == rp.prev_button) 
    {
      page_nums[layer]--;
      rp.set_recipes_page();
    }
    else if (button == rp.back)
    {
      page_nums[layer] = 0;
      total_page_nums[layer] = 0;
      layer--;
      
      rp.set_recipes_page();
    }
    else if (button == fp.prev_button)
    {
      
      page_nums[layer]--;
      fp.set_fridge_page();
      
    }
    else if (button == fp.next_button)
    {
      
      page_nums[layer]++;
      fp.set_fridge_page();
      
    }
    else if (button == fp.back)
    {
      page_nums[layer] = 0;
      total_page_nums[layer] = 0;
      layer--;
      fp.set_fridge_page();
    }
    else if (button == mp.prev_button)
    {
      page_nums[layer]--;
      mp.set_matching_page();
    }
    else if (button == mp.next_button)
    {
      page_nums[layer]++;
      mp.set_matching_page();
    }
    else if (button == ap.prev_button)
    {
      page_nums[layer]--;
      ap.set_activity_page();
    }
    else if (button == ap.next_button)
    {
      page_nums[layer]++;
      ap.set_activity_page();
    }
    else if (button == ap.back)
    {
      page_nums[layer] = 0;
      total_page_nums[layer] = 0;
      layer--;
      ap.set_activity_page(); 
    }
  }
  
  
}


public void search_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (button == rp.search_button)
    {
      fill_search_results(rp.search_bar.getText());
      page_nums[0] = 0;
      total_page_nums[0] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
      page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
      rp.set_recipes_page();
    }
    else if (button == ap.search_button)
    {
      fill_search_results(ap.search_bar.getText());
      page_nums[0] = 0;
      total_page_nums[0] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
      page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
      ap.set_activity_page();
    }

  }
}


public void search_mode_handler(GOption option, GEvent event)
{
  if (event == GEvent.SELECTED)
  {
    // println("Search mode enabled");
    rp.searching = true;
    rp.search_bar.setText("");
    search_results.clear();
    search_results.addAll(recipes);
    rp.set_recipes_page();
  }
  else if (event == GEvent.DESELECTED)
  {
    // println("Search mode disabled");
    rp.searching = false;
    total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page));
    rp.set_recipes_page();
  }
}


public void add_button_handler(GButton button, GEvent event) 
{
  if (event == GEvent.CLICKED) 
  {
    if (layer == 0)
    {
      String name = "Recipe " + recipe_id;
      Recipe r = new Recipe(name);
      recipes.add(0, r);
      total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page));
      page_nums[0] = 0;
      rp.set_recipes_page();
    }
    else if (layer == 1)
    {
      String name = "Ingredient " + ingredient_id;
      ++ingredient_id;
      Ingredient ing = new Ingredient(name);
      current_r.add_ingredient(ing);
      total_page_nums[1] = (int) ceil((float) current_r.ingredients.size() / buttons_per_page);
      page_nums[1] = 0;
      rp.set_recipes_page();
    }

    if (auto_save)
    {
      export_data();
    }
    
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
        current_r = r;
        layer = 1;
        total_page_nums[layer] = (int) ceil((float) r.ingredients.size() / buttons_per_page);
        rp.set_recipes_page();
        break;
      }
    }
  }
}


public void recipe_del_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < recipes.size(); i++)
    {
      Recipe r = recipes.get(i);
      if (r.del_button == button)
      {
        r.delete();

        if (rp.searching)
        {
          search_results.remove(r);
          total_page_nums[0] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
        }
        else
        {
          total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page));
        }

        page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
        rp.set_recipes_page();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }
  }
}


public void recipe_renamer_handler(GTextField textControl, GEvent event)
{
  if (event == GEvent.CHANGED && current_r != null)
  {
    if (!is_recipe_repeated(textControl.getText(), recipes))
    {
      current_r.name = textControl.getText();

      if (auto_save)
      {
        export_data();
      }
    }
  }
}


public void recipe_duration_handler(GTextField textControl, GEvent event)
{
  if (event == GEvent.CHANGED && current_r != null)
  {
    try
    {
      int duration = constrain(Integer.parseInt(textControl.getText()), 1, 60 * 24);
      current_r.duration = duration;
    }
    catch (NumberFormatException e)
    {
      println("Invalid duration");
      current_r.duration = 30;
    }

    if (auto_save)
    {
      export_data();
    }

  }
}


public void ingredient_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < current_r.ingredients.size(); i++)
    {
      Ingredient ing = current_r.ingredients.get(i).ingredient;
      if (ing.name.equals(button.getText()))
      {
        current_ing = ing;
        layer = 2;
        ing.set_contents();
        page_nums[2] = 0;
        total_page_nums[2] = (int) ceil((float) ing.related_recipes.size() / buttons_per_page);
        rp.set_recipes_page();
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
      IngredientStatus ing_status = current_r.ingredients.get(i);
      if (ing_status.ingredient.del_button == button)
      {
        current_r.delete_ingredient(i);
        total_page_nums[1] = max(1, (int) ceil((float) current_r.ingredients.size() / buttons_per_page));
        page_nums[1] = constrain(page_nums[1], 0, total_page_nums[1] - 1);
        rp.set_recipes_page();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }

  }
}


public void ingredient_essential_handler(GOption option, GEvent event)
{
  if (event == GEvent.SELECTED || event == GEvent.DESELECTED)
  {
    for (int i = 0; i < current_r.ingredients.size(); i++)
    {
      IngredientStatus ing_status = current_r.ingredients.get(i);
      if (ing_status.essential_toggle == option)
      {
        ing_status.is_essential = option.isSelected();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }
  }
}


public void ingredient_renamer_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && current_ing != null)
  {
    if (!is_ingredient_repeated(source.getText(), 1))
    {
      current_ing.set_name(source.getText());
      current_ing.set_contents();
    }
    
  }
}


public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) { /* code */ }
