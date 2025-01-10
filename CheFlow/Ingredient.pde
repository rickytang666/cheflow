
class Ingredient
{
  String name;
  String content;
  GButton button;
  GButton del_button;
  GLabel label;
  GTextField renamer;
  
  Ingredient(String n)
  {
    this.name = n;
    
    this.content = "";
    
    for (int i = 0; i < 30; ++i)
    {
      this.content += "Hello World! This is a placeholder\n";
    }
    
    this.button = null;
    this.del_button = null;
    this.label = null;
    this.renamer = null;
  }
}
