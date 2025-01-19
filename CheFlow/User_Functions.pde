
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
    recipe_obj.setInt("duration", r.duration);

    JSONArray ingredients_array = new JSONArray();
    for (IngredientStatus ing_status : r.ingredients)
    {
      JSONObject ingredient_obj = new JSONObject();
      ingredient_obj.setString("name", ing_status.ingredient.name);
      ingredient_obj.setBoolean("is_essential", ing_status.is_essential);
      ingredients_array.append(ingredient_obj);
    }

    recipe_obj.setJSONArray("ingredients", ingredients_array);
    recipes_array.append(recipe_obj);
  }


  try
  {
    saveJSONArray(recipes_array, file_name_recipes);
    // println("Recipes saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving recipes");
  }
}


void import_recipes()
{
  JSONArray recipes_array = loadJSONArray(file_name_recipes);

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
    r.id = recipe_obj.getInt("id");
    r.duration = recipe_obj.getInt("duration");
    
    if (r.id >= recipe_id)
    {
      recipe_id = r.id + 1;
    }

    JSONArray ingredients_array = recipe_obj.getJSONArray("ingredients");
    for (int j = 0; j < ingredients_array.size(); j++)
    {
      JSONObject ingredient_obj = ingredients_array.getJSONObject(j);
      Ingredient ing = new Ingredient(ingredient_obj.getString("name"));
      boolean is_essential = ingredient_obj.getBoolean("is_essential");
      
      r.add_ingredient(ing, is_essential);
    }

    recipes.add(r);
  }

  search_results.clear();
  search_results.addAll(recipes);
  sort_recipes(1);
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
    saveJSONArray(fridge_array, file_name_fridge);
    // println("Fridge saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving fridge");
  }

}


void import_fridge()
{
  JSONArray fridge_array = loadJSONArray(file_name_fridge);

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


void export_logs()
{
  JSONArray activities_array = new JSONArray();

  for (Log l : log_records)
  {
    JSONObject log_obj = new JSONObject();

    log_obj.setString("name", (l.recipe != null) ? l.recipe.name : l.name);
    log_obj.setString("time finished", l.time_finished.get_time_str());
    log_obj.setInt("duration", l.duration);

    activities_array.append(log_obj);
  }

  try
  {
    saveJSONArray(activities_array, file_name_logs);
    // println("Activities saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving logs");
  }
}


void import_logs()
{
  JSONArray activities_array = loadJSONArray(file_name_logs);

  if (activities_array == null)
  {
    println("Error loading logs");
    return;
  }

  log_records.clear();

  for (int i = 0; i < activities_array.size(); i++)
  {
    JSONObject log_obj = activities_array.getJSONObject(i);
    Log l = new Log();
    
    String name = log_obj.getString("name");

    for (Recipe r : recipes)
    {
      if (r.name.equals(name))
      {
        l.recipe = r;
        break;
      }
    }

    if (validate_time_str(log_obj.getString("time finished")) != 0)
    {
      continue;
    }
    else
    {
      l.time_finished = new Time(log_obj.getString("time finished"));
    }
    
    l.duration = constrain(log_obj.getInt("duration"), 1, 24 * 60);

    log_records.add(l);
  }

  sort_log_records();
  
  println(log_records.size() + " activities loaded successfully");
}


void export_data()
{
  export_recipes();
  export_fridge();
  export_logs();

  // println("Data saved successfully");
}


void import_data()
{
  import_recipes();
  import_fridge();
  import_logs();
}


void update_daily_durations()
{
  Time now = new Time();

  daily_durations = new ArrayList<>(Collections.nCopies(365, 0));

  for (Log l : log_records)
  {
    Time time = l.time_finished;
    int days_ago = now.days_difference(time);

    if (days_ago >= 0 && days_ago < 365) 
    {
      daily_durations.set(365 - days_ago - 1, daily_durations.get(365 - days_ago - 1) + l.duration);
    }
  }
}


void initialize_fonts()
{
  G4P.setDisplayFont("Inter", G4P.PLAIN, 16);
  UI_font = new Font("Inter Display Medium", Font.PLAIN, 16);
  drawing_font = createFont("Inter Medium", 16);
}


void initialize_UI_colors()
{
  GCScheme.makeColorSchemes();
  GCScheme.changePaletteColor(GCScheme.BLUE_SCHEME, 2, #000000);
}


/* EVENT HANDLERS */
