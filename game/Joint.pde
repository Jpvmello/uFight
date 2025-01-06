public class Joint {
  private String name;
  private float x, y, origX, origY, speed, confidence;
  private int[] childJoints;
  
  public Joint(String name, float x, float y, int[] childJoints) {
    this.name = name;
    this.origX = this.x = x;
    this.origY = this.y = y;
    this.confidence = 1.0;
    this.childJoints = childJoints;
    
    this.speed = 0;
  }
  
  public String getName() {
    return name;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getOrigX() {
    return origX;
  }
  
  public float getOrigY() {
    return origY;
  }
  
  public void setX(float x) {
    this.x = x;
  }
  
  public void setY(float y) {
    this.y = y;
  }
  
  public int[] getChildJoints() {
    return childJoints;
  }
  
  public float getSpeed() {
    return speed;
  }
  
  public boolean hasHighConfidence() {
    return confidence > 0.2;
  }
  
  public void update(float x, float y) {
    float prevX = getX();
    float prevY = getY();
    setX(x);
    setY(y);
    speed = sqrt(pow(x - prevX, 2) + pow(y - prevY, 2));
  }
  
  public void update(float x, float y, float confidence) {
    update(x, y);
    this.confidence = confidence;
  }
  
  public void updateOrig() {
    origX = x;
    origY = y;
  }
}
