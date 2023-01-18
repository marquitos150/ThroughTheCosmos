public class Player
{
  float x;
  float y;
  float w1, w2, w3;
  float h1, h2, h3;
  int numLives;
  
  // create player object
  Player(float xPos, float yPos, int health)
  {
    x = xPos;
    y = yPos;
    w1 = 8; w2 = 13; w3 = 13;
    h1 = 15; h2 = 9; h3 = 9;
    numLives = health;
  }
  
  // set x
  void setXPos(float xPos)
  {
    x = xPos;
  }
  
  // set y
  void setYPos(float yPos)
  {
    y = yPos;  
  }
  
  // update player's position
  void update()
  {
    if (keys['w'])
    {
      if (y - 15 >= 0)
      {
        spaceship.setYPos(y - 8);
      }
    }
    if (keys['a'])
    {
      if (x - 23 >= 0)
      {
        spaceship.setXPos(x - 8);
      }
    }
    if (keys['s'])
    {
      if (y + 15 <= height)
      {
        spaceship.setYPos(y + 8);
      }
    }
    if (keys['d'])
    {
      if (x + 23 <= width)
      {
        spaceship.setXPos(x + 8);
      }
    }
  }
  
  // display player
  void display()
  {
    fill(25, 189, 255);
    noStroke();
    beginShape();
    vertex(x - 23, y + 15);
    vertex(x, y - 15);
    vertex(x + 23, y + 15);
    vertex(x, y);
    endShape(CLOSE);
    /*
    fill(255, 0, 0, 50);
    stroke(255, 0, 0);
    rect(x, y - 7, w1, h1);
    rect(x - 11.5, y + 4, w2, h2);
    rect(x + 11.5, y + 4, w3, h3);
    */
  }
}
