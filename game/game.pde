import processing.net.Client;
import processing.video.Capture;

Fighter player, enemy;
Client client;
//Capture camera;

void setup() {
  fullScreen(P2D);
  //size(640, 480);
  
  textAlign(CENTER, CENTER);
  
  player = new Fighter(true);
  enemy  = new Fighter(false);
  
  client = new Client(this, "localhost", 8000);
  
  //camera = new Capture(this, Capture.list()[1]);
  //camera.start();
}

void draw() {
  if (enemy.hasNoHp()) {
    fill(255, 200, 0);
    textSize(0.15*width);
    text("YOU WIN!", width/2, height/2);
    
  } else if (player.hasNoHp()) {
    fill(255, 200, 0);
    textSize(0.15*width);
    text("YOU LOSE!", width/2, height/2);
    
  } else {
    //if (camera.available()) {
    //  camera.read();
    //}
    background(0); //image(camera, 0, 0);
    
    if (client.available() > 0)
      player.updateFromCam(client.readString());
    player.draw();
    
    if (player.isOccluded()) {
      fill(255, 0, 0);
      textSize(0.05*width);
      text("Player must fit with the screen.", width/2, height/2);
    } else {
      enemy.draw();
    
      player.drawHp();
      enemy.drawHp();
      
      //player.updateDirection(enemy);
      enemy.updateDirection(player);
      
      //player.randomMov();
      enemy.randomMov();
      
      player.processDamage(enemy);
      enemy.processDamage(player);
    }
  }
}
