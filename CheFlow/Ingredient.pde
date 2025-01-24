// This file contains Ingredient and IngredientStatus classes, which are used to store and manage the ingredients and their essential status in the program. 
// The Ingredient class contains the name of the ingredient, a list of related recipes, and the GUI elements associated with the ingredient. 
// The IngredientStatus class is a bundle

class Ingredient
{

  /* FIELDS */
  
  String name;

  ArrayList<String> related_recipes; // for displaying the related recipes, constantly updating

  GButton button;
  GImageButton del_button;
  GLabel label;
  GTextField renamer;
  ArrayList<GLabel> recipe_labels;

  /* CONSTRUCTORS */
  
  Ingredient(String n)
  {
    this.name = n.toLowerCase(); // case insensitive for ingredients
    this.related_recipes = new ArrayList<String>();
    this.button = null;
    this.del_button = null;
    this.label = null;
    this.renamer = null;
    this.recipe_labels = new ArrayList<GLabel>();
  }

  /* METHODS */

  void set_name(String n)
  {
    this.name = n.toLowerCase();
  }

  void set_contents()
  {
    // fill out the related recipes array using the global function

    this.related_recipes = get_related_recipes(this.name);
  }

  void dispose_controls()
  {
    // dispose all the controls it has

    if (this.button != null)
    {
      this.button.dispose();
    }

    if (this.del_button != null)
    {
      this.del_button.dispose();
    }

    if (this.label != null)
    {
      this.label.dispose();
    }

    if (this.renamer != null)
    {
      this.renamer.dispose();
    }

    for (GLabel l : this.recipe_labels)
    {
      if (l != null)
      {
        l.dispose();
      }
    }
  }

}


// Essentially a bundle (ingredient + essential data & control)

class IngredientStatus
{  

  Ingredient ingredient;
  boolean is_essential;

  GOption essential_toggle;

  IngredientStatus(Ingredient ing)
  {
    this.ingredient = ing;
    this.is_essential = false;
  }

  IngredientStatus(Ingredient ing, boolean ess)
  {
    this.ingredient = ing;
    this.is_essential = ess;
  }

  void dispose_controls()
  {
    // dispose all the controls it has, and the ingredient's
    
    if (this.essential_toggle != null)
    {
      this.essential_toggle.dispose();
    }

    this.ingredient.dispose_controls();
  }
}
