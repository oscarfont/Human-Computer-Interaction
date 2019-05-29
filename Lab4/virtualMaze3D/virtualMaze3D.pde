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
boolean onGame = false;
String screen = "homeScreen";
PFont font;
PImage bg;
PImage heart;

// Sons
SoundFile fallSound;
SoundFile gainLifeSound;
SoundFile winSound;
SoundFile loseSound;

void setup() {
    size(1100,612);
    font = createFont("Righteous-Regular.ttf",50);
    bg = loadImage("home.png");
    heart = loadImage("heart2.png");
    fallSound = new SoundFile(this,"ball_bouncing.mp3");
    loseSound = new SoundFile(this,"lose.mp3");
    winSound = new SoundFile(this,"win.mp3");
    gainLifeSound = new SoundFile(this,"gainLife.mp3");
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
        case "winScreen":
            youWin();
            break;
    }
}

void keyPressed() {
  
    // L'usuari només pot: perdre o conseguir vides i guanyar la partida només si està jugant
    if(onGame){
      if (key == 'q'){ //hole
      life--;
        if(life!=0){
          initialTime2 = int(millis()/1000);
          fallSound.play();
          screen = "fallingBall";
        }else{
          loseSound.play();
        }
      }
    
      if (key == 'w'){
          if(!extra_life){
            extra_life = true;
            gainLifeSound.play();
            life++;
            initialTime2 = int(millis()/1000);
            screen = "extraLife";
          } 
      }
    
      if (key == 'e'){
          winSound.play();
          screen = "winScreen";
      }
    }
    //if(!loseSound.isPlaying() || !winSound.isPlaying()){A vegades va bé i altres no :(
      if(key == 32){
          start = true;
      //}
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
    onGame = true;
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
  
  onGame = false;
  textSize(90);  
  fill(#E55233);
  text("¡Has Perdido!",250,300);
  textSize(35);
  int tcolor =(millis()/1000)-initialTime;
  if(tcolor%2 == 0){
      fill(#ff884d);
  }else{
      fill(#000000);
  }
  //if(!loseSound.isPlaying()) A vegades va bé i altres no :(
  text("Pulsa espacio para empezar", 310, 400);
  if(start){
    //Reinicio variables
      life=3; 
      extra_life = false;
      initialTime = int(millis()/1000);
      onGame = true;
      screen = "onGame";
   }
}

void fallingBall(){
  
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);
  textSize(90);
  fill(#E55233);
  text("¡Has caido!",300,300);
  textSize(50);
  fill(#000000);
  text("Aún te quedan "+ life +" vidas", 280, 400);
  if(t == 0 /*&& !fallSound.isPlaying() A vegades va bé i altres no :(*/){
    screen = "onGame";
  }
  
}

void youWin(){
  
  onGame = false;
  textSize(90);  
  fill(#E55233);
  text("¡Has ganado!",260,300);
  textSize(25);  
  fill(#E55233);
  text("Has completado el nivel con " + life + " vidas restantes",270,350);
  int timeLasted = interval - t;
  textSize(25);  
  fill(#E55233);
  text("Necesitaste " + timeLasted + " segundos para completarlo",290,400);
  textSize(35);
  int tcolor =(millis()/1000)-initialTime;
  if(tcolor%2 == 0){
    fill(#ff884d);
  }else{
    fill(#000000);
  }
  //if(!winSound.isPlaying()) A vegades va bé i altres no :(
  text("Pulsa espacio para empezar", 300, 450);
  if(start){
    //Reinicio variables
    life=3; 
    extra_life = false;
    initialTime = int(millis()/1000);
    onGame = true;
    screen = "onGame";
  }
}

void extraLife(){
  
  textSize(80);  
  fill(#E55233);
  text("¡Vida extra!",320,250);
  image(heart,430,280);
  t = interval2-(int(millis()/1000)-initialTime2);
  time = nf(t , 2);
  if(t == 0 /*&& !gainLifeSound.isPlaying() A vegades va bé i altres no :( */){
    screen = "onGame";
  }
  
}
