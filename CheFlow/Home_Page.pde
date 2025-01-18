
/** HOME PAGE CLASS **/

class Home_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  GLabel title, insights;
  GButton export_button, graph_button, heatmap_button;
  GOption autosave_toggle;
  GDropList days_droplist, regression_droplist;
  GWindow graph_window, heatmap_window;

  int num_past_days = 14;
  String regression_type = "linear";

  /* CONSTRUCTORS */

  Home_Page(PApplet p)
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

    update_daily_durations();

    set_static_gui();
  }


  void die()
  {
    // println(controls.size());
    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
      }
    }
  }

  /* ADDITIONAL METHODS */

  void set_static_gui()
  {
    title = new GLabel(parent, width/2 - 150, 70, 300, 40, "HOME PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setTextBold();
    title.setTextItalic();
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    autosave_toggle = new GOption(parent, 400, 150, 200, 40, "Auto Save");
    autosave_toggle.setSelected(auto_save);
    autosave_toggle.addEventHandler(parent, "autosave_toggle_handler");

    export_button = new GButton(parent, 400, 200, 200, 40, "Export Data");
    export_button.addEventHandler(parent, "export_button_handler");

    graph_button = new GButton(parent, 400, 250, 200, 40, "View Graph");
    graph_button.addEventHandler(parent, "graph_button_handler");

    days_droplist = new GDropList(parent, 650, 250, 150, 150, 3);
    String[] items = {"Past 7 days", "Past 14 Days", "Past 30 days", "Past 100 days", "Past 365 days"};
    days_droplist.setItems(items, 1);
    days_droplist.addEventHandler(parent, "days_droplist_handler");

    regression_droplist = new GDropList(parent, 820, 250, 150, 150, 3);
    String[] items2 = {"linear", "quadratic", "exponential"};
    regression_droplist.setItems(items2, 0);
    regression_droplist.addEventHandler(parent, "regression_droplist_handler");

    heatmap_button = new GButton(parent, 400, 300, 200, 40, "View Heatmap");
    heatmap_button.addEventHandler(parent, "heatmap_button_handler");

    insights = new GLabel(parent, 300, 300, 500, 300);

    String str = "Insights:\n";

    str += "You spend " + nf(get_average_duration(7), 0, 2) + " minutes on average cooking in the past 7 days.\n";
    str += "You spend " + nf(get_average_duration(30), 0, 2) + " minutes on average cooking in the past 30 days.\n";
    str += "You spend " + nf(get_average_duration(365), 0, 2) + " minutes on average cooking in the past year.\n";
    str += "Your longest streak is " + get_longest_streak() + " days.\n";

    insights.setText(str);

    static_controls.add(title);
    static_controls.add(autosave_toggle);
    static_controls.add(export_button);
    static_controls.add(graph_button);
    static_controls.add(days_droplist);
    static_controls.add(regression_droplist);
    static_controls.add(heatmap_button);
    static_controls.add(insights);
  }
}

/* EVENT HANDLERS */

public void autosave_toggle_handler(GOption option, GEvent event)
{

  if (event == GEvent.SELECTED)
  {
    auto_save = true;
  }
  else if (event == GEvent.DESELECTED)
  {
    auto_save = false;
  }
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
  hp.graph_window = GWindow.getWindow(this, "Graph", 200, 150, 1200, 600, JAVA2D);
  hp.graph_window.addDrawHandler(this, "graph_window_draw");
  hp.graph_window.addOnCloseHandler(this, "graph_window_close");
  hp.graph_window.setActionOnClose(G4P.CLOSE_WINDOW);
}


public void graph_window_draw(PApplet appc, GWinData data)
{
  draw_scatter_plot(appc, hp.num_past_days, hp.regression_type);
}


public void graph_window_close(GWindow window)
{
  hp.graph_window.dispose();
  hp.graph_window = null;
}


public void days_droplist_handler(GDropList droplist, GEvent event)
{
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
