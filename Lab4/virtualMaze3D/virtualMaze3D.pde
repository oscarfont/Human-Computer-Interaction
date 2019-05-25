import processing.sound.*;
import java.util.Map;


int life = 3;

boolean extra_life = false;

int initialTime;
int initialTime2;
int interval = 50;
int interval2 = 2;
String time = "10";
int t;

boolean start = false; 
String screen = "homeScreen";

void setup() {
    size(1200,700);
}

void draw() {
    background(255,255,255);
    switch (screen) {
        case "homeScreen":
            homeScreen();
            break;
        case "onGame":
            onGame();
            break;
        case "youLost":
            youLost();
            break;
        case "fallingBall":
            fallingBall();
            break;
        case "extraLife":
            extraLife();
            break;
    }
}

void keyPressed() {
    if (key == 'q'){ //hole
      life--;
      if(life!=0){
        initialTime2 = int(millis()/1000);
        screen = "fallingBall";
      }
    }
    
    if (key == 'w'){
        if(!extra_life){
          extra_life = true;
          life++;
          initialTime2 = int(millis()/1000);
          screen = "extraLife";
        } 
    }
    if(key == 32){
        start = true;
    }
}

void keyReleased() {
    if(key == 32){
        start = false;
    }
}

void homeScreen() {
    textSize(50);
    fill(#000000);
    text("Pulsa espacio para empezar", 300, 400);
    if(start){
      initialTime = int(millis()/1000);
      screen = "onGame";
    }
}

void onGame() {
  t = interval-(int(millis()/1000)-initialTime);
  time = nf(t , 2);
  
  textSize(50);
  fill(#000000);
  text("0:"+time,0, 0, width, height);
  
  for (int i=0;i<life;i++) { //Aixo molaria ferho amb imatges de 
   text("♥", 300+i*100, 400);
  }
  
  if(t == 0 || life == 0){
    screen = "youLost";
  }
}

void youLost() {
  
  textSize(50);
  fill(#000000);
  text("youLost", 300, 400);
  text("Pulsa espacio para empezar de nuevo", 300, 500);
  
  if(start){
    //Reinicio variables
      life=3; 
      extra_life = false;
      initialTime = int(millis()/1000);
      
      screen = "onGame";
    }
}

void fallingBall(){
  
  textSize(50);
  fill(#000000);
  text("Has caido, aun te quedan "+ life +" vidas", 300, 400);
  
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);

  if(t == 0){
    screen = "onGame";
  }
}

void extraLife(){
  textSize(50);
  fill(#000000);
  text("Vida extra! ♥", 300, 400);
  
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);

  if(t == 0){
    screen = "onGame";
  }
}
