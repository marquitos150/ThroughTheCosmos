public class StarMenu
{
  float x;
  float y;
  int size;
  float speed;
  
  // create star in menu
  StarMenu()
  {
    x = random(0, width);
    y = random(0, height);
    size = (int) random(1, 6);
    if (size % 5 == 0)
    {
      speed = 0.625;
    }
    else if (size % 5 == 1)
    {
      speed = 0.125;
    }
    else if (size % 5 == 2)
    {
      speed = 0.25;
    }
    else if (size % 5 == 3)
    {
      speed = 0.375;
    }
    else if (size % 5 == 4)
    {
      speed = 0.5;
    }
  }
  
  // update star's position
  void update()
  {
    y = y + speed;
    if (y > height)
    {
      x = random(0, width);
      y = 0;
    }
  }
  
  // display star
  void display()
  {
    fill(255);
    noStroke();
    
    ellipse(x, y, size, size);
  }
}
