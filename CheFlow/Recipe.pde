
class Recipe
{
  /* FIELDS */

  String name;
  int id;
  ArrayList<Ingredient> ingredients;
  GButton button;
  GButton del_button;
  GTextField renamer;

  /* CONSTRUCTORS */
  
  Recipe(String n)
  {
    this.name = n;
    this.id = recipeID;
    ++recipeID;
    this.ingredients = new ArrayList<Ingredient>();
    
    for (int i = 1; i < 51; ++i)
    {
      Ingredient ing = new Ingredient("Ingredient " + str(i));
      this.ingredients.add(ing);
    }
    
    this.button = null;
    this.del_button = null;
    this.renamer = null;
  }

  /* METHODS */

  void delete()
  {
    recipes.remove(this);
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
  }
}
