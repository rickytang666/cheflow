
/** MATCHING PAGE CLASS **/

class Matching_Page extends Page // Derived from Page class
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator, duration_hint, time_priority_hint;
  GImageToggleButton time_priority_toggle;
  GTextField duration_editor;

  /* CONSTRUCTORS */

  Matching_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    // Reset all the nav data, and set up the static guis & matching page

    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }


    set_nav_gui();
    set_matching_page();

  }


  void die()
  {
    // Dispose static controls and clear variable controls

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

    // page title

    title = new GLabel(parent, 10, 70, 200, 40, "MATCHING PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    float navButtonY = height - 50;

    // Get the page buttons into use

    prev_button.setEnabled(true);
    prev_button.setVisible(true);
    next_button.setEnabled(true);
    next_button.setVisible(true);

    // set up the page indicator

    page_indicator = new GLabel(parent, width - 150, navButtonY, 150, button_height);
    page_indicator.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    page_indicator.setOpaque(true);

    // set up the duration demand editor and hint label

    duration_hint = new GLabel(parent, width/2 - 150, 100, 300, 30, "Duration demand (minutes)");
    duration_hint.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    duration_hint.setLocalColor(2, text_col);

    duration_editor = new GTextField(parent, width/2 - 50, 150, 100, 30);
    duration_editor.setFont(UI_font2);
    duration_editor.setOpaque(true);
    duration_editor.setText(str(duration_demand));
    duration_editor.setNumeric(1, 24 * 60, 30);
    duration_editor.addEventHandler(parent, "duration_editor_handler_m");

    // set up the time priority toggle (an image toggle button that has 1 vertical tile and 2 horizontal tiles)

    time_priority_hint = new GLabel(parent, width/2 - 100, 200, 200, 30, "Time priority toggle");
    time_priority_hint.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    time_priority_hint.setLocalColor(2, text_col);

    time_priority_toggle = new GImageToggleButton(parent, width/2 + 100, 200, "toggle.png", 1, 2);
    time_priority_toggle.setState(time_priority ? 1 : 0);
    time_priority_toggle.addEventHandler(parent, "time_priority_toggle_handler");

    // put all the static controls into the list, for easy batch disposal

    static_controls.add(title);
    static_controls.add(page_indicator);
    static_controls.add(duration_editor);
    static_controls.add(duration_hint);
    static_controls.add(time_priority_hint);
    static_controls.add(time_priority_toggle);
  }


  void update_nav_gui()
  {
    // update the page buttons based on the layer and page numbers

    prev_button.setEnabled(layer == 0 && page_nums[0] > 0);
    next_button.setEnabled(layer == 0 && page_nums[0] < total_page_nums[0] - 1);
  }


  void clear_variable_controls()
  {
    // Dispose all the variable controls from recipes

    for (Recipe r : recipes)
    {
      r.dispose_controls();
    }
  }


  void set_matching_page()
  {
    clear_variable_controls();

    update_nav_gui();

    fill_matching_results(); // Update the data structure in case we have reseted it

    // update the nav data

    total_page_nums[0] = max(1, (int)ceil((float)matching_results.size() / buttons_per_page));

    page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

    // display the recipes labels in this page
    
    int start = page_nums[0] * buttons_per_page;
    int end = min(matching_results.size(), start + buttons_per_page);

    for (int i = start; i < end; ++i)
    {
      Recipe r = matching_results.get(i);

      // calculate the position of the button

      int index = i - start;
      float x = button_startX;
      float y = button_startY + index * (button_height + button_spacing);

      // truncate the name and set up the labels

      String name = truncate_text(r.name, button_width);
      r.title_label = new GLabel(parent, x, y, button_width, button_height, name);
      r.title_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
      r.title_label.setOpaque(true);

      // make the score accurate to 2 decimal places, and utilize the color gradient

      r.matching_score_label = new GLabel(parent, x + button_width + 10, y, 100, button_height, nf(r.matching_score, 0, 2));
      r.matching_score_label.setOpaque(true);
      r.matching_score_label.setLocalColor(6, get_color_from_value(r.matching_score));
      r.matching_score_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
      r.matching_score_label.setTextBold();
    }

  }
}


/* EVENT HANDLERS */

public void duration_editor_handler_m(GTextField tf, GEvent e)
{
  if (e == GEvent.CHANGED)
  {
    // only update the duration demand if the user enters a (changed) valid number\

    try 
    {
      duration_demand = int(tf.getText());
      duration_demand = max(1, min(24 * 60, duration_demand)); // constrain the value to 1-1440 (1440 is just a day)
    }
    catch (Exception ex)
    {

      // if the user enters an invalid value, reset the duration demand to 30

      duration_demand = 30;
    }

    mp.set_matching_page();
    
  }
}


public void time_priority_toggle_handler(GImageToggleButton toggle, GEvent e)
{
  if (e == GEvent.CLICKED)
  {
    // process the time priority, and reset the page
    
    time_priority = toggle.getState() == 1;
    mp.set_matching_page();
  }
}
