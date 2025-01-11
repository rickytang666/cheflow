
/** FRIDGE PAGE CLASS **/

class Frige_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title;
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

    for (int i : currentPages)
    {
      i = 0;
    }
    
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
    title = new GLabel(parent, 300, 60, 500, 30, "This is the Fridge Page");
    
    
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
    
    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(back);
    static_controls.add(add_button);
  }


  void update_nav_gui()
  {
    prev_button.setEnabled(layer == 0);
    next_button.setEnabled(layer == 0);
    back.setEnabled(layer > 0);
    add_button.setEnabled(layer == 0);
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
      totalPages[0] = (int) ceil((float) fridge.size() / buttons_per_page);

      int start = currentPages[0] * buttons_per_page;
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
      current_ing.label = new GLabel(parent, 350, 200, 900, 400, current_ing.content);

      current_ing.renamer = new GTextField(parent, 350, 150, 200, 40, G4P.SCROLLBARS_HORIZONTAL_ONLY);
      current_ing.renamer.setText(current_ing.name);
      current_ing.renamer.addEventHandler(parent, "ingredient_renamer_handler_f");
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
    fridge.add(ing);
    totalPages[0] = (int) ceil((float) fridge.size() / buttons_per_page);
    currentPages[0] = totalPages[0] - 1;
    fp.set_fridge_page();
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
        fridge.remove(ing);
        totalPages[0] = (int) ceil((float) fridge.size() / buttons_per_page);
        currentPages[0] = constrain(currentPages[0], 0, totalPages[0] - 1);
        fp.set_fridge_page();
        break;
      }
    }
  }
}


public void ingredient_renamer_handler_f(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED && current_ing != null)
  {
    if (!is_ingredient_repeated(source.getText(), fridge))
    {
      current_ing.name = source.getText();
      current_ing.set_contents();
    }
  }
}
