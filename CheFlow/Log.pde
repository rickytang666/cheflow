// This file contains the Log class, which is used to store and manage the logs of the user's cooking activities.

class Log
{
  /* FIELDS */

  Recipe recipe;
  String name;
  Time time_finished;
  int duration;

  GButton button;
  GImageButton del_button;
  GLabel recipe_label;

  /* CONSTRUCTORS */

  Log()
  {
    this.recipe = null;
    this.name = "Custom cooking"; // default name, used when the user doesn't select a recipe
    this.time_finished = new Time(); // default time is now
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


  // Function to dispose all controls it has, to make sure it's gui is clean

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
    // remove from the log records data structure, and dispose all of the controls

    log_records.remove(this);

    dispose_controls();
  }

}