
class Ingredient
{
  String name;
  String content;
  GButton button;
  GLabel label;
  
  Ingredient(String n)
  {
    this.name = n;
    
    this.content = "";
    
    for (int i = 0; i < 30; ++i)
    {
      this.content += "Hello World! This is a placeholder\n";
    }
    
    this.button = null;
    this.label = null;
  }
}
