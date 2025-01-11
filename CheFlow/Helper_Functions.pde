
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


void sort_recipes(int option)
{
  /*
  1: Sort by id (descending)
  2: Sort by id (ascending)
  3: Sort by name (alphabetical)
  */

  if (option == 1)
  {
    search_results.sort((a, b) -> b.id - a.id);
  }
  else if (option == 2)
  {
    search_results.sort((a, b) -> a.id - b.id);
  }
  else if (option == 3)
  {
    search_results.sort((a, b) -> a.name.compareTo(b.name));
  }
}


ArrayList<Recipe> get_related_recipes(String name)
{
  ArrayList<Recipe> related_recipes = new ArrayList<Recipe>();

  // println("Searching for recipes using ingredient: " + name);
  for (Recipe r : recipes)
  {
    // println("Checking recipe: " + r.name);
    for (Ingredient ing : r.ingredients)
    {
      // println("Checking ingredient: " + ing.name);
      if (ing.name.equals(name))
      {
        // println("Found in recipe: " + r.name);
        related_recipes.add(r);
        break;
      }
    }
  }

  return related_recipes;
}


void fill_search_results(String search)
{
  search_results.clear();

  if (search.equals(""))
  {
    search_results.addAll(recipes);
  }
  else
  {
    for (Recipe r : recipes)
    {
      if (r.name.toLowerCase().contains(search.toLowerCase()))
      {
        // println("Found recipe: " + r.name);
        search_results.add(r);
      }
      else
      {
        // println(r.name, "does not contain", search);
      }
    }
  }
  
  
}
