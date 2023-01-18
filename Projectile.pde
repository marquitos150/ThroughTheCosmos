public class Projectile
{
  float x;
  float y;
  float w;
  float h;
  
  boolean offScreen;
  
  // create bullet object
  Projectile(float bx, float by)
  {
    x = bx;
    y = by;
    w = 5;
    h = 15;
    offScreen = false;
  }
  
  // update bullet position
  void update()
  {
    y -= 15;
    if (y < -10)
    {
      offScreen = true;
    }
  }
  
  // display bullet
  void display()
  {
    fill(224, 255, 255);
    noStroke();
    rect(x, y, w, h);
  }
}
