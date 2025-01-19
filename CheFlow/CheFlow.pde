
/* 
	
	Software Name: CheFlow
	Author: Ricky Tang
	Date: January 24th, 2025
	Description:

*/

/* PACKAGES */

import g4p_controls.*;
import java.util.*;
import java.awt.Font;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/* GLOBAL VARIABLES OR CONSTANTS */

final color accent_col = #9eef7b;
final color accent_col2 = #ff2984;
final color accent_col3 = #a5ff01;
final color dark_col = #1C1C1E;
final color text_col = #e4e4e4;
Font UI_font;
PImage logo;


ArrayList<Recipe> recipes = new ArrayList<Recipe>();
ArrayList<Recipe> search_results = new ArrayList<Recipe>();
ArrayList<Recipe> matching_results = new ArrayList<Recipe>();
ArrayList<Ingredient> fridge = new ArrayList<Ingredient>();
ArrayList<Log> log_records = new ArrayList<Log>();

ArrayList<Integer> daily_durations = new ArrayList<>();

final String file_name_recipes = "recipes.json";
final String file_name_fridge = "fridge.json";
final String file_name_logs = "logs.json";
boolean auto_save = false;

final float button_width = 300;
final float button_height = 40;
final float button_spacing = 10;
final float button_startX = 350;
final float button_startY = 200;

int layer = 0;
int[] page_nums = {0, 0, 0}; 
int[] total_page_nums = {0, 0, 0};
int buttons_per_page = 9;

Recipe current_r;
Ingredient current_ing;
Log current_log;

int recipe_id = 1, ingredient_id = 1;

Nav_Bar nb;
Page current_Page;
Recipes_Page rp;
Frige_Page fp;
Home_Page hp;
Matching_Page mp;
Activity_Page ap;


/* SETUP AND DRAW */

void setup() 
{
  size(1000, 700);
  G4P.messagesEnabled(false);
  import_data();
  initialize_fonts();
  initialize_UI_colors();
  
  nb = new Nav_Bar(this);
  rp = new Recipes_Page(this);
  fp = new Frige_Page(this);
  hp = new Home_Page(this);
  mp = new Matching_Page(this);
  ap = new Activity_Page(this);
  
  nb.setup();
  current_Page = hp;
  current_Page.setup();
  
}

void draw()
{
  background(dark_col);

  nb.draw();

  logo = loadImage("logo.png");
  logo.resize(0, 50);
  image(logo, 10, 5);
}

void exit()
{
  export_data();
  println("Data saved while exiting");
  super.exit();
}
