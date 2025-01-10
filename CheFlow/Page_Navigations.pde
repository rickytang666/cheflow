
/* GLOBAL VARIABLES OR CONSTANTS */

GButton prevButton, nextButton, back;
int layer = 0;
int[] currentPages = {0, 0, 0}; 
int[] totalPages = {0, 0, 0};
int buttonsPerPage = 9;

/* FUNCTIONS */

void set_nav_gui()
{
  float navButtonWidth = 100;
  float navButtonHeight = 40;
  float navButtonY = height - 100;
  
  prevButton = new GButton(this, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
  prevButton.addEventHandler(this, "handleButtonEvents");

  nextButton = new GButton(this, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
  nextButton.addEventHandler(this, "handleButtonEvents");
  
  back = new GButton(this, 100, 100, 70, 50, "back");
  back.addEventHandler(this, "handleButtonEvents");
}

void update_nav_gui()
{
  prevButton.setEnabled(layer < 2 && currentPages[layer] > 0);
  nextButton.setEnabled(layer < 2 && currentPages[layer] < totalPages[layer] - 1);
  back.setEnabled(layer > 0);
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
}