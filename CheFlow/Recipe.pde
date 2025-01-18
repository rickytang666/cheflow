
class Recipe
{
  /* FIELDS */

  int id;
  String name;
  int duration;
  ArrayList<IngredientStatus> ingredients;
  GButton button;
  GButton del_button;
  GTextField renamer;
  GTextField duration_editor;

  float matching_score;
  GLabel title_label, matching_score_label;

  /* CONSTRUCTORS */
  
  Recipe(String n)
  {
    this.id = recipe_id;
    ++recipe_id;
    
    this.name = n;
    this.duration = 30;
    this.matching_score = 0;
    
    this.ingredients = new ArrayList<IngredientStatus>();
    
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
    this.ingredients.add(0, new IngredientStatus(ing, is_essential));
  }


  void delete_ingredient(int index)
  {
    if (index < 0 || index >= this.ingredients.size())
    {
      return;
    }
    else
    {
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
      this.matching_score = 100;
      return;
    }

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

    if (total_essentials <= 0)
    {
      this.matching_score = 100.0 * (float)other_matched / (float)total_others;
      return;
    }

    float essential_score = 100.0 * (float)essential_matched / (float)total_essentials;
    float other_score = 100.0 * (float)other_matched / (float)total_others;
    this.matching_score = essential_score * 0.8 + other_score * 0.2;
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
  }


  void delete()
  {
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
