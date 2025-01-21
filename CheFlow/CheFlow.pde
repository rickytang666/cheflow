
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
import java.lang.NullPointerException;

/* GLOBAL VARIABLES OR CONSTANTS */

final color accent_col = #9eef7b;
final color accent_col2 = #ff2984;
final color accent_col3 = #a5ff01;
final color dark_col = #1C1C1E;
final color text_col = #e4e4e4;
Font UI_font1; // slightly bolder one
Font UI_font2; // normal font weight one
PFont drawing_font;
PImage logo;
String greeting_text = "Good Morning";

ArrayList<Recipe> recipes = new ArrayList<Recipe>();
ArrayList<Recipe> search_results = new ArrayList<Recipe>();
ArrayList<Recipe> matching_results = new ArrayList<Recipe>();
ArrayList<Ingredient> fridge = new ArrayList<Ingredient>();
ArrayList<Log> log_records = new ArrayList<Log>();

ArrayList<Integer> daily_durations = new ArrayList<>();

final String file_name_recipes = "recipes.json";
final String file_name_fridge = "fridge.json";
final String file_name_logs = "logs.json";
final String file_name_user_notice = "user notice.txt";
boolean auto_save = false;

final int buttons_per_page = 8;
final float button_width = 400;
final float button_height = 40;
final float button_spacing = 10;
final float button_startX = 1000/2 - button_width/2;
final float button_startY = 700 - (button_height + button_spacing) * (buttons_per_page + 1);

int layer = 0;
int[] page_nums = {0, 0, 0}; 
int[] total_page_nums = {0, 0, 0};


Recipe current_r;
Ingredient current_ing;
Log current_log;

int recipe_id = 1, ingredient_id = 1;
int duration_demand = 30;
boolean time_priority = false;

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
  image(logo, 5, 5);

  if (current_Page == hp)
  {
    // decide if it's morning, afternoon, evening, or night

    int hour = hour();
    if (hour >= 6 && hour < 12)
    {
      greeting_text = "Good Morning";
    }
    else if (hour >= 12 && hour < 18)
    {
      greeting_text = "Good Afternoon";
    }
    else if (hour >= 18 && hour < 21)
    {
      greeting_text = "Good Evening";
    }
    else
    {
      greeting_text = "Good Night";
    }

    fill(text_col);
    textFont(createFont("Segoe UI Bold", 60));
    textAlign(CENTER, TOP);
    text(greeting_text, width/2, 80);
  }
  
}

void exit()
{
  export_data();
  println("Data saved while exiting");
  super.exit();
}
