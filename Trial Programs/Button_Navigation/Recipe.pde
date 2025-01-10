
class Recipe
{
  String name;
  int id;
  ArrayList<Ingredient> ingredients;
  GButton button;
  GTextField renamer;
  
  Recipe(String n)
  {
    this.name = n;
    this.id = ingredientID;
    ++ingredientID;
    this.ingredients = new ArrayList<Ingredient>();
    
    for (int i = 1; i < 51; ++i)
    {
      Ingredient ing = new Ingredient("Ingredient " + str(i));
      this.ingredients.add(ing);
    }
    
    this.button = null;
    this.renamer = null;
  }
}
