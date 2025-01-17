
/** MATCHING PAGE CLASS **/

class Matching_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title;
  GButton prev_button, next_button;

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

    matching_results.clear();
    matching_results.addAll(recipes);

    total_page_nums[0] = (int) ceil((float) matching_results.size() / buttons_per_page);

    for (Recipe r : matching_results)
    {
      r.set_matching_score();
    }

    matching_results.sort((a, b) -> Float.compare(b.matching_score, a.matching_score));


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
    title = new GLabel(parent, width/2 - 150, 70, 300, 40, "MATCHING PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setTextBold();
    title.setTextItalic();
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    float navButtonWidth = 100;
    float navButtonHeight = 40;
    float navButtonY = height - 50;

    prev_button = new GButton(parent, width / 2 - navButtonWidth - 20, navButtonY, navButtonWidth, navButtonHeight, "Previous");
    prev_button.addEventHandler(parent, "handleButtonEvents");

    next_button = new GButton(parent, width / 2 + 20, navButtonY, navButtonWidth, navButtonHeight, "Next");
    next_button.addEventHandler(parent, "handleButtonEvents");

    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
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
    
    int start = page_nums[0] * buttons_per_page;
    int end = min(matching_results.size(), start + buttons_per_page);

    for (int i = start; i < end; ++i)
    {
      Recipe r = matching_results.get(i);
      int index = i - start;
      float x = button_startX;
      float y = button_startY + index * (button_height + button_spacing);

      r.title_label = new GLabel(parent, x, y, button_width, button_height, r.name);
      r.title_label.setLocalColor(6,color(240, 147, 195));
      r.title_label.setOpaque(true);

      r.matching_score_label = new GLabel(parent, x + button_width + 10, y, 100, button_height, nf(r.matching_score, 0, 2));
      r.matching_score_label.setOpaque(true);
      r.matching_score_label.setLocalColor(6, get_color_from_value(r.matching_score));
      r.matching_score_label.setTextBold();
    }

  }
}
