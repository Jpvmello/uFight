public class Timer { //TODO: assert that operations can be done.
  private boolean running;
  private int startMS, limitMS;
  
  public Timer (int limitMS) {
    this.limitMS = limitMS;
    this.running = false;
  }
  
  public int getLimitMS() {
    return limitMS;
  }
  
  public boolean isRunning() {
    return running;
  }
  
  public void setLimitMS(int limitMS) {
    this.limitMS = limitMS;
  }
  
  public void start() {
    running = true;
    startMS = millis();
  }
  
  public float elapsedTime(boolean proportion) {
    float elapsedTimeMS = min(millis() - startMS, limitMS);
    if (proportion)
      return elapsedTimeMS/limitMS;
    return elapsedTimeMS;
  }
  
  public boolean isTimeOver() {
    return elapsedTime(false) >= limitMS;
  }
  
  public void stop() {
    running = false;
  }
}
