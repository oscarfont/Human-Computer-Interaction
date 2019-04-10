// Libraries
import ketai.sensors.*;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.media.*;
import android.content.res.*;
import android.content.Context;
 
MediaPlayer snd = new MediaPlayer();
//AssetManager assets = this.getAssets();
AssetFileDescriptor fd;
Context context;
Button bPlay;
// Variables
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

KetaiSensor sensor;
float halt=0;
//ESTAMOS UTILIZANDO ESTO PARA MOSTRAR LAS DIF VIEWS 
String mode;
String time = "10";
int t;
int interval = 50;

// Processing methods: setup and draw
void setup()
{
   mode = "screen1";
   fullScreen();
   //fullScreen();
   
   manager = new AccelerometerManager();
   sensor = new KetaiSensor(this);
   sensor.start();
   requestPermission("android.permission.CALL_PHONE");
   orientation(PORTRAIT);
}

void draw(){
  switch(mode){
    case "screen1":
      screen1();
      break;
    case "screen2":
      screen2();
      break;
    case "screen3":
      screen3();
      break;
    case "screen4":
      screen4();
      break;
    case "screen5":
      screen5();
      break;
    default:
      break;
  }
}


// OUR Screens and other methods

// Mthod to show images
void showImage(){
  if(mode.equals("screen1")){
    image(car_icon,175,200,150,150);
  }else if (mode.equals("screen2")){
    image(arrow_icon,190,270,150,150);
  }else if(mode.equals("screen5")){
    image(ok_icon,190,270,150,150);
  }
}

// Start Screen
void screen1(){ 
  smooth();
  background(59, 129, 250);
  start_button = new Button("Empezar marcha", 150, 400, 200, 70);
  textAlign(CENTER, CENTER);
  start_button.buttonDraw();
  car_icon = loadImage("car2.png");
  showImage();
  if(start_button.isClicked()){
    mode = "screen2";
    initialTime = int(millis()/1000);
  }
}

// Speed Screen
void screen2(){
  background(59, 129, 250);
  arrow_icon = loadImage("arrow.png");
  showImage();
  text("Velocidad: " + nfp(halt, 1, 3), 0, 100, width, height);
  fill(#FFFFFF);
  // TODO: Determine the way we change from screen2 to screen3
  if(halt>=20.0 || halt <=-20.0){
    mode = "screen3";
  }
}

// Timer Screen
void screen3(){ 
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);

  t = interval-(int(millis()/1000)-initialTime);
  time = nf(t , 2);
  
  // If timer ends, change to screen 4
  if(t == 0){
    if(hasPermission("android.permission.CALL_PHONE")){
      makeCall();
    }
    mode="screen4";
  }
  
  if(t%2 == 0){
     background(252,83,86);
     fill(#FFFFFF);
  }else{
     background(255,255,255);
     fill(#000000);
  }
  text("0:"+time,0, 0, width, height);
  
  okay_button = new Button("Estoy bien", 150, 500, 200, 70);
  okay_button.buttonDraw();
  
  // If user clicks button, change to screen 2
  if(okay_button.isClicked()){
    mode = "screen5";
    interval=50;
  }
}

// Phone Call Screen
void screen4(){

  background(252,83,86);
  textSize(30);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Llamando al 112...", 250,300);
  
  // TODO: Send Location
  
  end_button = new Button("Finalizar Llamada", 150, 500, 200, 70);
  end_button.buttonDraw();
  // If user clicks, ends call and goes to screen1
  if(end_button.isClicked()){
    mode = "screen1";
  }
}

// Okay Screen
void screen5(){
  background(59, 129, 250);
  ok_icon = loadImage("ok.png");
  showImage();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(20);
  text("Reestablecido correctamente",270,500);
  delay(10000);
  mode = "screen1";
}

// make phone call
void makeCall(){
    Intent callIntent = new Intent(Intent.ACTION_CALL);
    callIntent.setData(Uri.parse("tel:"+112));
    startActivity(callIntent);
}

// Accelerometer Event Function
void onAccelerometerEvent(float x, float y, float z){
  halt=x+y+z-9.7;
}