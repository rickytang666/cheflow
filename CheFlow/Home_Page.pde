
/** HOME PAGE CLASS **/

class Home_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  GLabel title, autosave_hint, insights;
  GButton export_button, graph_button, heatmap_button, notice_button;
  GImageToggleButton autosave_toggle;
  GDropList days_droplist, regression_droplist;
  GWindow graph_window, heatmap_window, notice_window;

  int num_past_days = 14; // number of days to look back for the graph
  String regression_type = "linear";

  /* CONSTRUCTORS */

  Home_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    // reset all the nav info and set up the whole page

    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }

    update_daily_durations();

    set_static_gui();
  }


  void die()
  {
    // Dispose all the controls

    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
        c = null;
      }
    }

    // the droplists need special processes (when they dispose and recreate, they aren't responsive)

    days_droplist.setEnabled(false);
    days_droplist.setVisible(false);
    regression_droplist.setEnabled(false);
    regression_droplist.setVisible(false);

    static_controls.clear();
  }

  /* ADDITIONAL METHODS */

  void set_static_gui()
  {
    // set up the static GUI elements

    // title label

    title = new GLabel(parent, 10, 70, 200, 40, "HOME PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Segoe UI Semibold", Font.ITALIC, 20));
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    // Since we don't need page buttons for home page, we can disable them

    prev_button.setEnabled(false);
    prev_button.setVisible(false);
    next_button.setEnabled(false);
    next_button.setVisible(false);

    // Autosave toggle (image toggle button, 1 vertical tiles, and 2 horizontal tiles (observing the image)) 

    autosave_toggle = new GImageToggleButton(parent, 120, 150, "toggle.png", 1, 2);
    autosave_toggle.setState(auto_save ? 1 : 0);
    autosave_toggle.addEventHandler(parent, "autosave_toggle_handler");

    autosave_hint = new GLabel(parent, 20, 150, 100, 40, "Autosave: ");
    autosave_hint.setTextAlign(GAlign.RIGHT, GAlign.MIDDLE);
    autosave_hint.setLocalColor(2, text_col);
    
    // Insights label (with an image icon)

    insights = new GLabel(parent, width/2 - 300, 150, 600, 150);
    PImage img = loadImage("insights.png");
    img.resize(0, 75);
    insights.setIcon(img, 1, GAlign.NORTH, GAlign.CENTER, GAlign.TOP); // set the icon to the top of the label
    insights.setTextAlign(GAlign.CENTER, GAlign.TOP);
    insights.setOpaque(true);
    insights.setFont(UI_font2.deriveFont(20.0)); // larger font size
    
    String str = "\n";

    str += "You spent " + nf(get_average_duration(7), 0, 2) + " minutes on average cooking in the past 7 days.\n";
    str += "You spent " + nf(get_average_duration(30), 0, 2) + " minutes on average cooking in the past 30 days.\n";
    str += "You spent " + nf(get_average_duration(365), 0, 2) + " minutes on average cooking in the past year.\n";
    str += "Your longest streak is " + get_longest_streak() + " days.\n \n";

    insights.setText(str);
    insights.resizeToFit(true, true); // fit both width and height

    // button for exporting data
    // when the user doesn't enable autosave, they can export the data manually

    export_button = new GButton(parent, 400, 400, 200, 40, "Export Data");
    export_button.setLocalColor(3, accent_col);
    export_button.setLocalColor(4, accent_col);
    export_button.setLocalColor(6, #e2f06b); // light yellowy green
    export_button.addEventHandler(parent, "export_button_handler");

    // button to activiate the graph window

    graph_button = new GButton(parent, 400, 450, 200, 40, "View Graph");
    graph_button.setLocalColor(3, accent_col);
    graph_button.setLocalColor(4, accent_col);
    graph_button.setLocalColor(6, #e2f06b);
    graph_button.addEventHandler(parent, "graph_button_handler");

    // drop lists for selecting the number of days and the regression type

    days_droplist = new GDropList(parent, 650, 450, 150, 150, 3, 20);
    String[] items = {"Past 7 days", "Past 14 Days", "Past 30 days", "Past 100 days", "Past 365 days"};
    days_droplist.setItems(items, 1);
    days_droplist.setLocalColorScheme(GCScheme.RED_SCHEME);
    days_droplist.setLocalColor(5, accent_col3);
    days_droplist.setLocalColor(3, #000000);
    days_droplist.setLocalColor(4, accent_col2);
    days_droplist.setLocalColor(6, #d1ffbd); // light green
    days_droplist.setLocalColor(15, accent_col2);
    days_droplist.addEventHandler(parent, "days_droplist_handler");

    regression_droplist = new GDropList(parent, 820, 450, 150, 150, 3, 20);
    String[] items2 = {"linear", "quadratic", "exponential"};
    regression_droplist.setItems(items2, 0);
    regression_droplist.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
    regression_droplist.setLocalColor(5, accent_col3);
    regression_droplist.setLocalColor(3, #000000);
    regression_droplist.setLocalColor(4, accent_col2);
    regression_droplist.setLocalColor(6, #d1ffbd);
    regression_droplist.setLocalColor(15, accent_col2);
    regression_droplist.addEventHandler(parent, "regression_droplist_handler");

    // button to view the heatmap

    heatmap_button = new GButton(parent, 400, 500, 200, 40, "View Heatmap");
    heatmap_button.setLocalColor(3, accent_col);
    heatmap_button.setLocalColor(4, accent_col);
    heatmap_button.setLocalColor(6, #e2f06b);
    heatmap_button.addEventHandler(parent, "heatmap_button_handler");

    // button to view the user notice

    notice_button = new GButton(parent, 400, 550, 200, 40, "User Notice");
    notice_button.setLocalColor(3, accent_col);
    notice_button.setLocalColor(4, accent_col);
    notice_button.setLocalColor(6, #e2f06b);
    notice_button.addEventHandler(parent, "notice_button_handler");

    // add all the controls to the list, so we can dispose them later

    static_controls.add(title);
    static_controls.add(autosave_toggle);
    static_controls.add(autosave_hint);
    static_controls.add(export_button);
    static_controls.add(graph_button);
    static_controls.add(heatmap_button);
    static_controls.add(insights);
    static_controls.add(notice_button);
  }
}

/* EVENT HANDLERS */

public void autosave_toggle_handler(GImageToggleButton button, GEvent event)
{
  auto_save = (button.getState() == 1); // 1 means on, 0 means off
}


public void export_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    export_data();
  }
}


public void graph_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (hp.graph_window == null)
    {
      open_graph_window();
    }
    else
    {
      println("Graph window already open");
    }
  }
}


void open_graph_window()
{
  // set up the graph window
  hp.graph_window = GWindow.getWindow(this, "Graph", 200, 150, 1200, 600, JAVA2D);
  hp.graph_window.addDrawHandler(this, "graph_window_draw");
  hp.graph_window.addOnCloseHandler(this, "graph_window_close");
  hp.graph_window.setActionOnClose(G4P.CLOSE_WINDOW);
}


public void graph_window_draw(PApplet appc, GWinData data)
{
  // draw the scatter plot based on the selected number of days and regression type

  draw_scatter_plot(appc, hp.num_past_days, hp.regression_type);
}


public void graph_window_close(GWindow window)
{
  hp.graph_window.dispose(); // also dispose the controls on itself
  hp.graph_window = null;
}


public void days_droplist_handler(GDropList droplist, GEvent event)
{

  // change the number of days based on the selected item

  if (event == GEvent.SELECTED)
  {
    String selected = droplist.getSelectedText();
    if (selected.equals("Past 7 days"))
    {
      hp.num_past_days = 7;
    }
    else if (selected.equals("Past 14 Days"))
    {
      hp.num_past_days = 14;
    }
    else if (selected.equals("Past 30 days"))
    {
      hp.num_past_days = 30;
    }
    else if (selected.equals("Past 100 days"))
    {
      hp.num_past_days = 100;
    }
    else if (selected.equals("Past 365 days"))
    {
      hp.num_past_days = 365;
    }
  }
}


public void regression_droplist_handler(GDropList droplist, GEvent event)
{
  if (event == GEvent.SELECTED)
  {
    String selected = droplist.getSelectedText();
    hp.regression_type = selected;
  }
}


public void heatmap_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (hp.heatmap_window == null)
    {
      open_heatmap_window();
    }
    else
    {
      println("Heatmap window already open");
    }
  }
}


public void open_heatmap_window()
{
  // set up the heatmap window

  hp.heatmap_window = GWindow.getWindow(this, "Heatmap", 200, 300, 1200, 200, JAVA2D);
  hp.heatmap_window.addDrawHandler(this, "heatmap_window_draw");
  hp.heatmap_window.addOnCloseHandler(this, "heatmap_window_close");
  hp.heatmap_window.setActionOnClose(G4P.CLOSE_WINDOW);
}


public void heatmap_window_draw(PApplet appc, GWinData data)
{
  drawHeatMap(appc);
}


public void heatmap_window_close(GWindow window)
{
  hp.heatmap_window.dispose();
  hp.heatmap_window = null;
}


public void notice_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (hp.notice_window == null)
    {
      open_notice_window();
    }
    else
    {
      println("User Notice window already open");
    }
  }
}


public void open_notice_window()
{
  // set up the user notice window

  hp.notice_window = GWindow.getWindow(this, "User Notice", 200, 200, 600, 400, JAVA2D);
  hp.notice_window.addDrawHandler(this, "notice_window_draw");
  hp.notice_window.addOnCloseHandler(this, "notice_window_close");
  hp.notice_window.setActionOnClose(G4P.CLOSE_WINDOW);

  // set up the text area to display the user notice
  // this has the advantage of scrolling if the text is too long
  // we set it to not editable so the user can't change the text

  GTextArea display = new GTextArea(hp.notice_window, 10, 50, 580, 300, G4P.SCROLLBARS_BOTH | G4P.SCROLLBARS_AUTOHIDE);
  display.setFont(UI_font2);
  display.setTextEditEnabled(false);
  
  String[] contents = loadStrings(file_name_user_notice); // the user notice is stored in a text file
  String str = "";

  for (String s : contents)
  {
    str += s + "\n";
  }

  display.setText(str);
}


public void notice_window_draw(PApplet appc, GWinData data)
{
  // just draw the title of the window

  appc.background(dark_col);
  fill(text_col);
  appc.textFont(createFont("Segoe UI Bold", 30));
  appc.textAlign(CENTER, TOP);
  appc.text("User Notice", appc.width/2, 10);
}


public void notice_window_close(GWindow window)
{
  hp.notice_window.dispose(); // also dispose the controls on itself
  hp.notice_window = null;
}
