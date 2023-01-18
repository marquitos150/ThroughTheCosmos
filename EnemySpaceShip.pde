public class EnemySpaceShip
{
  float x;
  float y;
  float w1, w2, w3;
  float h1, h2, h3;
  float wdestroy;
  float hdestroy;
  float speed;
  int hitpoints;
  int difficultyLevel;
  
  float timeCheck;
  float bulletInterval;
  boolean isDestroyed;
  
  ArrayList<EnemyProjectile> ebullets; // list of enemy bullet objects shot by enemy object
  
  // create enemy object
  EnemySpaceShip(float xPos, float yPos, int diff)
  {
    x = xPos;
    y = yPos;
    w1 = 8; w2 = 13; w3 = 13;
    h1 = 15; h2 = 9; h3 = 9;
    wdestroy = 45; hdestroy = 30;
    difficultyLevel = diff;
    isDestroyed = false;
    ebullets = new ArrayList<EnemyProjectile>();
    
    timeCheck = millis();
    // based on difficulty
    if (difficultyLevel == 1)
    {
      speed = random(1.5, 4);
      hitpoints = 200;
      bulletInterval = 1200;
    }
    else if (difficultyLevel == 2)
    {
      speed = random(1.7, 4.2);
      hitpoints = 250;
      bulletInterval = 1100;
    }
    else if (difficultyLevel == 3)
    {
      speed = random(2.0, 4.4);
      hitpoints = 350;
      bulletInterval = 1000;
    }
    else
    {
      speed = random(2.5, 4.6);
      hitpoints = 400;
      bulletInterval = 900;
    }
  }
  
  // how fast enemy will shoot
  void addBullet(SoundFile s)
  {
    if (!isDestroyed)
    {
      if (millis() > timeCheck + bulletInterval)
      {
        if (!s.isPlaying())
        {
          s.play();
        }
        timeCheck = millis();
        EnemyProjectile ep = new EnemyProjectile(x, y, difficultyLevel);
        ebullets.add(ep);
      }
    }
  }
  
  // move enemy
  void move(Player p)
  {
    if (!isDestroyed)
    {
      if (speed < 0.01)
      {
        if (dist(x, y, p.x, p.y) < 125 || y > p.y)
        {
          chase(p);
        }
        else
        {
          if (x > p.x)
          {
            switch(difficulty) {
              case 1:
                x -= 1.5;
                break;
              case 2:
                x -= 2.5;
                break;
              case 3:
                x -= 4;
                break;
              case 4:
                x -= 6;
                break;
            }
          }
          else if (x < p.x)
          {
            switch(difficulty) {
              case 1:
                x += 1.5;
                break;
              case 2:
                x += 2.5;
                break;
              case 3:
                x += 4;
                break;
              case 4:
                x += 6;
                break;
            }
          }
        }
      }
      else
      {
        if (dist(x, y, p.x, p.y) < 125 || y > p.y)
        {
          speed = 0.05;
          chase(p);
        }
        else
        {
          speed -= 0.02;
          y += speed;
        }
      }
    }
  }
  
  // if player gets too close, enemy will chase after player
  void chase(Player p)
  {
    if (abs(x - p.x) < abs(y - p.y))
    {
      if (y < p.y)
      {
        switch(difficulty) {
          case 1:
            y += 4;
            break;
          case 2:
            y += 5;
            break;
          case 3:
            y += 6;
            break;
          case 4:
            y += 7;
            break;
        }
      }
      else if (y > p.y)
      {
        switch(difficulty) {
          case 1:
            y -= 4;
            break;
          case 2:
            y -= 5;
            break;
          case 3:
            y -= 6;
            break;
          case 4:
            y -= 7;
            break;
        }
      }
    }
    else
    {
      if (x < p.x)
      {
        switch(difficulty) {
          case 1:
            x += 4;
            break;
          case 2:
            x += 5;
            break;
          case 3:
            x += 6;
            break;
          case 4:
            x += 7;
            break;
        }
      }
      else if (x > p.x)
      {
        switch(difficulty) {
          case 1:
            x -= 4;
            break;
          case 2:
            x -= 5;
            break;
          case 3:
            x -= 6;
            break;
          case 4:
            x -= 7;
            break;
        }
      }
    }
  }
  
  // display enemy
  void display()
  {
    if (!isDestroyed)
    {
      fill(200, 13, 100);
      noStroke();
      beginShape();
      vertex(x - 23, y - 15);
      vertex(x, y + 15);
      vertex(x + 23, y - 15);
      vertex(x, y);
      endShape(CLOSE);
      /*
      fill(255, 0, 0, 50);
      stroke(255, 0, 0);
      rect(x, y, wdestroy, hdestroy);
      */
    }
  }
}
