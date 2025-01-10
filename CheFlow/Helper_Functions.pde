Boolean name_is_repeated(String name, int option)
{
  /* 
    option 0: check recipe names
    option 1: check ingredient names
  */

  if (option == 0)
  {
    for (Recipe r : recipes)
    {
      if (r.name.equals(name))
      {
        return true;
      }
    }
  }
  else if (option == 1)
  {
    for (Ingredient ing : library_ingredients)
    {
      if (ing.name.equals(name))
      {
        return true;
      }
    }
  }

  return false;

}