
/** NAV BAR CLASS **/

class Nav_Bar
{
  PApplet parent;
  GButton home_button, recipes_button, fridge_button, matching_button, activity_button;

  Nav_Bar(PApplet p)
  {
    this.parent = p;
  }

  void setup()
  {
    float start_x = 140;

    float spacing = 20;

    float btn_width = (width - start_x - 6 * spacing) / 5.0;

    home_button = new GButton(parent, start_x + spacing, 5, btn_width, 50, "Home");
    recipes_button = new GButton(parent, start_x + btn_width + 2 * spacing, 5, btn_width, 50, "Recipes");
    fridge_button = new GButton(parent, start_x + 2 * btn_width + 3 * spacing, 5, btn_width, 50, "Fridge");
    matching_button = new GButton(parent, start_x + 3 * btn_width + 4 * spacing, 5, btn_width, 50, "Matching");
    activity_button = new GButton(parent, start_x + 4 * btn_width + 5 * spacing, 5, btn_width, 50, "Activity");

    home_button.addEventHandler(parent, "nav_bar_buttons_handler");
    recipes_button.addEventHandler(parent, "nav_bar_buttons_handler");
    fridge_button.addEventHandler(parent, "nav_bar_buttons_handler");
    matching_button.addEventHandler(parent, "nav_bar_buttons_handler");
    activity_button.addEventHandler(parent, "nav_bar_buttons_handler");
  }

  
  void draw()
  {
    fill( #cdfbf2);
    noStroke();
    rect(0, 0, width, 60);
  }
}

/** GLOBAL FUNCTIONS **/

void switch_page(Page new_page)
{
  current_Page.die();
  current_Page = new_page;
  current_Page.setup();
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
    else if (button == nb.activity_button)
    {
      switch_page(ap);
    }
    
  }
}
