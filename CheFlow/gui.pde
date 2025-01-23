// This file contains the global GUI functions for the application
// Note that the variables are global here, and the functions are all shared in multiple pages

/* GLOBAL VARIABLES OR CONSTANTS */

GImageButton prev_button, next_button;
final boolean safe_mode = true; // If true, the buttons will have a cooldown before they can be clicked again
int next_btn_cooldown = 0, prev_btn_cooldown = 0; // keep track of the cooldowns for the buttons
final int COOLDOWN_FRAMES = 20; // number of frames to wait before the button can be clicked again

/* GUI FUNCTIONS */

public void createGUI()
{
  G4P.messagesEnabled(false); // Don't want to see the messages printed

  float navButtonY = height - 50;

  // set up the page buttons globally

  // for image buttons, we need to use string array to specify the image faces for the button
    
  prev_button = new GImageButton(this, width / 2 - 60, navButtonY,  button_height, button_height, new String[] {"previous 1.png", "previous 2.png"});
  prev_button.addEventHandler(this, "page_button_handler");

  next_button = new GImageButton(this, width / 2 + 60, navButtonY, button_height, button_height, new String[] {"next 1.png", "next 2.png"});
  next_button.addEventHandler(this, "page_button_handler");
}


/* EVENT HANDLERS (SHARED) */


public void page_button_handler(GImageButton button, GEvent event)
{

  // if the button is clicked, add/subtract the page num and update the correct page

  if (event == GEvent.CLICKED)
  {
    if (button == prev_button)
    {
      page_nums[layer]--;

      if (current_Page == rp)
      {
        rp.set_recipes_page();
      }
      else if (current_Page == fp)
      {
        fp.set_fridge_page();
      }
      else if (current_Page == mp)
      {
        mp.set_matching_page();
      }
      else if (current_Page == ap)
      {
        ap.set_activity_page();
      }

      if (safe_mode)
      {
        // send the button to cooldown after clicking

        prev_btn_cooldown = COOLDOWN_FRAMES;
        prev_button.setEnabled(false);
      }
    }
    else if (button == next_button)
    {
      page_nums[layer]++;

      if (current_Page == rp)
      {
        rp.set_recipes_page();
      }
      else if (current_Page == fp)
      {
        fp.set_fridge_page();
      }
      else if (current_Page == mp)
      {
        mp.set_matching_page();
      }
      else if (current_Page == ap)
      {
        ap.set_activity_page();
      }

      if (safe_mode)
      {
        // send the button to cooldown after clicking

        next_btn_cooldown = COOLDOWN_FRAMES;
        next_button.setEnabled(false);
      }
    }

  }
}


public void back_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {

    // update the nav info and reset the correct page

    page_nums[layer] = 0;
    total_page_nums[layer] = 0;
    layer--;

    if (button == rp.back)
    {
      rp.set_recipes_page();
    }
    else if (button == fp.back)
    {
      fp.set_fridge_page();
    }
    else if (button == ap.back)
    {
      ap.set_activity_page();
    }

  }
}


public void search_button_handler(GImageButton button, GEvent event)
{
  // fill the search result based on the search content
  // update the nav info based on the updated array
  // reset the correct page

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