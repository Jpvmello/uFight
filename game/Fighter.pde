public class Fighter {
  private boolean isPlayer, atRight;
  private float hp, origHp;
  private Joint[] jointTree;
  private Animation currentMov;
  private Timer currentTimer, noneTimer, stepTimer, rightPunchTimer, rightKickTimer;
  
  public Fighter(boolean isPlayer) {
    this.isPlayer = isPlayer;
    this.origHp = this.hp = 1000;
    this.currentMov = Animation.NONE;
    
    this.noneTimer       = new Timer(1000);
    this.stepTimer       = new Timer(500);
    this.rightPunchTimer = new Timer(200);
    this.rightKickTimer  = new Timer(400);
    this.currentTimer    = null;
    
    jointTree = new Joint[] {
      new Joint("nose",           2.00*width/3, 0.500*height, new int[] {1, 2}),
      new Joint("left eye",       2.01*width/3, 0.495*height, new int[] {2, 3}),
      new Joint("right eye",      1.99*width/3, 0.495*height, new int[] {4}),
      new Joint("left ear",       2.05*width/3, 0.495*height, new int[] {5}),
      new Joint("right ear",      2.03*width/3, 0.495*height, new int[] {6}),
      new Joint("left shoulder",  2.10*width/3, 0.600*height, new int[] {6, 7, 11}),
      new Joint("right shoulder", 1.98*width/3, 0.600*height, new int[] {8, 12}),
      new Joint("left elbow",     2.00*width/3, 0.690*height, new int[] {9}),
      new Joint("right elbow",    1.88*width/3, 0.690*height, new int[] {10}),
      new Joint("left hand",      2.00*width/3, 0.600*height, new int[] {}),
      new Joint("right hand",     1.88*width/3, 0.600*height, new int[] {}),
      new Joint("left hip",       2.10*width/3, 0.750*height, new int[] {12, 13}),
      new Joint("right hip",      1.98*width/3, 0.750*height, new int[] {14}),
      new Joint("left knee",      2.15*width/3, 0.850*height, new int[] {15}),
      new Joint("right knee",     1.93*width/3, 0.850*height, new int[] {16}),
      new Joint("left foot",      2.20*width/3, 0.950*height, new int[] {}),
      new Joint("right foot",     1.98*width/3, 0.950*height, new int[] {})
    };
    
    if (isPlayer) for (Joint joint: jointTree) {joint.setX(width - joint.getX()); joint.updateOrig();}
    
    this.atRight = !isPlayer;
  }
  
  public Joint getJoint(String name) {
    for (Joint joint: jointTree)
      if (joint.getName().equals(name))
        return joint;
    return null;
  }
  
  public float getCenterX() {
    return 0.5 * (getJoint("right hip").getX() + getJoint("left hip").getX());
  }
  
  public boolean hasNoHp() {
    return hp == 0;
  }
  
  public float distance(Joint joint1, Joint joint2) {
    return sqrt(pow(joint2.getOrigX() - joint1.getOrigX(), 2) + pow(joint2.getOrigY() - joint1.getOrigY(), 2));
  }
  
  public float distance(Joint joint1, String joint2Name) {
    Joint joint2 = getJoint(joint2Name);
    return distance(joint1, joint2);
  }
  
  public float distance(String joint1Name, String joint2Name) {
    Joint joint1 = getJoint(joint1Name);
    Joint joint2 = getJoint(joint2Name);
    return distance(joint1, joint2);
  }
  
  private boolean collision(Joint joint) {
    Joint rightHip = getJoint("right hip");
    Joint leftHip  = getJoint("left hip");
    Joint rightEar = getJoint("right ear");
    
    float maxX = max(rightHip.getX(), leftHip.getX());
    float minX = min(rightHip.getX(), leftHip.getX());
    float maxY = rightHip.getY();
    float minY = rightEar.getY();
    
    boolean c = joint.getX() >= minX && joint.getX() <= maxX && joint.getY() >= minY && joint.getY() <= maxY;
    if (c) {
      pushMatrix();
        if (isPlayer) fill(0, 255, 0); else fill(255, 255, 0); 
        rect(minX, minY, maxX - minX, maxY - minY);
      popMatrix();
    }
    
    return joint.getX() >= minX && joint.getX() <= maxX && joint.getY() >= minY && joint.getY() <= maxY;
  }
  
  public void processDamage(Fighter opponent) {
    Joint opponentRightHand = opponent.getJoint("right hand");
    Joint opponentLeftHand  = opponent.getJoint("left hand");
    Joint opponentRightFoot = opponent.getJoint("right foot");
    Joint opponentLeftFoot  = opponent.getJoint("left foot");
    
    for (Joint opponentJoint: new Joint[] {opponentRightHand, opponentLeftHand, opponentRightFoot, opponentLeftFoot})
      if (collision(opponentJoint))
        hp = max(0, hp - (isPlayer? 1 : 0.01)*opponentJoint.getSpeed());
  }
  
  private int direction(boolean conditionIsTrue) {
    return conditionIsTrue? 1 : -1;
  }
  
  public void randomMov() {
    if (currentTimer == null || !currentTimer.isRunning()) {
      currentMov = Animation.values()[int(random(Animation.values().length))];
      
      switch (currentMov) {
        case NONE:
          currentTimer = noneTimer;
          break;
        case STEP_FORWARD:
        case STEP_BACK:
          currentTimer = stepTimer;
          break;
        case RIGHT_PUNCH:
          currentTimer = rightPunchTimer;
          break;
        case RIGHT_KICK:
          currentTimer = rightKickTimer;
          break;
      }
      
      currentTimer.start();
    }
    
    Joint leftFoot, leftHip;
    int direction;
    float legAngle;
    switch (currentMov) {
      case NONE:
        for (Joint joint: jointTree)
          joint.update(joint.getX(), joint.getY()); //update() changes speed too
          break;
      case STEP_FORWARD:
        leftFoot  = getJoint("left foot");
        leftHip   = getJoint("left hip");
        legAngle = atan2(leftFoot.getOrigX() - leftHip.getOrigX(), leftFoot.getOrigY() - leftHip.getOrigY());
        for (Joint joint: jointTree) {
          direction = direction(!joint.getName().equals("left knee") && !joint.getName().equals("left foot"));   
          joint.update(
            joint.getOrigX() - direction * (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftHip, joint) * sin(legAngle),
            joint.getOrigY() - (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftHip, joint) * (1 - cos(legAngle))
          );
          if (currentTimer.elapsedTime(true) > 0.5)
            joint.update(
              joint.getX() - direction(atRight) * (currentTimer.elapsedTime(true) - 0.5) * 0.08*width,
              joint.getOrigY()
            );
        }
        break;
      case STEP_BACK:
        leftFoot  = getJoint("left foot");
        leftHip   = getJoint("left hip");
        legAngle = atan2(leftFoot.getOrigX() - leftHip.getOrigX(), leftFoot.getOrigY() - leftHip.getOrigY());
        for (Joint joint: jointTree) {
          direction = direction(!joint.getName().equals("left knee") && !joint.getName().equals("left foot"));
          joint.update(
            joint.getOrigX() + direction * (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftHip, joint) * sin(legAngle),
            joint.getOrigY() - (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftHip, joint) * (1 - cos(legAngle))
          );
          if (currentTimer.elapsedTime(true) > 0.5)
            joint.update(
              joint.getX() + direction(atRight) * (currentTimer.elapsedTime(true) - 0.5) * 0.08*width,
              joint.getOrigY()
            );
        }
        break;
      case RIGHT_PUNCH:
        Joint rightElbow    = getJoint("right elbow");
        Joint rightHand     = getJoint("right hand");
        Joint rightShoulder = getJoint("right shoulder");
        float forearmSize = distance(rightElbow, rightShoulder);
        float armSize     = distance(rightElbow, rightHand);
        rightElbow.update(
          rightElbow.getOrigX() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (rightElbow.getOrigX() - (rightShoulder.getX() - direction(atRight) * forearmSize)),
          rightElbow.getOrigY() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (rightElbow.getOrigY() - rightShoulder.getY())
        );
        rightHand.update(
          rightHand.getOrigX() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (rightHand.getOrigX() - (rightShoulder.getX() - direction(atRight) * (armSize + forearmSize))),
          rightHand.getOrigY()
        );
        break;
      case RIGHT_KICK:
        leftFoot  = getJoint("left foot");
        leftHip   = getJoint("left hip");
        Joint rightHip  = getJoint("right hip");
        Joint rightKnee = getJoint("right knee");
        float forelegSize  = distance(rightHip, rightKnee);
        float lowerLegSize = distance(rightKnee, "right foot");
        legAngle = atan2(leftFoot.getOrigX() - leftHip.getOrigX(), leftFoot.getOrigY() - leftHip.getOrigY());
        float kickHorizAngle = radians(30);
        for (Joint joint: jointTree) {
          if (joint.getName().equals("right knee"))
            joint.update(
              joint.getOrigX() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (joint.getOrigX() - (rightHip.getX() - direction(atRight) * forelegSize * cos(kickHorizAngle))),
              joint.getOrigY() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (joint.getOrigY() - (rightHip.getY() - forelegSize * sin(kickHorizAngle)))
            );
          else if (joint.getName().equals("right foot"))
            joint.update(
              joint.getOrigX() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (joint.getOrigX() - (rightHip.getX() - direction(atRight) * (forelegSize + lowerLegSize) * cos(kickHorizAngle))),
              joint.getOrigY() + (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * (joint.getOrigY() - (rightHip.getY() - (forelegSize + lowerLegSize) * sin(kickHorizAngle)))
            );
          else
            joint.update(
              joint.getOrigX() - (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftFoot, joint) * sin(legAngle),
              joint.getOrigY() - (abs(2*currentTimer.elapsedTime(true) - 1) - 1) * distance(leftFoot, joint) * (1 - cos(legAngle))
            );
        }
        break;
    }
    
    if (currentTimer.isTimeOver()) {
      for (Joint joint: jointTree)
        joint.updateOrig();
      currentTimer.stop();
    }
  }
  
  public void updateDirection(Fighter opponent) {
    if (currentMov == Animation.NONE || currentTimer == null || !currentTimer.isRunning()) {
      float centerX = getCenterX();
      boolean atLeft = centerX < opponent.getCenterX();
      if (atRight == atLeft) {
        for (Joint joint: jointTree) {
          joint.setX(joint.getX() - 2*(joint.getX() - centerX));
          joint.updateOrig();
        }
        atRight = !atRight;
      }
    }
  }
  
  private void scale() {
    String[] extremeVerticalJointsNames = {"right ear", "left ear", "right eye", "left eye", "nose", "right foot", "left foot"};
    
    float extremeLeft = width, extremeRight = 0, top = height, bottom = 0;
    for (String jointName: extremeVerticalJointsNames) {
      bottom       = max(bottom,       getJoint(jointName).getY());
      top          = min(top,          getJoint(jointName).getY());
      extremeRight = max(extremeRight, getJoint(jointName).getX());
      extremeLeft  = min(extremeLeft,  getJoint(jointName).getX());
    }
    
    float aspectRatio = (extremeRight - extremeLeft)/(bottom - top);
    float bottomTopNewDist = 0.45*height;
    if (bottom - top > bottomTopNewDist) {
      //T = 0.5H - 0.5HA
      //B = 0.5H + 0.5HA
      //T = T + (0.95H - (0.5*(B + T) - B)*(1 - A)) = T - (0.5B + 0.5T - B)*(1 - A) =
      //= T + 0.95H - 0.5B - 0.5T + B + 0.5BA + 0.5TA - BA = 0.5T + 0.95H + 0.5B - 0.5BA + 0.5TA =
      //= 1.45H + 0.5A(-HA) = 1.45H - 0.5HAA
      for (Joint joint: jointTree) {
        joint.setX(0.5*(extremeRight + extremeLeft) - (0.5*(extremeRight + extremeLeft) - joint.getX())*bottomTopNewDist/((bottom - top)));
        joint.setY(0.5*(bottom + top) - (0.5*(bottom + top) - joint.getY())*bottomTopNewDist/((bottom - top)));
        joint.setY(joint.getY() + (0.95*height - (0.5*(bottom + top) - (0.5*(bottom + top) - bottom)*bottomTopNewDist/((bottom - top)))));
      }
    }
  }
  
  public void updateFromCam(String coords) {
    String[] coordsList = coords.split(",");
    for (int i = 0, j = 0; i < jointTree.length; i++, j += 3)
      jointTree[i].update(float(coordsList[j]) * width, float(coordsList[j+1]) * height, float(coordsList[j+2]));
    scale();
  }
  
  boolean isOccluded() {
    String[] upperJointsNames = {"right ear", "left ear", "right eye", "left eye", "nose"};
    String[] lowerJointsNames = {"right foot", "left foot"};
    
    boolean isUpperSideOccluded = true;
    boolean isLowerSideOccluded = true;
    for (String jointName: upperJointsNames)
      isUpperSideOccluded = isUpperSideOccluded && !player.getJoint(jointName).hasHighConfidence();
    for (String jointName: lowerJointsNames)
      isLowerSideOccluded = isLowerSideOccluded && !player.getJoint(jointName).hasHighConfidence();
    
    return isUpperSideOccluded || isLowerSideOccluded;
  }
  
  public void drawHp() {
    float hpX = 0.03*width, barWidth = 0.25*width;
    float lostHpX = barWidth * (origHp - hp)/origHp;
    if (!isPlayer)
      hpX = width - hpX - barWidth;
    
    pushMatrix();
      if (hp > origHp/2)      fill(0, 255, 0);
      else if (hp < origHp/4) fill(255, 0, 0);
      else                    fill(255, 255, 0);
      noStroke();
      rect(hpX + lostHpX, 0.03*height, barWidth - lostHpX, 0.05*height);
    popMatrix();
  }
  
  public void draw() {
    pushMatrix();
      stroke(255, 255, 0);
      if (isPlayer)
        stroke(0, 255, 0);
    
      for (Joint joint: jointTree) {
        if (joint.hasHighConfidence()) {
          fill(255, 0, 0);
          circle(joint.getX(), joint.getY(), 0.02 * width);
          for (int linkedJointNum: joint.getChildJoints()) {
            Joint linkedJoint = jointTree[linkedJointNum];
            line(joint.getX(), joint.getY(), linkedJoint.getX(), linkedJoint.getY());
          }
        }
      }
    popMatrix();
  }
}
