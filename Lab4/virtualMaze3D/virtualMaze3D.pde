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
PFont font;
PImage bg;
PImage heart;



void setup() {
    size(1100,612);
    font = createFont("Righteous-Regular.ttf",50);
    bg = loadImage("home4.png");
    heart = loadImage("heart2.png");
}

void draw() {
    textFont(font);
    background(bg);
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
  
  textSize(110);
  fill(#000066);
  text("virtualMaze",235,350); 
  int tcolor =(millis()/1000)-initialTime;
  if(tcolor%2 == 0){
       fill(#ff884d);
  }else{
       fill(#ff3333);
  }
  textSize(30);
  text("Pulsa espacio para empezar", 350, 410);
  
  if(start){
    initialTime = int(millis()/1000);
    screen = "onGame";
  }
}

void onGame() {
  t = interval-(int(millis()/1000)-initialTime);
  time = nf(t , 2);
  int tcolor =(millis()/1000)-initialTime;
  if(tcolor%2 == 0){
      fill(#ff884d);
  }else{
       fill(#ff3333);
  }
  textSize(110);
  text("0:"+time,420,200, width, height);
  
  for (int i=0;i<life;i++) { //Aixo molaria ferho amb imatges de 
    image(heart,270+i*110, 300);
  }
  
  if(t == 0 || life == 0){
    screen = "youLost";
  }
}

void youLost() {
  
  textSize(90);  
  fill(#E55233);
  text("You Lost!",340,300);
  textSize(35);
  int tcolor =(millis()/1000)-initialTime;
  if(tcolor%2 == 0){
      fill(#ff884d);
  }else{
      fill(#000000);
  }
  text("Pulsa espacio para empezar", 310, 400);
  if(start){
    //Reinicio variables
      life=3; 
      extra_life = false;
      initialTime = int(millis()/1000);
      screen = "onGame";
   }
}

void fallingBall(){
  
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);
  textSize(90);
  fill(#E55233);
  text("Has caido!",300,300);
  textSize(50);
  fill(#000000);
  text("Aun te quedan "+ life +" vidas", 270, 400);
  if(t == 0){
    screen = "onGame";
  }
  
}

void extraLife(){
  
  textSize(80 );  
  fill(#E55233);
  text("Extra life!",350,250);
  image(heart,430,280);
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);
  if(t == 0){
    screen = "onGame";
  }
  
}
