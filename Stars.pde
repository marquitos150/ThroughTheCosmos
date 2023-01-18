public class Stars extends StarMenu
{
  // create star object
  Stars()
  {
    super();
  }
  
  // update star's position in game
  void update(int d)
  {
    if (d == 1)
    {
      y = y + speed + 5;
    }
    else if (d == 2)
    {
      y = y + speed + 10;
    }
    else if (d == 3)
    {
      y = y + speed + 15;
    }
    else
    {
      y = y + speed + 20;
    }
    
    if (y > height)
    {
      x = random(0, width);
      y = 0;
    }
  }
}
