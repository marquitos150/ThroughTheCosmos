public class Timer
{
  int s;
  int m;
  float timeCheck;
  
  boolean endGame;
  
  // create timer object
  Timer(int min, int sec)
  {
    s = sec;
    m = min;
    timeCheck = millis();
    endGame = false;
  }
  
  // set second
  void setSecond(int sec)
  {
    s = sec;
  }
  
  // set minute
  void setMinute(int min)
  {
    m = min;
  }
  
  // count down each second
  void countDown()
  {
    if (millis() > timeCheck + 1000)
    {
      timeCheck = millis();
      s--;
      if (s < 0)
      {
        m--;
        if (m < 0)
        {
          endGame = true;
        }
        else
        {
          s = 59;
        }
      }
    }
  }
  
  // display current timer
  void display()
  {
    if (!endGame)
    {
      String second = Integer.toString(s);
      String minute = Integer.toString(m);
      fill(150, 150, 150);
      textSize(100);
      if (s < 10)
      {
        text(minute + ":0" + second, width/2 - 90, 100);
      }
      else
      {
        text(minute + ":" + second, width/2 - 90, 100);
      }
    }
  }
}
