
class Recipe
{
  /* FIELDS */

  final int id;
  String name;
  ArrayList<Ingredient> ingredients;
  GButton button;
  GButton del_button;
  GTextField renamer;

  /* CONSTRUCTORS */
  
  Recipe(String n)
  {
    this.id = recipe_id;
    ++recipe_id;
    
    this.name = n;
    
    this.ingredients = new ArrayList<Ingredient>();
    
    this.button = null;
    this.del_button = null;
    this.renamer = null;
  }

  /* METHODS */

  void add_ingredient(Ingredient ing)
  {

    if (!ingredient_map.containsKey(ing.name))
    {
      println("No duplicates");
      ingredient_map.put(ing.name, ing);
      library_ingredients.add(ing);
    }
    else
    {
      println("Duplicate ingredient: " + ing.name);
      ing = ingredient_map.get(ing.name);
    }

    this.ingredients.add(ing);
    ing.related_recipes.add(this);
    ing.set_contents();
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
      ing.related_recipes.remove(this);
      ing.set_contents();
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
  }

  void delete()
  {
    recipes.remove(this);

    for (Ingredient ing : this.ingredients)
    {
      ing.related_recipes.remove(this);
      ing.set_contents();
    }
    
    dispose_controls();
  }
}
