
class Log
{
  /* FIELDS */

  Recipe recipe;
  String recipe_name;
  Time time_finished;
  int duration;

  GButton button, del_button;
  GLabel recipe_label;

  /* CONSTRUCTORS */

  Log()
  {
    this.recipe = null;
    this.recipe_name = "Custom cooking";
    this.time_finished = new Time();
    this.duration = 1;

    this.button = null;
    this.del_button = null;
    this.recipe_label = null;

  }

  /* METHODS */

  void set_recipe(Recipe r)
  {
    this.recipe = r;
  }


  void dispose_controls()
  {
    if (button != null)
    {
      button.dispose();
    }

    if (del_button != null)
    {
      del_button.dispose();
    }

    if (recipe_label != null)
    {
      recipe_label.dispose();
    }
  }


  void delete()
  {
    log_records.remove(this);

    dispose_controls();
  }

}