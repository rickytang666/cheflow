
/* GLOBAL VARIABLES OR CONSTANTS */


/* FUNCTIONS */

void export_recipes()
{
  JSONArray recipes_array = new JSONArray();

  for (Recipe r : recipes)
  {
    JSONObject recipe_obj = new JSONObject();
    recipe_obj.setInt("id", r.id);
    recipe_obj.setString("name", r.name);

    JSONArray ingredients_array = new JSONArray();
    for (Ingredient ing : r.ingredients)
    {
      JSONObject ingredient_obj = new JSONObject();
      ingredient_obj.setString("name", ing.name);
      ingredients_array.append(ingredient_obj);
    }

    recipe_obj.setJSONArray("ingredients", ingredients_array);
    recipes_array.append(recipe_obj);
  }


  try
  {
    saveJSONArray(recipes_array, "recipes.json");
    println("Recipes saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving recipes");
  }
}


void import_recipes()
{
  JSONArray recipes_array = loadJSONArray("recipes.json");

  if (recipes_array == null)
  {
    println("Error loading recipes");
    return;
  }

  recipes.clear();

  for (int i = 0; i < recipes_array.size(); i++)
  {
    JSONObject recipe_obj = recipes_array.getJSONObject(i);
    Recipe r = new Recipe(recipe_obj.getString("name"));

    JSONArray ingredients_array = recipe_obj.getJSONArray("ingredients");
    for (int j = 0; j < ingredients_array.size(); j++)
    {
      JSONObject ingredient_obj = ingredients_array.getJSONObject(j);
      Ingredient ing = new Ingredient(ingredient_obj.getString("name"));
      
      r.add_ingredient(ing);
    }

    recipes.add(r);
  }

  search_results.clear();
  search_results.addAll(recipes);
  sort_recipes(2);
  println(recipes.size() + " recipes loaded successfully");
  
}


void export_fridge()
{
  JSONArray fridge_array = new JSONArray();

  for (Ingredient ing : fridge)
  {
    JSONObject ingredient_obj = new JSONObject();
    ingredient_obj.setString("name", ing.name);
    fridge_array.append(ingredient_obj);
  }

  try
  {
    saveJSONArray(fridge_array, "fridge.json");
    println("Fridge saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving fridge");
  }

}


void import_fridge()
{
  JSONArray fridge_array = loadJSONArray("fridge.json");

  if (fridge_array == null)
  {
    println("Error loading fridge");
    return;
  }

  fridge.clear();
  HashMap<String, Ingredient> ing_map = new HashMap<String, Ingredient>();

  for (int i = 0; i < fridge_array.size(); i++)
  {
    JSONObject ingredient_obj = fridge_array.getJSONObject(i);
    String name = ingredient_obj.getString("name");
    
    if (!ing_map.containsKey(name))
    {
      Ingredient ing = new Ingredient(name);
      fridge.add(ing);
      ing_map.put(name, ing);
    }
  }

  println(fridge.size() + " ingredients loaded successfully");
  
}


void export_data()
{
  export_recipes();
  export_fridge();
}


void import_data()
{
  import_recipes();
  import_fridge();
}


/* EVENT HANDLERS */
