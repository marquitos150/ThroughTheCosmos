public class EnemyProjectile extends Projectile
{
  int difficulty;
  
  // create enemy bullet object
  EnemyProjectile(float bx, float by, int diff)
  {
    super(bx, by);
    difficulty = diff;
  }
  
  // update enemy bullet position
  void update()
  {
    if (difficulty == 1)
    {
      y += 4;
    }
    else if (difficulty == 2)
    {
      y += 7;
    }
    else if (difficulty == 3)
    {
      y += 11;
    }
    else
    {
      y += 16;
    }
    
    if (y > height + 20)
    {
      offScreen = true;
    }
  }
  
  // display enemy bullet
  void display()
  {
    fill(255, 0, 0);
    stroke(255, 200, 200);
    rect(x, y, w, h);
  }
}
