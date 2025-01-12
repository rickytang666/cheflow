
abstract class Page
{
  /* SHARED FIELDS */

  PApplet parent;

  /* CONSTRUCTORS */

  Page(PApplet p)
  {
    this.parent = p;
  }

  /* SHARED METHODS */

  abstract void setup();
  abstract void die();
}