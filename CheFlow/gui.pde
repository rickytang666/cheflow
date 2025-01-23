// Common GUIs

GImageButton prev_button, next_button;
final boolean safe_mode = true;
int next_btn_cooldown = 0, prev_btn_cooldown = 0;
final int COOLDOWN_FRAMES = 20;

public void createGUI()
{
  G4P.messagesEnabled(false);

  float navButtonY = height - 50;
    
  prev_button = new GImageButton(this, width / 2 - 60, navButtonY,  button_height, button_height, new String[] {"previous 1.png", "previous 2.png"});
  prev_button.addEventHandler(this, "page_button_handler");

  next_button = new GImageButton(this, width / 2 + 60, navButtonY, button_height, button_height, new String[] {"next 1.png", "next 2.png"});
  next_button.addEventHandler(this, "page_button_handler");
}


public void page_button_handler(GImageButton button, GEvent event)
{
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
        prev_btn_cooldown = COOLDOWN_FRAMES;
        prev_button.setEnabled(false);
        // println("prev button cooldown set", prev_button.isEnabled());
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
        next_btn_cooldown = COOLDOWN_FRAMES;
        next_button.setEnabled(false);
        // println("next button cooldown set", next_button.isEnabled());
      }
    }

  }
}


public void back_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
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