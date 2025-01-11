
/* GLOBAL VARIABLES OR CONSTANTS */

GButton prevButton, nextButton, back, search_button;
GTextField search_bar;
// If the user is in searching mode, the search results will be displayed, but they cannot add or delete recipes
// If the user is in browsing mode, display all the recipes, and can add/delete recipes
GOption search_toggle;
Boolean searching = false;
int layer = 0;
int[] currentPages = {0, 0, 0}; 
int[] totalPages = {0, 0, 0};
int buttonsPerPage = 9;

/* FUNCTIONS */

void set_nav_gui()
{
  float navButtonWidth = 100;
  float navButtonHeight = 40;
  float navButtonY = height - 50;
  
  prevButton = new GButton(this, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
  prevButton.addEventHandler(this, "handleButtonEvents");

  nextButton = new GButton(this, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
  nextButton.addEventHandler(this, "handleButtonEvents");
  
  back = new GButton(this, 100, 200, 70, 50, "back");
  back.addEventHandler(this, "handleButtonEvents");

  add_button = new GButton(this, 800, 200, 70, 50, "+Item");
  add_button.addEventHandler(this, "add_button_handler");

  export_button = new GButton(this, 800, 300, 70, 50, "Export");
  export_button.addEventHandler(this, "export_button_handler");

  search_bar = new GTextField(this, 100, 20, 400, 40, G4P.SCROLLBARS_HORIZONTAL_ONLY);
  search_button = new GButton(this, 520, 20, 70, 40, "Search");
  search_button.addEventHandler(this, "handleButtonEvents");

  search_toggle = new GOption(this, 600, 20, 100, 40);
  search_toggle.addEventHandler(this, "search_mode_handler");
  search_toggle.setText("Search Mode");
}

void update_nav_gui()
{
  prevButton.setEnabled(layer < 2 && currentPages[layer] > 0);
  nextButton.setEnabled(layer < 2 && currentPages[layer] < totalPages[layer] - 1);
  back.setEnabled(layer > 0);
  add_button.setEnabled(layer < 2 && search_bar.getText().equals("") && !searching);
  search_button.setEnabled(layer == 0 && searching);
  search_toggle.setEnabled(layer == 0);
}

/* HANLDERS */

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
  else if (button == search_button && event == GEvent.CLICKED)
  {
    println("Searching...");
    String search = search_bar.getText();
    fill_search_results(search);
  }
}


public void search_mode_handler(GOption option, GEvent event)
{
  if (event == GEvent.SELECTED)
  {
    println("Search mode enabled");
    searching = true;
    search_results.clear();
    search_results.addAll(recipes);
    set_recipes_page();
  }
  else if (event == GEvent.DESELECTED)
  {
    println("Search mode disabled");
    searching = false;
    search_bar.setText("");
    totalPages[layer] = (int) ceil((float) recipes.size() / buttonsPerPage);
    set_recipes_page();
  }
}
