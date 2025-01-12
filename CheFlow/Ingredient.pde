
class Ingredient
{

  /* FIELDS */
  
  String name;
  String content;

  GButton button;
  GButton del_button;
  GLabel label;
  GTextField renamer;

  /* CONSTRUCTORS */
  
  Ingredient(String n)
  {

    this.name = n.toLowerCase(); 
    this.content = "";
    this.button = null;
    this.del_button = null;
    this.label = null;
    this.renamer = null;
  }

  /* METHODS */

  void set_name(String n)
  {
    this.name = n.toLowerCase();
  }

  void set_contents()
  {
    this.content = "This ingredient is used in the following recipes:\n\n";

    ArrayList<Recipe> related_recipes = get_related_recipes(this.name);

    if (related_recipes.isEmpty())
    {
      this.content += "None\n";
    }

    for (Recipe r : related_recipes)
    {
      this.content += r.name + "\n";
    }

    if (this.label != null)
    {
      this.label.setText(this.content);
    }
  }

  void dispose_controls()
  {
    if (this.button != null)
    {
      this.button.dispose();
    }

    if (this.del_button != null)
    {
      this.del_button.dispose();
    }

    if (this.label != null)
    {
      this.label.dispose();
    }

    if (this.renamer != null)
    {
      this.renamer.dispose();
    }
  }

}
