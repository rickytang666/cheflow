
class Ingredient
{

  /* FIELDS */
  
  String name;
  String content;

  ArrayList<Recipe> related_recipes;

  GButton button;
  GButton del_button;
  GLabel label;
  GTextField renamer;

  /* CONSTRUCTORS */
  
  Ingredient(String n)
  {

    this.name = n.toLowerCase();

    this.related_recipes = new ArrayList<Recipe>();
    
    set_contents();    
    
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
    this.content = "";
    
    for (int i = 0; i < related_recipes.size(); ++i)
    {
      this.content += related_recipes.get(i).name + "\n";
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
