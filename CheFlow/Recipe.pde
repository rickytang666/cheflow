// This file contains the Recipe class, which is used to represent a recipe in the program. 

class Recipe
{
  /* FIELDS */

  int id;
  String name;
  int duration;
  ArrayList<IngredientStatus> ingredients;
  GButton button;
  GImageButton del_button;
  GTextField renamer;
  GTextField duration_editor;
  float matching_score; // aka recommendation mark, how well it matches the fridge items
  GLabel title_label, matching_score_label, duration_hint;

  /* CONSTRUCTORS */
  
  Recipe(String n)
  {
    this.id = recipe_id; // give a unique id and update the global id counter
    ++recipe_id;
    
    this.name = n;
    this.duration = 30; // 30 minutes by default
    this.matching_score = 0;
    
    this.ingredients = new ArrayList<IngredientStatus>(); // use the bundle not Ingredient class to enhance management
    
    this.button = null;
    this.del_button = null;
    this.renamer = null;
    this.duration_editor = null;
    this.title_label = null;
    this.matching_score_label = null;
  }

  /* METHODS */

  void add_ingredient(Ingredient ing)
  {
    this.ingredients.add(0, new IngredientStatus(ing));
  }


  void add_ingredient(Ingredient ing, boolean is_essential)
  {
    // add by pushing front

    this.ingredients.add(0, new IngredientStatus(ing, is_essential));
  }


  void delete_ingredient(int index)
  {
    if (index < 0 || index >= this.ingredients.size())
    {
      // handling invalid index

      return;
    }
    else
    {
      // delete the ingredient status and dispose its controls

      IngredientStatus ing_status = this.ingredients.get(index);
      ing_status.dispose_controls();
      this.ingredients.remove(index);
    }
  }


  void set_matching_score()
  {
    this.matching_score = 0;
    int essential_matched = 0, other_matched = 0;
    int total_essentials = 0, total_others = 0;

    if (this.ingredients.size() == 0)
    {
      // rare case, no ingredients needed, only 100% match

      this.matching_score = 100;
      return;
    }

    // Loop through the ingredients and check if they are in the fridge (essential & not essential)

    for (IngredientStatus ing_status : this.ingredients)
    {
      if (ing_status.is_essential)
      {
        ++total_essentials;

        for (Ingredient fridge_ing : fridge)
        {
          if (ing_status.ingredient.name.equals(fridge_ing.name))
          {
            ++essential_matched;
            break;
          }
        }

      }
      else
      {
        ++total_others;

        for (Ingredient fridge_ing : fridge)
        {
          if (ing_status.ingredient.name.equals(fridge_ing.name))
          {
            ++other_matched;
            break;
          }
        }

      }
    }

    // Calculate the matching score based on the matched ingredients

    if (essential_matched == 0 && other_matched == 0)
    {
      this.matching_score = 0;
      return;
    }

    float time_score = 100;

    // if the duration is longer than the demand, the score will be reduced

    if (this.duration > duration_demand)
    {
      time_score -= 2 * (this.duration - duration_demand);
    }

    time_score = max(0, time_score); // make sure it's not negative

    // calculate the completion score (80% essential, 20% other)
    
    float completion_score = 50;

    if (total_essentials <= 0)
    {
      completion_score = 100.0 * (float)other_matched / (float)total_others;
    }
    else
    {
      float essential_score = 100.0 * (float)essential_matched / (float)total_essentials;
      float other_score = 100.0 * (float)other_matched / (float)total_others;
      completion_score = essential_score * 0.8 + other_score * 0.2;
    }

    // calculate the final matching score (80% completion, 20% time) or (80% time, 20% completion)

    if (time_priority)
    {
      this.matching_score = time_score * 0.8 + completion_score * 0.2;
    }
    else
    {
      this.matching_score = completion_score * 0.8 + time_score * 0.2;
    }
    
  }


  void dispose_controls()
  {
    // dispose all the controls it has to fully clear itself

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

    if (this.renamer != null)
    {
      this.duration_editor.dispose();
    }

    if (this.title_label != null)
    {
      this.title_label.dispose();
    }

    if (this.matching_score_label != null)
    {
      this.matching_score_label.dispose();
    }

    if (this.duration_hint != null)
    {
      this.duration_hint.dispose();
    }
  }


  void delete()
  {

    // remove it from global array and dispose all the controls
    // unlink all the linked objects (e.g. logs)
    
    recipes.remove(this);

    for (Log l : log_records)
    {
      if (l.recipe == this)
      {
        l.recipe = null;
      }
    }
    
    dispose_controls();
  }
}
