
/** ACTIVITY PAGE CLASS **/

class Activity_Page extends Page // Derived from Page class
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator, time_hint, duration_hint;
  GImageButton back, add_button, search_button;
  GTextField search_bar, time_editor, duration_editor;

  /* CONSTRUCTORS */

  Activity_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    // Initialize all nav data

    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }

    total_page_nums[0] = (int) ceil((float) log_records.size() / buttons_per_page);


    // set up navigation gui and the page

    set_nav_gui();
    set_activity_page();

  }


  void die()
  {
    // clear all the static controls and the variable controls, to clear the entire page

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

  // Set up the navigation gui (static ones)

  void set_nav_gui()
  {
    // We use parent because we are in a class, and we need to refer to the main sketch


    // Title of the page, a big label

    title = new GLabel(parent, 10, 70, 200, 40, "ACTIVITIES PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);
    
    float navButtonY = height - 50;

    // Make sure the page buttons are enabled and visible

    prev_button.setEnabled(true);
    prev_button.setVisible(true);
    next_button.setEnabled(true);
    next_button.setVisible(true);

    // Back is for returning to prev layer
    
    back = new GImageButton(parent, 20, 150, 60, 60, new String[] {"back button 1.png", "back button 2.png"});
    back.addEventHandler(parent, "back_button_handler");

    // Add button is for adding a new log

    add_button = new GImageButton(parent, 20, 300, 60, 60, new String[] {"add 1.png", "add 2.png"});
    add_button.addEventHandler(parent, "add_button_handler_log");

    // Page indicator shows the current page progress

    page_indicator = new GLabel(parent, width - 150, navButtonY, 150, button_height);
    page_indicator.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    page_indicator.setOpaque(true);

    // Search bar and button for searching & selecting recipes

    search_bar = new GTextField(parent, width/2 - 75, 100, 150, 40);
    search_bar.setFont(UI_font2);
    
    search_button = new GImageButton(parent, width/2 + 90, 100, 40, 40, new String[] {"search 1.png", "search 2.png"});
    search_button.addEventHandler(parent, "search_button_handler");

    // Time and duration editors for the log record

    time_hint = new GLabel(parent, width/2 - 400, 160, 350, 30, "Time finished (yyyy-mm-dd hh:mm)");
    time_hint.setLocalColor(2, text_col);
    time_hint.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);

    time_editor = new GTextField(parent, width/2 - 250, 200, 200, 30);
    time_editor.addEventHandler(parent, "time_editor_handler");
    time_editor.setFont(UI_font2);

    duration_hint = new GLabel(parent, width/2 + 50, 160, 200, 30, "Duration (minutes)");
    duration_hint.setLocalColor(2, text_col);
    duration_hint.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);

    duration_editor = new GTextField(parent, width/2 + 50, 200, 100, 30);
    duration_editor.addEventHandler(parent, "duration_editor_handler");
    duration_editor.setFont(UI_font2);
    duration_editor.setNumeric(1, 24 * 60, 1);

    // Add all the static controls to the list, so that when the page is cleared, they can be batch disposed

    static_controls.add(title);
    static_controls.add(back);
    static_controls.add(add_button);
    static_controls.add(page_indicator);
    static_controls.add(search_bar);
    static_controls.add(search_button);
    static_controls.add(time_hint);
    static_controls.add(time_editor);
    static_controls.add(duration_hint);
    static_controls.add(duration_editor);
  }


  void update_nav_gui()
  {

    // Based on the nav data, update the status of the nav controls

    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);
    add_button.setEnabled(layer == 0);
    add_button.setVisible(layer == 0);

    if (layer == 0)
    {
      search_bar.setText("");
    }

    // Only when the layer is 1, we pull up those log editing controls

    search_bar.setEnabled(layer == 1 && current_log != null);
    search_bar.setVisible(layer == 1 && current_log != null);
    search_button.setEnabled(layer == 1 && current_log != null);
    search_button.setVisible(layer == 1 && current_log != null);
    time_hint.setEnabled(layer == 1 && current_log != null);
    time_hint.setVisible(layer == 1 && current_log != null);
    time_editor.setEnabled(layer == 1 && current_log != null);
    time_editor.setVisible(layer == 1 && current_log != null);
    duration_hint.setEnabled(layer == 1 && current_log != null);
    duration_hint.setVisible(layer == 1 && current_log != null);
    duration_editor.setEnabled(layer == 1 && current_log != null);
    duration_editor.setVisible(layer == 1 && current_log != null);
  }


  void clear_variable_controls()
  {
    // Dispose all the variable controls, which are the buttons and labels that are created based on the data structures

    for (Log l : log_records)
    {
      l.dispose_controls();
    }

    for (Recipe r : recipes)
    {
      r.dispose_controls();
    }
  }


  void set_activity_page()
  {
    clear_variable_controls();

    update_nav_gui();

    /*
    If the layer is 0, we display all the log records
    If the layer is 1, we display the details of the selected log record and the search results of recipe selection
     */

    if (layer == 0)
    {

      // sort and update info for all the log records

      sort_log_records();

      total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page)); // never let this number be non-positive

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      // calculate the start and end index of items for the current page

      int start = page_nums[0] * buttons_per_page;
      int end = min(log_records.size(), start + buttons_per_page);

      for (int i = start; i < end; ++i)
      {
        Log l  = log_records.get(i);

        // calculate the position and process the button text

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        String str = l.time_finished.get_time_str() + " - " + (l.recipe == null ? l.name : l.recipe.name);
        str = truncate_text(str, button_width);
        l.button = new GButton(parent, x, y, button_width, button_height, str);
        l.button.setLocalColor(3, #48bcb2); // mint green
        l.button.setLocalColor(4, #48bcb2);
        l.button.setLocalColor(6, #7995fd); // light blue for hover
        l.button.setLocalColor(14, #ff93e0); // pink for clicked
        l.button.addEventHandler(parent, "log_button_handler");


        // Use string array to indicate the file names of images

        l.del_button = new GImageButton(parent, x + button_width + button_spacing, y, button_height, button_height, new String[] {"delete1.png", "delete2.png"});
        l.del_button.addEventHandler(parent, "log_del_button_handler");

      }
    }
    else if (layer == 1)
    {
      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);

      int start = page_nums[1] * buttons_per_page;
      int end = min(search_results.size(), start + buttons_per_page);

      // display the stored info, waiting to be changed by user
      
      time_editor.setText(current_log.time_finished.get_time_str());
      duration_editor.setText(str(current_log.duration));


      // A label to show the selected recipe (or none)

      current_log.recipe_label = new GLabel(parent, width - 300, 100, 250, 30);
      current_log.recipe_label.setOpaque(true);
      String str = current_log.recipe == null ? current_log.name : "Selected: " + current_log.recipe.name;
      str = truncate_text(str, 250);
      current_log.recipe_label.setText(str);
      
      // List all the recipes that can be selected based on the search results

      for (int i = start; i < end; ++i)
      {
        Recipe r = search_results.get(i);

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        r.button = new GButton(parent, x, y, button_width, button_height, r.name);
        
        // static-hover-clicked -> saturated pink-dark blue-mint green

        r.button.setLocalColor(3, accent_col2);
        r.button.setLocalColor(4, accent_col2);
        r.button.setLocalColor(6, #274097);
        r.button.setLocalColor(14, #098d8d);
        r.button.setLocalColor(2, #ffffff);
        r.button.addEventHandler(parent, "recipe_button_handler_log");
      }
    }

  }

}


/* EVENT HANDLERS */

public void log_button_handler(GButton button, GEvent event)
{

  // When log button is clicked, we zoom in a further layer
  // Then we set the nav info, and set the page

  if (event == GEvent.CLICKED)
  {
    for (Log l : log_records)
    {
      if (l.button == button)
      {
        current_log = l;
        layer = 1;
        fill_search_results(""); // searching nothing (display all)
        total_page_nums[layer] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
        page_nums[layer] = 0;
        ap.set_activity_page();
        break;
      }
    }
  }
}


public void log_del_button_handler(GImageButton button, GEvent event)
{
  // delete a log record accordingly
  // update the page numbers info and reset the activity page

  if (event == GEvent.CLICKED)
  {
    for (Log l : log_records)
    {
      if (l.del_button == button)
      {
        l.delete();
        total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));
        page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
        ap.set_activity_page();
        break;
      }
    }

    if (auto_save)
    {
      // the data is changed so we should save

      export_data();
    }
  }
}


public void add_button_handler_log(GImageButton button, GEvent event)
{
  // add a log record (push front (so newest is on top))
  // update page info and reset page

  if (event == GEvent.CLICKED)
  {
    Log l = new Log();
    log_records.add(0, l);
    total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));
    page_nums[0] = 0;
    ap.set_activity_page();

    if (auto_save)
    {
      // data is changed, so we should save

      export_data();
    }
  }
}


public void recipe_button_handler_log(GButton button, GEvent event)
{
  // This just update the selected recipe in the log record

  if (event == GEvent.CLICKED)
  {
    for (Recipe r : search_results)
    {
      if (r.button == button)
      {
        current_log.set_recipe(r);
        ap.set_activity_page();
        break;
      }
    }

    if (auto_save)
    {
      // data changed, save immediately

      export_data();
    }
  }
}


public void time_editor_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED)
  {
    String time_str = source.getText();

    // check if the user-entered time format is valid

    if (validate_time_str(time_str) == 0)
    {
      // if valid, update and save

      Time new_time = new Time(time_str);
      current_log.time_finished = new_time;

      if (auto_save)
      {
        export_data();
      }
    }
  }
}


public void duration_editor_handler(GTextField source, GEvent event)
{
  // parse the number entered by the user

  // if valid, update and save

  if (event == GEvent.CHANGED)
  {
    try
    {
      int duration = Integer.parseInt(source.getText());
      current_log.duration = constrain(duration, 1, 24 * 60);

      if (auto_save)
      {
        export_data();
      }
    }
    catch (Exception e)
    {
      println("Duration input is invalid");
    }
  }
}
