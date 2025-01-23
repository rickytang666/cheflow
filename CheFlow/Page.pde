// This file is for the abstract Page class, define the members and shared methods

abstract class Page
{
  /* SHARED FIELDS */

  PApplet parent; // The page need a PApplet to refer to, in order to put controls

  /* CONSTRUCTORS */

  Page(PApplet p)
  {
    this.parent = p;
  }

  /* SHARED METHODS */

  abstract void setup();
  abstract void die();
}