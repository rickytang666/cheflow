
/* 
	
	Software Name: CheFlow
	Author: Ricky Tang
	Date: January 24th, 2025
	
  An interactive application that manages recipes and tracks people's cooking activities, including data analysis for trends and optimized search recommendations. 
  The purpose of this project is to help people get more insights into their culinary preferences, as well as building the habit of cooking.

*/

/* PACKAGES */

import g4p_controls.*;
import java.util.*;
import java.awt.Font;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.lang.NullPointerException;

/* GLOBAL VARIABLES OR CONSTANTS */

// UI Elements

final color accent_col = #9eef7b; // normal light green
final color accent_col2 = #ff2984; // saturated pink
final color accent_col3 = #a5ff01; // bright green (lime)
final color dark_col = #1C1C1E; // very dark grey for dark mode interface
final color text_col = color(255) ; // white for text
Font UI_font1; // slightly more bolded one
Font UI_font2; // normal font weight one
PFont drawing_font; // font for graphs/maps
PImage logo;
String greeting_text = "Good Morning";

// Data Structures

ArrayList<Recipe> recipes = new ArrayList<Recipe>(); // all the recipes
ArrayList<Recipe> search_results = new ArrayList<Recipe>(); // search results based on user input, constantly changing
ArrayList<Recipe> matching_results = new ArrayList<Recipe>(); // a copy of recipes, for recommendations (matching page)
ArrayList<Ingredient> fridge = new ArrayList<Ingredient>(); // FRIDGE stores all the ingredients
ArrayList<Log> log_records = new ArrayList<Log>(); // storing all of the user's cooking activities records

ArrayList<Integer> daily_durations = new ArrayList<>(); // every day's total cooking time (past 365 days, in minutes)

// File Input/Output Related

final String file_name_recipes = "recipes.json";
final String file_name_fridge = "fridge.json";
final String file_name_logs = "logs.json";
final String file_name_user_notice = "user notice.txt";

/* 
  if on, the program saves the data instantly after any changes; 
  if off, only saves the data if you close the program by the "x" (not the stop running)
*/
boolean auto_save = false;

// Button Dimensions and Positions & Pages Navigations

final int buttons_per_page = 8;
final float button_width = 400;
final float button_height = 40;
final float button_spacing = 10;
final float button_startX = 1000/2 - button_width/2; // make sure button is in the middle
final float button_startY = 700 - (button_height + button_spacing) * (buttons_per_page + 1); // make sure the buttons are at the bottom (don't exceed the height)

int layer = 0; // the higher the innermost we are in, controlled by back and ingredient/recipe buttons
int[] page_nums = {0, 0, 0}; // the current page number for each layer
int[] total_page_nums = {0, 0, 0}; // the total number of pages for each layer, constantly updating

// Current elements we are visiting, for loading the relevant data

Recipe current_r;
Ingredient current_ing;
Log current_log;

// User Related

int recipe_id = 1, ingredient_id = 1; // For assigning non-repeating new names
int duration_demand = 30; // For recommendations, the default time requirement is set to 30 minutes
boolean time_priority = false; // For recommendations, if the user really cares about the time limits

// All of the pages/navbar, each of the objects handle their own elements

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
  frameRate(60);

  // Import and initializations
  
  import_data();
  initialize_fonts();
  initialize_UI_colors();

  createGUI();
  
  nb = new Nav_Bar(this);
  rp = new Recipes_Page(this);
  fp = new Frige_Page(this);
  hp = new Home_Page(this);
  mp = new Matching_Page(this);
  ap = new Activity_Page(this);
  
  nb.setup(); // setup navbar for switching pages
  current_Page = hp; // default start is home page
  current_Page.setup();
  
}

void draw()
{
  // Background and necessary elements (navbar, logo)

  background(dark_col);
  nb.draw();

  logo = loadImage("logo.png");
  logo.resize(0, 50);
  image(logo, 5, 5);

  // Based on the current time, display a greeting message

  if (current_Page == hp)
  {
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

  
  // Handle the cooldown of any buttons (using counting frames)


  if (safe_mode)
  {
    if (prev_btn_cooldown > 0)
    {
      prev_btn_cooldown--;

      if (prev_btn_cooldown == 0)
      {
        // cooldown over, reset the button to what it should be

        prev_button.setEnabled(page_nums[layer] > 0);
      }
    }

    if (next_btn_cooldown > 0)
    {
      next_btn_cooldown--;

      if (next_btn_cooldown == 0)
      {
        // cooldown over, reset the button to what it should be

        next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
      }
    }
  }
  
}

/* EXITING HANDLER */

// NOTE: The final save only works if you close the program via the "X" rather than forcing stop running

void exit()
{
  export_data();
  println("Data saved while exiting");

  // exit the PApplet first, then exit the entire program
  // ensure the saving is BEFORE the closure

  super.exit();
}
