
class Recipe
{
  String name;
  ArrayList<Ingredient> ingredients;
  GButton button;
  
  Recipe(String n)
  {
    this.name = n;
    this.ingredients = new ArrayList<Ingredient>();
    
    for (int i = 0; i < 50; ++i)
    {
      Ingredient ing = new Ingredient("Ingredient " + str(i));
      this.ingredients.add(ing);
    }
    
    this.button = null;
  }
}
