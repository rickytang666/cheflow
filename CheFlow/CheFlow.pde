
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
final float buttonWidth = 300;
final float buttonHeight = 40;
final float buttonSpacing = 10;
final float buttonStartX = 350;
final float buttonStartY = 100;
int recipeID = 1;
Recipe currentR;
Ingredient currentIngredient;


/* SETUP AND DRAW */

void setup() 
{
  size(1000, 700);
  
  for (int i = 1; i <= 50; i++) {
    Recipe r = new Recipe("Recipe " + i);
    recipes.add(r);
  }

  totalPages[0] = (int) ceil((float) recipes.size() / buttonsPerPage);
  
  set_nav_gui(); 
  set_recipes_page();
}

void draw()
{
  background(220);
}