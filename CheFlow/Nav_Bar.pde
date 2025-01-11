
/** NAV BAR CLASS **/

class Nav_Bar
{
  PApplet parent;
  GButton home_button, recipes_button, fridge_button, matching_button;

  Nav_Bar(PApplet p)
  {
    this.parent = p;
  }

  void setup()
  {
    home_button = new GButton(parent, 0, 0, 100, 50, "Home");
    recipes_button = new GButton(parent, 200, 0, 100, 50, "Recipes");
    fridge_button = new GButton(parent, 400, 0, 100, 50, "Fridge");
    matching_button = new GButton(parent, 600, 0, 100, 50, "Matching");

    home_button.addEventHandler(parent, "nav_bar_buttons_handler");
    recipes_button.addEventHandler(parent, "nav_bar_buttons_handler");
    fridge_button.addEventHandler(parent, "nav_bar_buttons_handler");
    matching_button.addEventHandler(parent, "nav_bar_buttons_handler");
  }
}

/** GLOBAL FUNCTIONS **/

void switch_page(Page new_page)
{
  current_page.die();
  current_page = new_page;
  current_page.setup();
}


/** EVENT HANDLERS **/

public void nav_bar_buttons_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (button == nb.home_button)
    {
      switch_page(hp);
    }
    else if (button == nb.recipes_button)
    {
      switch_page(rp);
    }
    else if (button == nb.fridge_button)
    {
      switch_page(fp);
    }
    else if (button == nb.matching_button)
    {
      switch_page(mp);
    }
    
  }
}
