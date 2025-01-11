
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

int layer = 0;
int[] currentPages = {0, 0, 0}; 
int[] totalPages = {0, 0, 0};
int buttonsPerPage = 9;

Recipe current_r;
Ingredient current_ing;

int recipe_id = 1, ingredient_id = 1;

Nav_Bar nb;
Page current_page;
Recipes_Page rp;
Frige_Page fp;
Home_Page hp;
Matching_Page mp;


/* SETUP AND DRAW */

void setup() 
{
  size(1000, 700);
  G4P.messagesEnabled(false);
  import_recipes();
  
  nb = new Nav_Bar(this);
  rp = new Recipes_Page(this);
  fp = new Frige_Page(this);
  hp = new Home_Page(this);
  mp = new Matching_Page(this);
  
  nb.setup();
  current_page = hp;
  current_page.setup();
  
}

void draw()
{
  background(220);
}
