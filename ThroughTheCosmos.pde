// Marcos Vazquez
// music is "Insomnia Dreams" by OcularNebula
import processing.sound.*;
SoundFile music;
SoundFile shoot;
SoundFile enemyShoot;
SoundFile enemyDies;
SoundFile gameOverMan;
SoundFile victory;
SoundFile playerDamaged;
SoundFile enemyDamaged;
SoundFile explosion;

boolean inMenu, quitGame, gameInSession, playerIsDead, playerWins, deathByExplosion;
boolean[] keys = new boolean[128];
int difficulty; // scaled from 1-4 (4 being hardest)
int score;

PImage game_title;
PImage diff_background;
PImage you_win;

Player spaceship;
ArrayList<Projectile> bullets;
ArrayList<EnemySpaceShip> enemies;

StarMenu[] starfield = new StarMenu[300]; // array of stars for menu
Stars[] fasterStarField = new Stars[300]; // array of stars in game

Timer t;

// sets up the game
void setup()
{
  size(960, 720);
  frameRate(40);
  
  music = new SoundFile(this, "Sound/game_music.wav");
  shoot = new SoundFile(this, "Sound/player_shooting.mp3");
  shoot.amp(0.2);
  enemyShoot = new SoundFile(this, "Sound/enemy_shooting.mp3");
  enemyShoot.amp(0.15);
  enemyDies = new SoundFile(this, "Sound/enemy_dies.mp3");
  enemyDies.amp(0.75);
  gameOverMan = new SoundFile(this, "Sound/game_over.mp3");
  victory = new SoundFile(this, "Sound/victory.mp3");
  playerDamaged = new SoundFile(this, "Sound/player_damaged.mp3");
  enemyDamaged = new SoundFile(this, "Sound/enemy_damaged.mp3");
  enemyDamaged.amp(0.5);
  explosion = new SoundFile(this, "Sound/death_by_explosion.mp3");
  
  inMenu = true;
  quitGame = false;
  gameInSession = false;
  playerIsDead = false;
  playerWins = false;
  deathByExplosion = false;
  
  score = 0;
  
  spaceship = new Player(width/2, height/2 + 180, 10);
  bullets = new ArrayList<Projectile>();
  enemies = new ArrayList<EnemySpaceShip>();
  
  game_title = loadImage("game_title.png");
  diff_background = loadImage("difficulty_background.png");
  you_win = loadImage("the_end.jpeg");
  
  for (int i = 0; i < starfield.length; i++)
  {
    starfield[i] = new StarMenu();
  }
  
  for (int i = 0; i < fasterStarField.length; i++)
  {
    fasterStarField[i] = new Stars();
  }
  
  t = new Timer(99, 99);
  
  rectMode(CENTER);
  imageMode(CENTER);
}

void draw()
{
  // if player presses "Quit" game is closed
  if (quitGame)
  {
    exit();
  }
  
  // if not player will keep seeing menu
  if (inMenu == true)
  {
    displayMenu();
    fill(255, 255, 255, 100);
    textSize(25);
    text("Music: Insomnia Dreams, by OcularNebula", width - 460, height - 5);
  }
  // if player presses "Play" display difficulty selection menu
  else if (!gameInSession)
  {
    displayDifficulties();
  }
  
  // after player chooses difficulty game will start
  if (gameInSession)
  {
    // if player dies show game over screen
    if (playerIsDead)
    {
      displayGameOver();
    }
    // if player wins show win screen
    else if (playerWins)
    {
      displayYouWin();
    }
    // game is still ongoing
    else
    {
      background(0);
      for (int i = 0; i < fasterStarField.length; i++)
      {
        fasterStarField[i].update(difficulty);
        fasterStarField[i].display();
      }
      
      // timer countdown
      t.countDown();
      t.display();
      
      for (int i = 0; i < bullets.size(); i++)
      {
        bullets.get(i).update();
        bullets.get(i).display();
        
        boolean bulletRemoved = false;
        
        for (int j = 0; j < enemies.size(); j++)
        {
          // if player's bullet collides with enemy do damage to it
          if (checkBulletToEnemyCollision(bullets.get(i), enemies.get(j)))
          {
            if (!enemyDamaged.isPlaying())
            {
              enemyDamaged.play();
            }
            enemies.get(j).hitpoints -= 75;
            score += 10;
            bulletRemoved = true;
            // if enemy's hp reaches 0, it gets destroyed
            if (enemies.get(j).hitpoints <= 0)
            {
              if (!enemyDies.isPlaying())
              {
                enemyDies.play();
              }
              enemies.get(j).isDestroyed = true;
              score += 200;
            }
          }
          // if bullet is off screen remove it
          else if (bullets.get(i).offScreen)
          {
            bulletRemoved = true;
          }
        }
        
        if (bulletRemoved)
        {
          bullets.remove(i);
          i--;
        }
      }
      // for displaying spaceship movement
      spaceship.update();
      spaceship.display();
        
      for (int i = 0; i < enemies.size(); i++)
      {
        enemies.get(i).move(spaceship);
        enemies.get(i).display();
        enemies.get(i).addBullet(enemyShoot);
          
        boolean enemyRemoved = false;
        
        // if enemy collides with player, instant game over
        if (checkEnemyPlayerCollision(spaceship, enemies.get(i)))
        {
          enemies.get(i).isDestroyed = true;
          deathByExplosion = true;
          spaceship.numLives = 0;
        }
        
        for (int j = 0; j < enemies.get(i).ebullets.size(); j++)
        {
          enemies.get(i).ebullets.get(j).update();
          enemies.get(i).ebullets.get(j).display();
          // if enemy's bullet collides with spaceship, one life is removed
          if (checkEnemyBulletCollision(spaceship, enemies.get(i).ebullets.get(j)))
          {
            if (!playerDamaged.isPlaying())
            {
              playerDamaged.play();
            }
            spaceship.numLives--;
            enemies.get(i).ebullets.remove(j);
            j--;
          }
          // if enemy's bullet is offscreen remove it
          // if enemy is already dead remove enemy
          else if (enemies.get(i).ebullets.get(j).offScreen)
          {
            enemies.get(i).ebullets.remove(j);
            if (enemies.get(i).ebullets.size() == 0 && enemies.get(i).isDestroyed)
            {
              enemyRemoved = true;
            }
            j--;
          }
        }
          
        if (enemyRemoved)
        {
          enemies.remove(i);
          i--;
        }
      }
      
      // spawn rate for enemy
      if (difficulty == 1)
      {
        if (random(100) < 1)
        {
          EnemySpaceShip e = new EnemySpaceShip(random(0, width), -15, difficulty);
          enemies.add(e);
        }
      }
      
      else if (difficulty == 2)
      {
        if (random(100) < 1.25)
        {
          EnemySpaceShip e = new EnemySpaceShip(random(0, width), -15, difficulty);
          enemies.add(e);
        }
      }
      
      else if (difficulty == 3)
      {
        if (random(100) < 1.5)
        {
          EnemySpaceShip e = new EnemySpaceShip(random(0, width), -15, difficulty);
          enemies.add(e);
        }
      }
      
      else
      {
        if (random(100) < 1.75)
        {
          EnemySpaceShip e = new EnemySpaceShip(random(0, width), -15, difficulty);
          enemies.add(e);
        }
      }
      // display score
      fill(255, 255, 255, 100);
      textSize(50);
      text(score, width / 2 - 15, 150);
      
      // display lives
      fill(255, 0, 100, 120);
      textSize(75);
      text("Lives: " + spaceship.numLives, width - 340, 100);
    }
  }
  
  // if player dies
  if (spaceship.numLives <= 0)
  {
    music.stop();
    if (deathByExplosion)
    {
      explosion.play();
      deathByExplosion = false;
    }
    else
    {
      gameOverMan.play();
    }
    bullets.clear();
    for (int i = 0; i < enemies.size(); i++)
    {
      enemies.get(i).ebullets.clear();
    }
    enemies.clear();
    for (int i = 0; i < keys.length; i++)
    {
      keys[i] = false;
    }
    playerIsDead = true;
    spaceship.numLives = 10;
  }
  // if game ends
  else if (t.endGame)
  {
    music.stop();
    victory.play();
    bullets.clear();
    for (int i = 0; i < enemies.size(); i++)
    {
      enemies.get(i).ebullets.clear();
    }
    enemies.clear();
    for (int i = 0; i < keys.length; i++)
    {
      keys[i] = false;
    }
    playerWins = true;
    t.endGame = false;
    spaceship.numLives = 10;
  }
}

// displays menu
void displayMenu()
{
  background(0);
  for (int i = 0; i < starfield.length; i++)
  {
    starfield[i].update();
    starfield[i].display();
  }
  
  // spaceship
  fill(25, 189, 255);
  noStroke();
  beginShape();
  vertex(width/2 - 23, height/2 + 180 + 15);
  vertex(width/2, height/2 + 180 - 15);
  vertex(width/2 + 23, height/2 + 180 + 15);
  vertex(width/2, height/2 + 180);
  endShape(CLOSE);
  
  // title
  image(game_title, width/2, height/2 - 180, 450, 250);
  
  // buttons
  stroke(255);
  fill(255, 255, 255, 50);
  rect(width/2 - 180, height/2 + 80, 200, 75);
  rect(width/2 + 180, height/2 + 80, 200, 75);
  
  textSize(50);
  fill(255);
  text("Play", width/2 - 180 - 45, height/2 + 80 + 15);
  text("Quit", width/2 + 180 - 45, height/2 + 80 + 15); 
}

// displays difficulties
void displayDifficulties()
{
  image(diff_background, width/2, height/2, 960, 720);
  
  // EASY button
  stroke(0, 255, 0);
  fill(0, 255, 0, 50);
  rect(width/2, 70, 200, 75);
  textSize(50);
  fill(255);
  text("Easy", width/2 - 49, 85);
  
  // NORMAL button
  stroke(255, 255, 0);
  fill(255, 255, 0, 50);
  rect(width/2, 200, 200, 75);
  textSize(50);
  fill(255);
  text("Normal", width/2 - 77, 215);
  
  // HARD button
  stroke(255, 0, 0);
  fill(255, 0, 0, 50);
  rect(width/2, 330, 200, 75);
  textSize(50);
  fill(255);
  text("Hard", width/2 - 52, 345);
  
  // EXTREME button
  stroke(255, 0, 255);
  fill(255, 0, 255, 50);
  rect(width/2, 460, 200, 75);
  textSize(50);
  fill(255);
  text("Extreme", width/2 - 87, 475);
}

// displays game over
void displayGameOver()
{
  image(diff_background, width/2, height/2, 960, 720);
  
  textSize(100);
  fill(255, 0, 0);
  text("Game Over", width/2 - 230, 100);
  
  textSize(50);
  fill(255, 0, 0);
  text(score, width/2, height/2 - 150);
  
  // buttons
  stroke(0);
  fill(0, 0, 0, 50);
  rect(width/2 - 180, height/2 + 30, 200, 75);
  rect(width/2 + 180, height/2 + 30, 200, 75);
  
  textSize(50);
  fill(0);
  text("Retry", width/2 - 180 - 55, height/2 + 80 - 35);
  text("Menu", width/2 + 180 - 55, height/2 + 80 - 35);
}

// displays win screen
void displayYouWin()
{
  image(you_win, width/2, height/2, 960, 720);
  
  textSize(40);
  fill(255, 255, 0);
  text("Congratulations! You've reached the end!", 120, 100);
  
  textSize(50);
  fill(255, 255, 0);
  text(score, width/2, height/2 - 150);
  
  // button
  stroke(255);
  fill(255, 255, 255, 50);
  rect(width/2, height/2 + 100, 200, 75);
  
  textSize(50);
  fill(255);
  text("Menu", width/2 - 55, height/2 + 150 - 35);
}

// checks if enemy bullet collided with player
boolean checkEnemyBulletCollision(Player p, EnemyProjectile e)
{
  float distX1 = (p.x) - e.x;
  float distX2 = (p.x - 11.5) - e.x;
  float distX3 = (p.x + 11.5) - e.x;
  
  float distY1 = (p.y - 7) - e.y;
  float distY2 = (p.y + 4) - e.y;
  float distY3 = (p.y + 4) - e.y;
  
  if ((abs(distX1) < abs(distX2) && abs(distX1) < abs(distX3)) && (abs(distY1) < abs(distY2) && abs(distY1) < abs(distY3)))
  {
    float triggerWidth = (p.w1 / 2) + (e.w / 2);
    float triggerHeight = (p.h1 / 2) + (e.h / 2);
      
    if (abs(distX1) < triggerWidth)
    {
      if (abs(distY1) < triggerHeight)
      {
        return true;
      }
     }
  }
  
  if ((abs(distX2) < abs(distX1) && abs(distX2) < abs(distX3)) && (abs(distY2) < abs(distY1)))
  {
    float triggerWidth = (p.w2 / 2) + (e.w / 2);
    float triggerHeight = (p.h2 / 2) + (e.h / 2);
      
    if (abs(distX2) < triggerWidth)
    {
      if (abs(distY2) < triggerHeight)
      {
        return true;
      }
    }
  }
  
  if ((abs(distX3) < abs(distX1) && abs(distX3) < abs(distX2)) && (abs(distY3) < abs(distY1)))
  {
    float triggerWidth = (p.w3 / 2) + (e.w / 2);
    float triggerHeight = (p.h3 / 2) + (e.h / 2);
      
    if (abs(distX3) < triggerWidth)
    {
      if (abs(distY3) < triggerHeight)
      {
        return true;
      }
    }
  }
  return false;
}

// checks if enemy collided with player
boolean checkEnemyPlayerCollision(Player p, EnemySpaceShip e)
{
  float distX1 = (p.x) - e.x;
  float distX2 = (p.x - 11.5) - e.x;
  float distX3 = (p.x + 11.5) - e.x;
  
  float distY1 = (p.y - 7) - e.y;
  float distY2 = (p.y + 4) - e.y;
  float distY3 = (p.y + 4) - e.y;
  
  if ((abs(distX1) < abs(distX2) && abs(distX1) < abs(distX3)) && (abs(distY1) < abs(distY2) && abs(distY1) < abs(distY3)))
  {
    float triggerWidth = (p.w1 / 2) + (e.wdestroy / 2);
    float triggerHeight = (p.h1 / 2) + (e.hdestroy / 2);
      
    if (abs(distX1) < triggerWidth)
    {
      if (abs(distY1) < triggerHeight)
      {
        if (!e.isDestroyed)
        {
          return true;
        }
      }
     }
  }
  
  if ((abs(distX2) < abs(distX1) && abs(distX2) < abs(distX3)) && (abs(distY2) < abs(distY1)))
  {
    float triggerWidth = (p.w2 / 2) + (e.wdestroy / 2);
    float triggerHeight = (p.h2 / 2) + (e.hdestroy / 2);
      
    if (abs(distX2) < triggerWidth)
    {
      if (abs(distY2) < triggerHeight)
      {
        if (!e.isDestroyed)
        {
          return true;
        }
      }
    }
  }
  
  if ((abs(distX3) < abs(distX1) && abs(distX3) < abs(distX2)) && (abs(distY3) < abs(distY1)))
  {
    float triggerWidth = (p.w3 / 2) + (e.wdestroy / 2);
    float triggerHeight = (p.h3 / 2) + (e.hdestroy / 2);
      
    if (abs(distX3) < triggerWidth)
    {
      if (abs(distY3) < triggerHeight)
      {
        if (!e.isDestroyed)
        {
          return true;
        }
      }
    }
  }
  return false;
}

// checks if bullet collided with enemy
boolean checkBulletToEnemyCollision(Projectile p, EnemySpaceShip e)
{
  if (!e.isDestroyed)
  {
    float distX1 = p.x - (e.x);
    float distX2 = p.x - (e.x - 11.5);
    float distX3 = p.x - (e.x + 11.5);
  
    float distY1 = p.y - (e.y + 7);
    float distY2 = p.y - (e.y - 4);
    float distY3 = p.y - (e.y - 4);
  
    if ((abs(distX1) < abs(distX2) && abs(distX1) < abs(distX3)) && (abs(distY1) < abs(distY2) && abs(distY1) < abs(distY3)))
    {
      float triggerWidth = (p.w / 2) + (e.w1 / 2);
      float triggerHeight = (p.h / 2) + (e.h1 / 2);
      
      if (abs(distX1) < triggerWidth)
      {
        if (abs(distY1) < triggerHeight)
        {
          return true;
        }
       }
    }
  
    if ((abs(distX2) < abs(distX1) && abs(distX2) < abs(distX3)) && (abs(distY2) < abs(distY1)))
    {
      float triggerWidth = (p.w / 2) + (e.w2 / 2);
      float triggerHeight = (p.h / 2) + (e.h2 / 2);
      
      if (abs(distX2) < triggerWidth)
      {
        if (abs(distY2) < triggerHeight)
        {
          return true;
        }
      }
    }
  
    if ((abs(distX3) < abs(distX1) && abs(distX3) < abs(distX2)) && (abs(distY3) < abs(distY1)))
    {
      float triggerWidth = (p.w / 2) + (e.w3 / 2);
      float triggerHeight = (p.h / 2) + (e.h3 / 2);
      
      if (abs(distX3) < triggerWidth)
      {
        if (abs(distY3) < triggerHeight)
        {
          return true;
        }
      }
    }
  }
  return false;
}

void keyPressed()
{
  if (gameInSession && !playerIsDead && !playerWins)
  {
    if (key != CODED)
    {
      keys[key] = true;
    }
  }
}

void keyReleased()
{
  if (gameInSession && !playerIsDead && !playerWins)
  {
    if (key != CODED)
    {
      keys[key] = false;
    }
  }
}

void mouseClicked()
{
  if (gameInSession && !playerIsDead && !playerWins)
  {
    if (mouseButton == LEFT)
    {
      Projectile p = new Projectile(spaceship.x, spaceship.y);
      bullets.add(p);
      if (!shoot.isPlaying())
      {
        shoot.play();
      }
    }
  }
}

void mouseReleased()
{
  if (playerIsDead)
  {
    // user wants to try again
    if ((mouseX >= 200 && mouseX <= 400) && (mouseY >= 352.5 && mouseY <= 427.5))
    {
      playerIsDead = false;
      playerWins = false;
      spaceship.x = width/2;
      spaceship.y = height/2 + 180;
      if (difficulty == 1)
      {
        t.setMinute(1);
        t.setSecond(9);
      }
      else if (difficulty == 2)
      {
        t.setMinute(2);
        t.setSecond(5);
      }
      else if (difficulty == 3)
      {
        t.setMinute(3);
        t.setSecond(15);
      }
      else if (difficulty == 4)
      {
        t.setMinute(4);
        t.setSecond(11);
      }
      music.play();
      score = 0;
    }
    // user gives up or wants to choose different difficulty
    else if ((mouseX >= 560 && mouseX <= 760) && (mouseY >= 352.5 && mouseY <= 427.5))
    {
      playerIsDead = false;
      playerWins = false;
      inMenu = true;
      gameInSession = false;
      spaceship.x = width/2;
      spaceship.y = height/2 + 180;
      score = 0;
    }
  }
  else if (playerWins)
  {
    if ((mouseX >= width/2 - 100 && mouseX <= width/2 + 100) && (mouseY >= 422.5 && mouseY <= 497.5))
    {
      playerIsDead = false;
      playerWins = false;
      inMenu = true;
      gameInSession = false;
      spaceship.x = width/2;
      spaceship.y = height/2 + 180;
      score = 0;
    }
  }
  
  if (inMenu)
  {
    // click play
    if ((mouseX >= 200 && mouseX <= 400) && (mouseY >= 402.5 && mouseY <= 477.5))
    {
      inMenu = false;
    }
    // click quit
    else if ((mouseX >= 560 && mouseX <= 760) && (mouseY >= 402.5 && mouseY <= 477.5))
    {
      quitGame = true;
    }
  }
  
  else if (!inMenu && !gameInSession)
  {
    if ((mouseX >= width/2 - 100 && mouseX <= width/2 + 100) && (mouseY >= 32.5 && mouseY <= 107.5))
    {
      difficulty = 1;
      t.setMinute(1);
      t.setSecond(9);
      gameInSession = true;
      music.play();
    }
    else if ((mouseX >= width/2 - 100 && mouseX <= width/2 + 100) && (mouseY >= 162.5 && mouseY <= 237.5))
    {
      difficulty = 2;
      t.setMinute(2);
      t.setSecond(5);
      gameInSession = true;
      music.play();
    }
    else if ((mouseX >= width/2 - 100 && mouseX <= width/2 + 100) && (mouseY >= 292.5 && mouseY <= 367.5))
    {
      difficulty = 3;
      t.setMinute(3);
      t.setSecond(15);
      gameInSession = true;
      music.play();
    }
    else if ((mouseX >= width/2 - 100 && mouseX <= width/2 + 100) && (mouseY >= 422.5 && mouseY <= 497.5))
    {
      difficulty = 4;
      t.setMinute(4);
      t.setSecond(11);
      gameInSession = true;
      music.play();
    }
  }
}
