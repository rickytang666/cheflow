
class Recipe
{
  /* FIELDS */

  int id;
  String name;
  int duration;
  ArrayList<Ingredient> ingredients;
  GButton button;
  GButton del_button;
  GTextField renamer;
  GTextField duration_editor;

  /* CONSTRUCTORS */
  
  Recipe(String n)
  {
    this.id = recipe_id;
    ++recipe_id;
    
    this.name = n;
    this.duration = 30;
    
    this.ingredients = new ArrayList<Ingredient>();
    
    this.button = null;
    this.del_button = null;
    this.renamer = null;
    this.duration_editor = null;
  }

  /* METHODS */

  void add_ingredient(Ingredient ing)
  {
    this.ingredients.add(ing);
  }

  void delete_ingredient(int index)
  {
    if (index < 0 || index >= this.ingredients.size())
    {
      return;
    }
    else
    {
      Ingredient ing = this.ingredients.get(index);
      ing.dispose_controls();
      this.ingredients.remove(index);
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

    if (this.renamer != null)
    {
      this.renamer.dispose();
    }

    if (this.renamer != null)
    {
      this.duration_editor.dispose();
    }
  }

  void delete()
  {
    recipes.remove(this);
    
    dispose_controls();
  }
}
