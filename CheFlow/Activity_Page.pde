
/** ACTIVITY PAGE CLASS **/

class Activity_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title;
  GButton prev_button, next_button, back, add_button;
  GTextField search_bar, time_editor, duration_editor;

  /* CONSTRUCTORS */

  Activity_Page(PApplet p)
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

    total_page_nums[0] = (int) ceil((float) log_records.size() / buttons_per_page);

    set_nav_gui();
    set_activity_page();

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

    title = new GLabel(parent, 300, 60, 500, 50, "This is the Activity Page");
    
    float navButtonWidth = 100;
    float navButtonHeight = 40;
    float navButtonY = height - navButtonHeight - 10;

    prev_button = new GButton(parent, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
    prev_button.addEventHandler(parent, "handleButtonEvents");

    next_button = new GButton(parent, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
    next_button.addEventHandler(parent, "handleButtonEvents");
    
    back = new GButton(parent, 100, 200, 70, 50, "back");
    back.addEventHandler(parent, "handleButtonEvents");

    add_button = new GButton(parent, 800, 200, 70, 50, "+Log");
    add_button.addEventHandler(parent, "add_button_handler_log");

    search_bar = new GTextField(parent, 100, 100, 200, 30);
    search_bar.addEventHandler(parent, "search_bar_handler");

    time_editor = new GTextField(parent, 100, 150, 200, 30);
    time_editor.addEventHandler(parent, "time_editor_handler");

    duration_editor = new GTextField(parent, 320, 150, 70, 30);
    duration_editor.addEventHandler(parent, "duration_editor_handler");
    duration_editor.setNumeric(1, 24 * 60, 1);

    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(back);
    static_controls.add(add_button);
    static_controls.add(search_bar);
    static_controls.add(time_editor);
    static_controls.add(duration_editor);
  }


  void update_nav_gui()
  {
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
    search_bar.setEnabled(layer == 1 && current_log != null);
    search_bar.setVisible(layer == 1 && current_log != null);
    time_editor.setEnabled(layer == 1 && current_log != null);
    time_editor.setVisible(layer == 1 && current_log != null);
    duration_editor.setEnabled(layer == 1 && current_log != null);
    duration_editor.setVisible(layer == 1 && current_log != null);
  }


  void clear_variable_controls()
  {
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

    if (layer == 0)
    {
      sort_log_records();

      total_page_nums[0] = (int) ceil((float) log_records.size() / buttons_per_page);

      int start = page_nums[0] * buttons_per_page;
      int end = min(log_records.size(), start + buttons_per_page);

      for (int i = start; i < end; ++i)
      {
        Log l  = log_records.get(i);

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        l.button = new GButton(parent, x, y, button_width, button_height, l.time_finished.get_time_str() + " - " + (l.recipe == null ? l.name : l.recipe.name));
        l.button.addEventHandler(parent, "log_button_handler");

        l.del_button = new GButton(parent, x + button_width + button_spacing, y, 50, button_height, "Delete");
        l.del_button.addEventHandler(parent, "log_del_button_handler");

      }
    }
    else if (layer == 1)
    {
      int start = page_nums[1] * buttons_per_page;
      int end = min(search_results.size(), start + buttons_per_page);

      time_editor.setText(current_log.time_finished.get_time_str());
      duration_editor.setText(str(current_log.duration));

      current_log.recipe_label = new GLabel(parent, 350, 100, 200, 30);
      String str = (current_log.recipe == null ? current_log.name : current_log.recipe.name);
      
      current_log.recipe_label.setText(str);
      

      for (int i = start; i < end; ++i)
      {
        Recipe r = search_results.get(i);

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        r.button = new GButton(parent, x, y, button_width, button_height, r.name);
        r.button.addEventHandler(parent, "recipe_button_handler_log");
      }
    }

  }

}


/* EVENT HANDLERS */

public void log_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Log l : log_records)
    {
      if (l.button == button)
      {
        current_log = l;
        layer = 1;
        fill_search_results("");
        total_page_nums[layer] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
        ap.set_activity_page();
        break;
      }
    }
  }
}


public void log_del_button_handler(GButton button, GEvent event)
{
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
  }
}


public void add_button_handler_log(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    Log l = new Log();
    log_records.add(0, l);
    total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));
    page_nums[0] = 0;
    ap.set_activity_page();
  }
}


public void recipe_button_handler_log(GButton button, GEvent event)
{
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
  }
}


public void time_editor_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED)
  {
    String time_str = source.getText();

    if (validate_time_str(time_str) == 0)
    {
      Time new_time = new Time(time_str);
      current_log.time_finished = new_time;
    }
  }
}


public void duration_editor_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED)
  {
    try
    {
      int duration = Integer.parseInt(source.getText());
      current_log.duration = constrain(duration, 1, 24 * 60);
    }
    catch (Exception e)
    {
      
    }
  }
}
