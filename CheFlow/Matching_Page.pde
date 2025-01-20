
/** MATCHING PAGE CLASS **/

class Matching_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator, duration_hint, time_priority_hint;
  GImageButton prev_button, next_button;
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
    title = new GLabel(parent, 10, 70, 200, 40, "MATCHING PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    float navButtonY = height - 50;

    prev_button = new GImageButton(parent, width / 2 - 60, navButtonY, button_height, button_height, new String[] {"previous 1.png", "previous 2.png"});
    prev_button.addEventHandler(parent, "handleButtonEvents");

    next_button = new GImageButton(parent, width / 2 + 60, navButtonY, button_height, button_height, new String[] {"next 1.png", "next 2.png"});
    next_button.addEventHandler(parent, "handleButtonEvents");

    page_indicator = new GLabel(parent, width - 150, navButtonY, 150, button_height);
    page_indicator.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    page_indicator.setOpaque(true);

    duration_hint = new GLabel(parent, width/2 - 150, 100, 300, 30, "Duration demand (minutes)");
    duration_hint.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    duration_hint.setLocalColor(2, text_col);

    duration_editor = new GTextField(parent, width/2 - 50, 150, 100, 30);
    duration_editor.setFont(UI_font2);
    duration_editor.setOpaque(true);
    duration_editor.setText(str(duration_demand));
    duration_editor.setNumeric(1, 24 * 60, 30);
    duration_editor.addEventHandler(parent, "duration_editor_handler_m");

    time_priority_hint = new GLabel(parent, width/2 - 100, 200, 200, 30, "Time priority toggle");
    time_priority_hint.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    time_priority_hint.setLocalColor(2, text_col);

    time_priority_toggle = new GImageToggleButton(parent, width/2 + 100, 200, "toggle.png", 1, 2);
    time_priority_toggle.setState(time_priority ? 1 : 0);
    time_priority_toggle.addEventHandler(parent, "time_priority_toggle_handler");

    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(page_indicator);
    static_controls.add(duration_editor);
    static_controls.add(duration_hint);
    static_controls.add(time_priority_hint);
    static_controls.add(time_priority_toggle);
  }


  void update_nav_gui()
  {
    prev_button.setEnabled(layer == 0 && page_nums[0] > 0);
    next_button.setEnabled(layer == 0 && page_nums[0] < total_page_nums[0] - 1);
  }


  void clear_variable_controls()
  {
    for (Recipe r : recipes)
    {
      r.dispose_controls();
    }
  }


  void set_matching_page()
  {
    clear_variable_controls();

    update_nav_gui();

    fill_matching_results();

    total_page_nums[0] = max(1, (int)ceil((float)matching_results.size() / buttons_per_page));

    page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);
    
    int start = page_nums[0] * buttons_per_page;
    int end = min(matching_results.size(), start + buttons_per_page);

    for (int i = start; i < end; ++i)
    {
      Recipe r = matching_results.get(i);
      int index = i - start;
      float x = button_startX;
      float y = button_startY + index * (button_height + button_spacing);

      r.title_label = new GLabel(parent, x, y, button_width, button_height, r.name);
      r.title_label.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
      r.title_label.setOpaque(true);

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
    try 
    {
      duration_demand = int(tf.getText());
      duration_demand = max(1, min(24 * 60, duration_demand));
    }
    catch (Exception ex)
    {
      duration_demand = 30;
    }

    mp.set_matching_page();
    
  }
}


public void time_priority_toggle_handler(GImageToggleButton toggle, GEvent e)
{
  if (e == GEvent.CLICKED)
  {
    time_priority = toggle.getState() == 1;
    mp.set_matching_page();
  }
}
