
/** FRIDGE PAGE CLASS **/

class Frige_Page extends Page // Derived from Page class
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator;
  GImageButton back, add_button;
  
  /* CONSTRUCTORS */

  Frige_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    // initialize all the nav data, and set up the static guis and page

    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }

    total_page_nums[0] = (int) ceil((float) fridge.size() / buttons_per_page);
    
    set_nav_gui();
    set_fridge_page();
  }


  void die()
  {

    // dispose all the controls (clear page)

    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
      }
    }

    clear_variable_controls();
  }

  /* ADDITIONAL METHODS */

  void set_nav_gui()
  {
    // set up the static gui elements
    
    title = new GLabel(parent, 10, 70, 200, 40, "FRIDGE PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    float navButtonY = height - 50;

    // this page uses page buttons, so we need to set them up

    prev_button.setEnabled(true);
    prev_button.setVisible(true);
    next_button.setEnabled(true);
    next_button.setVisible(true);

    // set up the back button and the add button
    
    back = new GImageButton(parent, 20, 150, 60, 60, new String[] {"back button 1.png", "back button 2.png"});
    back.addEventHandler(parent, "back_button_handler");

    add_button = new GImageButton(parent, 20, 300, 60, 60, new String[] {"add 1.png", "add 2.png"});
    add_button.addEventHandler(parent, "add_button_handler_f");

    // set up the page indicator

    page_indicator = new GLabel(parent, width - 150, navButtonY, 150, button_height);
    page_indicator.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    page_indicator.setOpaque(true);

    // add all the controls to the static controls list, so they can be disposed later
    
    static_controls.add(title);
    static_controls.add(back);
    static_controls.add(add_button);
    static_controls.add(page_indicator);
  }


  void update_nav_gui()
  {
    // update the page indicator and the buttons based on the current layer and page number

    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);
    add_button.setEnabled(layer == 0);
    add_button.setVisible(layer == 0);
  }


  void clear_variable_controls()
  {

    // dispose all the controls that are not static (from data structures)

    for (Ingredient i : fridge)
    {
      i.dispose_controls();
    }
  }


  void set_fridge_page()
  {
    clear_variable_controls();

    update_nav_gui();

    /*
      If the layer is 0, we display the ingredients in the fridge
      If the layer is 1, we display the recipes that use the selected ingredient
    */

    if (layer == 0)
    {

      // set up the page indicator and the buttons for the ingredients

      total_page_nums[0] = (int) ceil((float) fridge.size() / buttons_per_page);

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      // calculate the start and end indices for the ingredients to be displayed

      int start = page_nums[0] * buttons_per_page;
      int end = min(fridge.size(), start + buttons_per_page);

      for (int i = start; i < end; i++)
      {

        // button position calculation

        Ingredient ing = fridge.get(i);
        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        // set up buttons

        // static-hover-clicked -> lime green-yellow-light blue

        String name = truncate_text(ing.name, button_width);
        ing.button = new GButton(parent, x, y, button_width, button_height, name);
        ing.button.setLocalColor(4, accent_col3);
        ing.button.setLocalColor(3, accent_col3);
        ing.button.setLocalColor(6, #edde32);
        ing.button.setLocalColor(14, #30c5c5);
        ing.button.addEventHandler(parent, "ingredient_button_handler_f");

        ing.del_button = new GImageButton(parent, x + button_width + button_spacing, y, button_height, button_height, new String[] {"delete1.png", "delete2.png"});
        ing.del_button.addEventHandler(parent, "ingredient_del_button_handler_f");

      }

    }
    else if (layer == 1)
    {
      // set up the page indicator and the labels for the recipes that use the selected ingredient

      String content = "This ingredient is used in " + current_ing.related_recipes.size() + " recipes\n";
      
      current_ing.renamer = new GTextField(parent, width/2 - 100, 120, 200, 40);
      current_ing.renamer.setFont(UI_font2);
      current_ing.renamer.setText(current_ing.name);
      current_ing.renamer.addEventHandler(parent, "ingredient_renamer_handler_f");

      current_ing.label = new GLabel(parent, width/2 - 200, 180, 400, 40, content); // for the total count of relevant recipes
      current_ing.label.setLocalColor(2, text_col);
      current_ing.label.setTextAlign(GAlign.CENTER, GAlign.TOP);

      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);


      // loop through all of the related recipes and set up the labels

      int start = page_nums[1] * buttons_per_page;
      int end = min(start + buttons_per_page, current_ing.related_recipes.size());

      for(int i = start; i < end; ++i)
      {
        String recipe_name = current_ing.related_recipes.get(i);
        recipe_name = truncate_text(recipe_name, button_width);
        int index = i - start;
        float x = button_startX;
        float y = button_startY + index * (button_height + button_spacing);

        GLabel recipe_label = new GLabel(parent, x, y, button_width, button_height, recipe_name);
        recipe_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        recipe_label.setOpaque(true);
        current_ing.recipe_labels.add(recipe_label); // store the labels for disposal later
      }

    }
  }

}


/* EVENT HANDLERS */

public void add_button_handler_f(GImageButton button, GEvent event)
{
  // add ingredient to fridge (push front), and setup the page

  if (event == GEvent.CLICKED)
  {

    // use the id to give a unique default name
    
    String name = "ingredient " + ingredient_id;
    ++ingredient_id;
    Ingredient ing = new Ingredient(name);
    fridge.add(0, ing);

    // update info, setup page, and save data

    total_page_nums[0] = max(1, (int) ceil((float) fridge.size() / buttons_per_page));
    page_nums[0] = 0;
    fp.set_fridge_page();

    if (auto_save)
    {
      export_data();
    }
  }
}


public void ingredient_button_handler_f(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Ingredient ing : fridge)
    {
      if (ing.button == button)
      {

        // if found, zoom in the layer and set the new fridge page, update the nav info

        current_ing = ing;
        layer = 1;
        ing.set_contents();
        page_nums[1] = 0;
        total_page_nums[1] = max(1, (int) ceil((float) current_ing.related_recipes.size() / buttons_per_page));
        fp.set_fridge_page();
        break;
      }
    }
  }
}


public void ingredient_del_button_handler_f(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Ingredient ing : fridge)
    {
      if (ing.del_button == button)
      {
        // remove the ingredient (dispose controls also), update the nav info, and save data

        ing.dispose_controls();
        fridge.remove(ing);
        total_page_nums[0] = max(1, (int) ceil((float) fridge.size() / buttons_per_page));
        page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
        fp.set_fridge_page();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }
  }
}


public void ingredient_renamer_handler_f(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && current_ing != null)
  {

    // we need to make sure the new name is not repeated, and we need to save data
    
    if (!is_ingredient_repeated(source.getText(), 2))
    {
      current_ing.name = source.getText();
      current_ing.set_contents();

      if (auto_save)
      {
        export_data();
      }
    }
  }
}
