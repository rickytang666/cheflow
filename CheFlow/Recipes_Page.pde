
/** RECIPES_PAGE CLASS **/

class Recipes_Page extends Page // Derived from Page class, unfortunately the most sophisticated one :(
{
  /* SPECIFIC FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();

  GImageButton back, add_button, search_button;
  GTextField search_bar;
  GImageToggleButton search_toggle;

  GLabel title, search_toggle_hint, entries_status, page_indicator;

  Boolean searching = false; // variable to control the search mode, if not searching then user cannot add new recipes (to maintain the proper order)
  

  /* CONSTRUCTOR */

  Recipes_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENT ABSTRACT METHODS */

  void setup()
  {
    // reset all the navigation variables, and set the static GUI & the whole page

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
    searching = false; // reset the search mode

    // dispose all the controls, including the ones in each object (recipes, ingredients)

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
    // title label of the page (big and bold)

    title = new GLabel(parent, 10, 70, 200, 40, "RECIPE PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    // this page needs to use page navigation buttons, so we need to set them up

    float navButtonY = height - 50;

    prev_button.setEnabled(true);
    prev_button.setVisible(true);
    next_button.setEnabled(true);
    next_button.setVisible(true);

    // set up back button, add button (image button needs file directories in string array)
           
    back = new GImageButton(parent, 20, 150, 60, 60, new String[] {"back button 1.png", "back button 2.png"});
    back.addEventHandler(parent, "back_button_handler");

    add_button = new GImageButton(parent, 20, 300, 60, 60, new String[] {"add 1.png", "add 2.png"});
    add_button.addEventHandler(parent, "add_button_handler");

    // set up the searching bundles

    search_bar = new GTextField(parent, width/2 - 100, 130, 200, 40);
    search_bar.setOpaque(true);
    search_bar.setFont(UI_font2);
    
    search_button = new GImageButton(parent, width/2 + 110, 130, 40, 40, new String[] {"search 1.png", "search 2.png"});
    search_button.addEventHandler(parent, "search_button_handler");

    search_toggle = new GImageToggleButton(parent, width - 80, 100, "toggle.png", 1, 2);
    search_toggle.setState(searching ? 1 : 0); // assign the state based on the searching variable
    search_toggle.addEventHandler(parent, "search_mode_handler");

    search_toggle_hint = new GLabel(parent, width - 200, 100, 120, 40, "Search mode");
    search_toggle_hint.setLocalColor(2, text_col);
    search_toggle_hint.setTextBold();
    search_toggle_hint.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);

    // set up the entries status and page indicator labels

    entries_status = new GLabel(parent, width - 200, 140, 180, 40);
    entries_status.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    entries_status.setOpaque(true);

    page_indicator = new GLabel(parent, width - 150, navButtonY, 150, button_height);
    page_indicator.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    page_indicator.setOpaque(true);

    // put all the static controls in the list, for easy batch disposal

    static_controls.add(title);
    static_controls.add(back);
    static_controls.add(search_bar);
    static_controls.add(search_button);
    static_controls.add(search_toggle);
    static_controls.add(search_toggle_hint);
    static_controls.add(add_button);
    static_controls.add(entries_status);
    static_controls.add(page_indicator);
  }


  void update_nav_gui()
  {
    // update all the navigation GUI elements based on the current layer and other variables

    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    
    // first layer doesn't need to go back

    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);

    // add button is only enabled in the first layer and when not searching, and not the innermost layer
    add_button.setEnabled(layer < 2 && (layer == 0 && !searching) || (layer == 1));
    add_button.setVisible(layer < 2 && (layer == 0 && !searching) || (layer == 1));
    search_toggle.setEnabled(layer == 0); // the toggle is only enabled in the recipes layer
    search_bar.setEnabled(layer == 0 && searching);
    search_bar.setVisible(layer == 0 && searching);
    search_bar.setFocus(layer == 0 && searching);
    search_button.setEnabled(layer == 0 && searching);
    search_button.setVisible(layer == 0 && searching);

    // the innermost layer doesn't need the entries status (we already have another label for that)
    entries_status.setVisible(layer < 2);
  }


  void clear_variable_controls()
  {
    // clear all the recipes and ingredients controls (including current ones)

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
        
    if (layer == 0) // recipes layer
    {
      // decide which list to display based on the search mode

      ArrayList<Recipe> to_display = searching ? search_results : recipes;

      // after decision, set the total page number based on the list size

      total_page_nums[0] = max(1, (int) ceil((float) to_display.size() / buttons_per_page));

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      entries_status.setText("Entries: " + to_display.size());

      // set the start and end index based on the current page number

      int start = page_nums[0] * buttons_per_page;
      int end = min(start + buttons_per_page, to_display.size());

      // display the buttons based on the start and end index

      for (int i = start; i < end; i++) 
      {

        // calculate the positions, truncate the text (if needed), and set the buttons

        Recipe r = to_display.get(i);
        int buttonIndex = i - start;
        float x = button_startX;
        float y = button_startY + buttonIndex * (button_height + button_spacing);

        String name = truncate_text(r.name, button_width);
        r.button = new GButton(parent, x, y, button_width, button_height, name);
        r.button.setFont(UI_font1);
        r.button.setLocalColor(3, accent_col2);
        r.button.setLocalColor(4, accent_col2);
        r.button.setLocalColor(6, #274097); // dark blue
        r.button.setLocalColor(14, #098d8d); // dark cyan
        r.button.setLocalColor(2, #ffffff); // white
        r.button.addEventHandler(parent, "recipe_button_handler");

        // delete button is image button, similar as before, we provide the file directories in string array
        
        r.del_button = new GImageButton(parent, x + button_width + 10, y, button_height, button_height, new String[] {"delete1.png", "delete2.png"});
        r.del_button.addEventHandler(parent, "recipe_del_button_handler");
      }
    }
    else if (layer == 1) // ingredients layer (or recipe's details layer)
    {
      entries_status.setText("Ingredients: " + current_r.ingredients.size());

      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);

      int start = page_nums[1] * buttons_per_page;
      int end = min(start + buttons_per_page, current_r.ingredients.size());

      // set up the renamer, and duration editor for the recipe
      
      current_r.renamer = new GTextField(parent, width/2 - 100, 100, 200, 40);
      current_r.renamer.setText(current_r.name);
      current_r.renamer.setFont(UI_font2);
      current_r.renamer.addEventHandler(parent, "recipe_renamer_handler");  

      current_r.duration_hint = new GLabel(parent, width/2 - 100, 150, 200, 30, "Duration (minutes)");
      current_r.duration_hint.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
      current_r.duration_hint.setLocalColor(2, text_col);

      current_r.duration_editor = new GTextField(parent, width/2 - 50, 190, 100, 30);
      current_r.duration_editor.setText(str(current_r.duration));
      current_r.duration_editor.setFont(UI_font2);
      current_r.duration_editor.addEventHandler(parent, "recipe_duration_handler");
      current_r.duration_editor.setNumeric(1, 60 * 24, 30); // (min, max, default), max is 24 hours
      
      for (int i = start; i < end; i++) 
      {
        // set up the ingredient buttons, delete buttons, and essential toggles (use IngredientStatus class)

        IngredientStatus ing_status = current_r.ingredients.get(i);
        Ingredient ing = ing_status.ingredient;
        int buttonIndex = i - start;
        float x = button_startX;
        float y = button_startY + buttonIndex * (button_height + button_spacing);

        String name = truncate_text(ing.name, button_width);
        ing.button = new GButton(parent, x, y, button_width, button_height, name);
        ing.button.setLocalColor(4, accent_col3);
        ing.button.setLocalColor(3, accent_col3);
        ing.button.setLocalColor(6, #edde32); // yellow
        ing.button.setLocalColor(14, #30c5c5); // cyan
        ing.button.addEventHandler(parent, "ingredient_button_handler");

        ing.del_button = new GImageButton(parent, x + button_width + 10, y, button_height, button_height, new String[] {"delete1.png", "delete2.png"});
        ing.del_button.addEventHandler(parent, "ingredient_del_button_handler");

        // essential toggle is GOption, we set the local color and style based on the essential status
        // if the user turns it on, the ingredient is essential which will affect the recommendations score calculations (matching page)

        ing_status.essential_toggle = new GOption(parent, x + button_width + 70, y, 100, 40, "Essential");
        ing_status.essential_toggle.setLocalColor(2, text_col);
        ing_status.essential_toggle.setSelected(ing_status.is_essential);
        ing_status.essential_toggle.setOpaque(ing_status.is_essential);
        ing_status.essential_toggle.setLocalColor(2, ing_status.is_essential ? #000000 : text_col);
        ing_status.essential_toggle.addEventHandler(parent, "ingredient_essential_handler");
      }
      
    }
    else if (layer == 2) // ingredient details layer
    {
      String content = "This ingredient is used in " + current_ing.related_recipes.size() + " recipes\n";

      page_indicator.setText("Page " + (page_nums[2] + 1) + " of " + total_page_nums[2]);  

      // Display the renamer and content label 
      
      current_ing.renamer = new GTextField(parent, width/2 - 100, 120, 200, 40);
      current_ing.renamer.setFont(UI_font2);
      current_ing.renamer.setText(current_ing.name);
      current_ing.renamer.addEventHandler(parent, "ingredient_renamer_handler");

      current_ing.label = new GLabel(parent, width/2 - 200, 180, 400, 40, content);
      current_ing.label.setLocalColor(2, text_col);
      current_ing.label.setTextAlign(GAlign.CENTER, GAlign.TOP);

      int start = page_nums[2] * buttons_per_page;
      int end = min(start + buttons_per_page, current_ing.related_recipes.size());

      // Use a loop to display the related recipe labels, truncate the text if needed

      for (int i = start; i < end; i++)
      {
        // calculate the positions, truncate the text, and set the labels

        String recipe_name = current_ing.related_recipes.get(i);
        recipe_name = truncate_text(recipe_name, button_width);
        int index = i - start;
        float x = button_startX;
        float y = button_startY + index * (button_height + button_spacing);

        GLabel label = new GLabel(parent, x, y, button_width, button_height, recipe_name);
        label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        label.setOpaque(true);
        current_ing.recipe_labels.add(label);
      }
    }

    // Sometimes the search bar is inactive for no reason, so always set it to focus

    search_bar.setFocus(true);
    
  }
  
}


/* EVENT HANDLERS */


public void search_mode_handler(GImageToggleButton button, GEvent event)
{
  if (button.getState() == 1) // if turned on, we can populate the search results with all the recipes already, and reset the recipes page
  {
    // println("Search mode enabled");
    rp.searching = true;
    rp.search_bar.setText("");
    search_results.clear();
    search_results.addAll(recipes);
    rp.set_recipes_page();
  }
  else if (button.getState() == 0) // if turned off, we need to reset the search results and the recipes page, and use recipes list rather than search results
  {
    // println("Search mode disabled");
    rp.searching = false;
    total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page));
    rp.set_recipes_page();
  }
}


public void add_button_handler(GImageButton button, GEvent event) 
{
  if (event == GEvent.CLICKED) 
  {
    if (layer == 0) // add a recipe
    {
      String name = "Recipe " + recipe_id;
      Recipe r = new Recipe(name);
      recipes.add(0, r); // push front
      total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page)); // update the total page number
      page_nums[0] = 0; // since we push front, we need to jump to page 1
      rp.set_recipes_page(); // reset the recipes page
    }
    else if (layer == 1) // add an ingredient
    {
      String name = "Ingredient " + ingredient_id;
      ++ingredient_id;
      Ingredient ing = new Ingredient(name);
      current_r.add_ingredient(ing); // add the ingredient into the current recipe object
      total_page_nums[1] = (int) ceil((float) current_r.ingredients.size() / buttons_per_page); // update the total page number
      page_nums[1] = 0; // jump to first page
      rp.set_recipes_page(); // reset the recipes page
    }

    // save the changed data if auto save is on

    if (auto_save)
    {
      export_data();
    }
    
  }
}


public void recipe_button_handler(GButton button, GEvent event) 
{
  // zoom into the detailed layer, set the current recipe object, and reset the page
  // remember to set the total page number based on the current ingredients size

  if (event == GEvent.CLICKED) 
  {
    
    for (int i = 0; i < recipes.size(); i++) 
    {
      Recipe r = recipes.get(i);
      if (r.button == button) 
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


public void recipe_del_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < recipes.size(); i++)
    {
      Recipe r = recipes.get(i);
      if (r.del_button == button)
      {
        // find the correct recipe

        r.delete();

        if (rp.searching)
        {
          // if it is searching, we need to update the search results as well, since the page is displayed based on the search results
          search_results.remove(r);
          total_page_nums[0] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
        }
        else
        {
          total_page_nums[0] = max(1, (int) ceil((float) recipes.size() / buttons_per_page));
        }

        // if 1 page is lost, we need to handle this case by constraining

        page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
        rp.set_recipes_page();
        break;
      }
    }

    // save the changed data if auto save is on

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

    // make sure the new name is not repeated, save the data if auto save is on

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

    // make sure current recipe is effective, and the duration is valid, save the data if auto save is on
    
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
    // zoom into the detailed layer, set the current ingredient object, and reset the page (update the navigation data)

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


public void ingredient_del_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (int i = 0; i < current_r.ingredients.size(); i++)
    {

      // find the correct ingredient, delete it, update the total page number, and reset the page

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

    // save the changed data if auto save is on

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

    // mark the ingredient as essential or not, save the data if auto save is on
    // adjust the appearance of the option based on the selection

    for (int i = 0; i < current_r.ingredients.size(); i++)
    {
      IngredientStatus ing_status = current_r.ingredients.get(i);
      if (ing_status.essential_toggle == option)
      {
        ing_status.is_essential = option.isSelected();
        option.setOpaque(option.isSelected());
        option.setLocalColor(2, option.isSelected() ? #000000 : text_col);
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
    // make sure the new name is not repeated
    // if the new name is good, reset the contents, since the related recipes will persumably change

    if (!is_ingredient_repeated(source.getText(), 1))
    {
      current_ing.set_name(source.getText());
      current_ing.set_contents();
    }
    
  }
}
