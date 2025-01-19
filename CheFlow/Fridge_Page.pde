
/** FRIDGE PAGE CLASS **/

class Frige_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator;
  GButton prev_button, next_button, back, add_button;
  
  /* CONSTRUCTORS */

  Frige_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
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
    title = new GLabel(parent, 20, 70, 200, 40, "FRIDGE PAGE");
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
    add_button.addEventHandler(parent, "add_button_handler_f");

    page_indicator = new GLabel(parent, width - 150, navButtonY, 100, navButtonHeight);
    page_indicator.setOpaque(true);
    
    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(back);
    static_controls.add(add_button);
    static_controls.add(page_indicator);
  }


  void update_nav_gui()
  {
    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);
    add_button.setEnabled(layer == 0);
    add_button.setVisible(layer == 0);
  }


  void clear_variable_controls()
  {
    for (Ingredient i : fridge)
    {
      i.dispose_controls();
    }
  }


  void set_fridge_page()
  {
    clear_variable_controls();

    update_nav_gui();

    if (layer == 0)
    {
      total_page_nums[0] = (int) ceil((float) fridge.size() / buttons_per_page);

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      int start = page_nums[0] * buttons_per_page;
      int end = min(fridge.size(), start + buttons_per_page);

      for (int i = start; i < end; i++)
      {
        Ingredient ing = fridge.get(i);
        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        ing.button = new GButton(parent, x, y, button_width, button_height, ing.name);
        ing.button.addEventHandler(parent, "ingredient_button_handler_f");

        ing.del_button = new GButton(parent, x + button_width + button_spacing, y, 50, button_height, "Delete");
        ing.del_button.addEventHandler(parent, "ingredient_del_button_handler_f");

      }

    }
    else if (layer == 1)
    {
      String content = "This ingredient is used in " + current_ing.related_recipes.size() + " recipes\n";
      
      current_ing.renamer = new GTextField(parent, width/2 - 100, 120, 200, 40, G4P.SCROLLBARS_HORIZONTAL_ONLY);
      current_ing.renamer.setFont(UI_font);
      current_ing.renamer.setText(current_ing.name);
      current_ing.renamer.addEventHandler(parent, "ingredient_renamer_handler_f");

      current_ing.label = new GLabel(parent, width/2 - 200, 180, 400, 20, content);
      current_ing.label.setLocalColor(2, text_col);
      current_ing.label.setTextAlign(GAlign.CENTER, GAlign.TOP);

      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);

      int start = page_nums[1] * buttons_per_page;
      int end = min(start + buttons_per_page, current_ing.related_recipes.size());

      for(int i = start; i < end; ++i)
      {
        String recipe_name = current_ing.related_recipes.get(i);
        int index = i - start;
        float x = button_startX;
        float y = button_startY + index * (button_height + button_spacing);

        GLabel recipe_label = new GLabel(parent, x, y, button_width, button_height, recipe_name);
        recipe_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
        recipe_label.setOpaque(true);
        current_ing.recipe_labels.add(recipe_label);
      }

    }
  }

}


/* EVENT HANDLERS */

public void add_button_handler_f(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    String name = "ingredient " + ingredient_id;
    ++ingredient_id;
    Ingredient ing = new Ingredient(name);
    fridge.add(0, ing);
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


public void ingredient_del_button_handler_f(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Ingredient ing : fridge)
    {
      if (ing.del_button == button)
      {
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
