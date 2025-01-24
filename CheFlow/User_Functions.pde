
/* DATA IMPORT/EXPORT RELATED */

void export_recipes()
{
  JSONArray recipes_array = new JSONArray();

  for (Recipe r : recipes)
  {
    // create a JSON object for each recipe, put in the necessary fields

    JSONObject recipe_obj = new JSONObject();
    recipe_obj.setString("name", r.name);
    recipe_obj.setInt("id", r.id);
    recipe_obj.setInt("duration", r.duration);

    // assign a JSON array for the ingredients of the recipe, append the recipe into big array

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

  // export the whole array into the file (given the file name)

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
    // probably the file does not exist, or it is empty

    println("Error loading recipes");
    return;
  }

  recipes.clear(); // start with empty list

  for (int i = 0; i < recipes_array.size(); i++)
  {
    JSONObject recipe_obj = recipes_array.getJSONObject(i);

    // interpret the JSON object, create a recipe object, and add it to the list

    Recipe r = new Recipe(recipe_obj.getString("name"));
    r.id = recipe_obj.getInt("id");
    r.duration = recipe_obj.getInt("duration");
    
    if (r.id >= recipe_id)
    {
      recipe_id = r.id + 1; // update the global id with the largest id so far (eliminate the possibility of repeating)
    }

    // import the json array of ingredients, create ingredient objects, and add them to the recipe

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

  // update the search results with the recipes for future use

  search_results.clear();
  search_results.addAll(recipes);
  sort_recipes(1); // sort recipes by descending id
  println(recipes.size() + " recipes loaded successfully");
  
}


void export_fridge()
{
  JSONArray fridge_array = new JSONArray();

  // add all the ingredients in the fridge to the JSON array

  for (Ingredient ing : fridge)
  {
    JSONObject ingredient_obj = new JSONObject();
    ingredient_obj.setString("name", ing.name);
    fridge_array.append(ingredient_obj);
  }

  // save the JSON array into the file

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

    // probably the file does not exist, or it is empty

    println("Error loading fridge");
    return;
  }

  fridge.clear(); // start it with a clean slate

  HashMap<String, Ingredient> ing_map = new HashMap<String, Ingredient>();

  // use a hashmap to keep track of the ingredients that are already in the fridge, and avoid duplicates

  for (int i = 0; i < fridge_array.size(); i++)
  {
    JSONObject ingredient_obj = fridge_array.getJSONObject(i);
    String name = ingredient_obj.getString("name");
    
    if (!ing_map.containsKey(name)) // check if this is a brand new ingredient
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

    // only put in necessary fields, and use the default name if the recipe is not available

    log_obj.setString("name", (l.recipe != null) ? l.recipe.name : l.name); // if it doesn't have a recipe, use the default name field
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
    // probably the file does not exist, or it is empty

    println("Error loading logs");
    return;
  }

  log_records.clear(); // start with a clean slate

  for (int i = 0; i < activities_array.size(); i++)
  {
    JSONObject log_obj = activities_array.getJSONObject(i);
    Log l = new Log(); // when in constructor, it already has a default name
    
    String name = log_obj.getString("name"); // get the name of the recipe or the default name

    // find out any linked recipe, if not, don't need anything since we already have default name

    for (Recipe r : recipes)
    {
      if (r.name.equals(name))
      {
        l.recipe = r;
        break;
      }
    }

    // double check if the time string is valid, if so, interpret it and assign it to the log object

    if (validate_time_str(log_obj.getString("time finished")) != 0)
    {
      continue;
    }
    else
    {
      l.time_finished = new Time(log_obj.getString("time finished"));
    }

    // interpret the duration value and constrain it to a valid range
    
    l.duration = constrain(log_obj.getInt("duration"), 1, 24 * 60);

    log_records.add(l);
  }

  sort_log_records(); // sort the log records by the time finished (newest first)
  
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


/* USER DATA STRUCTURE RELATED */

// Function for populating the duration of cooking in the past 365 days based on the log records array

void update_daily_durations()
{
  Time now = new Time();

  daily_durations = new ArrayList<>(Collections.nCopies(365, 0)); // using nCopies to initialize the list with all 0s

  for (Log l : log_records)
  {
    Time time = l.time_finished;

    // check if the log record is within the past year, if so, update the daily duration list accordingly

    int days_ago = now.days_difference(time);

    if (days_ago >= 0 && days_ago < 365) 
    {
      daily_durations.set(365 - days_ago - 1, daily_durations.get(365 - days_ago - 1) + l.duration);
    }
  }
}


/* UI RELATED */


void initialize_fonts()
{
  G4P.setDisplayFont("Segoe UI", G4P.PLAIN, 17); // set all controls display like this (we can still customize them if we want)
  UI_font1 = new Font("Segoe UI Semibold", Font.PLAIN, 17); // slightly more bolded one
  UI_font2 = new Font("Segoe UI", Font.PLAIN, 17); // normal font weight one
  drawing_font = createFont("Segoe UI", 17); // for the graphs/maps
}


void initialize_UI_colors()
{
  GCScheme.makeColorSchemes(); // initialize the color schemes
  
  // we change the blue scheme because blue scheme is the default one
  
  GCScheme.changePaletteColor(GCScheme.BLUE_SCHEME, 2, #000000); // change the text color to black rather than dark blue
}
