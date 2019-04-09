import ketai.sensors.*;

Button start_button;  // the button
Button okay_button;
Button end_button;
boolean start_buttonOver = false;
boolean alarm_buttonOver = false;
boolean start_image = true;
PImage car_icon;
PImage arrow_icon;
PImage ok_icon;

int initialTime;
int m;

KetaiSensor sensor;
float halt=0;
//ESTAMOS UTILIZANDO ESTO PARA MOSTRAR LAS DIF VIEWS 
String mode = "screen1";
String time = "10";
int t;
int interval = 50;

void setup()
{
   mode = "screen1";
   size (500, 700);
   initialTime = millis();
  
  //sensor = new KetaiSensor(this);
  //sensor.start();


}


void showImage(){
  if(mode.equals("screen1")){
    image(car_icon,175,200,150,150);
  }else if (mode.equals("screen2")){
    image(arrow_icon,190,270,150,150);
  }else if(mode.equals("screen5")){
    image(ok_icon,190,270,150,150);
  }
}


void draw(){
  
  switch(mode){
    case "screen1":
      screen1();
    //case "screen2":
     // screen2();
    //case "screen3":
     //  screen3();
      //  m = millis();
   //case "screen4":
    // screen4();
    //case "screen5":
     //screen5();
  }
}


void screen1(){
  
  smooth();
  background(59, 129, 250);
  start_button = new Button("Empezar marcha", 150, 400, 200, 70);
  textAlign(CENTER, CENTER);
  start_button.buttonDraw();
  car_icon = loadImage("car2.png");
  showImage();


}

void screen2(){
  background(59, 129, 250);
  arrow_icon = loadImage("arrow.png");
  showImage();

  
}

void screen3(){ //Timer
  orientation(PORTRAIT);
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  background(252,83,86);
  if(initialTime+150 < m ){
    background(255);
    initialTime = millis();
  }
  
  
  t = interval-int(millis()/1000);
  time = nf(t , 2);
  
  if(t == 0){
    mode="screen4";
  }
  text("0:"+time,0, 0, width, height);
  okay_button = new Button("Estoy bien", 150, 500, 200, 70);
  okay_button.buttonDraw();
}


void screen4(){ //Calling

  background(252,83,86);
  textSize(30);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Llamando al 112...", 250,300);
  end_button = new Button("End", 150, 500, 200, 70);
  end_button.buttonDraw();

}

void screen5(){
  background(59, 129, 250);
  ok_icon = loadImage("ok.png");
  showImage();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(20);
  text("Reestablecido correctamente",270,500);

}


void onAccelerometerEvent(float x, float y, float z){
  halt=x+y+z;
}
