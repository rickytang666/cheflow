Boolean name_is_repeated(String name, int option)
{
  return name_is_repeated(name, option, null);
}


Boolean name_is_repeated(String name, int option, Recipe r)
{
  /* 
    option 0: check recipe names
    option 1: check ingredient names
  */

  if (option == 0)
  {
    for (Recipe rec : recipes)
    {
      if (rec.name.equals(name))
      {
        return true;
      }
    }
  }
  else if (option == 1)
  {
    for (Ingredient ing : r.ingredients)
    {
      if (ing.name.equals(name))
      {
        return true;
      }
    }
  }

  return false;

}


ArrayList<Recipe> get_related_recipes(String name)
{
  ArrayList<Recipe> related_recipes = new ArrayList<Recipe>();

  println("Searching for recipes using ingredient: " + name);
  for (Recipe r : recipes)
  {
    println("Checking recipe: " + r.name);
    for (Ingredient ing : r.ingredients)
    {
      println("Checking ingredient: " + ing.name);
      if (ing.name.equals(name))
      {
        println("Found in recipe: " + r.name);
        related_recipes.add(r);
        break;
      }
    }
  }

  return related_recipes;
}
