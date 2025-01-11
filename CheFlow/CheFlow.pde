
/* 
	
	Software Name: CheFlow
	Author: Ricky Tang
	Date: January 24th, 2025
	Description:

*/

/* PACKAGES */

import g4p_controls.*;

/* GLOBAL VARIABLES OR CONSTANTS */

final color accent_col = #6be76b;
ArrayList<Recipe> recipes = new ArrayList<Recipe>();
ArrayList<Recipe> search_results = new ArrayList<Recipe>();

final String file_name_recipes = "recipes.json";

final float buttonWidth = 300;
final float buttonHeight = 40;
final float buttonSpacing = 10;
final float buttonStartX = 350;
final float buttonStartY = 200;

int recipe_id = 1, ingredient_id = 1;
Recipe current_r;
Ingredient current_ing;


/* SETUP AND DRAW */

void setup() 
{
  size(1000, 700);
  
  set_nav_gui(); 
  import_recipes();
}

void draw()
{
  background(220);
}
