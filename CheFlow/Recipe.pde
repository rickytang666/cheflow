
class Recipe
{
  /* FIELDS */

  int id;
  String name;
  int duration;
  ArrayList<Ingredient> ingredients;
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
    
    this.ingredients = new ArrayList<Ingredient>();
    
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
    this.ingredients.add(0, ing);
  }

  void delete_ingredient(int index)
  {
    if (index < 0 || index >= this.ingredients.size())
    {
      return;
    }
    else
    {
      Ingredient ing = this.ingredients.get(index);
      ing.dispose_controls();
      this.ingredients.remove(index);
    }
  }


  void set_matching_score()
  {
    this.matching_score = 0;
    int num_matched = 0;

    if (this.ingredients.size() == 0)
    {
      this.matching_score = 100;
      return;
    }

    for (Ingredient ing : this.ingredients)
    {
      for (Ingredient fridge_ing : fridge)
      {
        if (ing.name.equals(fridge_ing.name))
        {
          ++num_matched;
          break;
        }
      }
    }

    this.matching_score = 100.0 * ((float) num_matched / this.ingredients.size());
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
