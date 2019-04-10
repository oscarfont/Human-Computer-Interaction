// Libraries
import ketai.sensors.*;
import ketai.ui.*;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.media.*;
import android.content.res.*;
import android.content.Context;
import android.telephony.SmsManager;
import processing.sound.*;
 
//MediaPlayer snd = new MediaPlayer();
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
boolean message_sent = false; // FLAG para controlar que solo se envie un mensaje
PImage car_icon;
PImage arrow_icon;
PImage ok_icon;
SoundFile sound;

int initialTime;

KetaiSensor sensor;
float halt=0;
//ESTAMOS UTILIZANDO ESTO PARA MOSTRAR LAS DIF VIEWS 
String mode;
String time = "10";
int t;
int interval = 50;

// Geolocation
double longitude, latitude, altitude;
KetaiLocation location;
KetaiVibrate vibe;

// Processing methods: setup and draw
void setup()
{
   mode = "screen1";
   fullScreen();
   sound = new SoundFile(this, "test.mp3");
   sensor = new KetaiSensor(this);
   location = new KetaiLocation(this);
   vibe = new KetaiVibrate(this);
   sensor.start();
   requestPermission("android.permission.CALL_PHONE");
   requestPermission("android.permission.ACCESS_FINE_LOCATION");
   requestPermission("android.permission.SEND_SMS");
   requestPermission("android.permission.VIBRATE");
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
    image(car_icon,(width/2)-250,(height/2)-400,500,500);
  }else if (mode.equals("screen2")){
    image(arrow_icon,(width/2)-250,(height/2)-400,500,500);
  }else if(mode.equals("screen5")){
    image(ok_icon,(width/2)-250,(height/2)-400,500,500);
  }
}

// Start Screen
void screen1(){ 
  sound.stop();
  smooth();
  background(59, 129, 250);
  start_button = new Button("Empezar marcha", (width/2)-290, (height/2)+150, 600, 200);
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
  sound.stop();
  background(59, 129, 250);
  arrow_icon = loadImage("arrow.png");
  showImage();
  text("Velocidad: " + nfp(halt, 1, 3), 0, 100, width, height);
  fill(#FFFFFF);
  // TODO: Determine the way we change from screen2 to screen3
  if(halt>=20.0 || halt <=-20.0){
    mode = "screen3";
    sound.play();
    
  }
}

// Timer Screen
void screen3(){ 
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  
  vibe.vibrate(1000);


  t = interval-(int(millis()/1000)-initialTime);
  time = nf(t , 2);
  // If timer ends, change to screen 4
  if(t == 0){
    mode="screen4";
    makeCall();
  }
  
  if(t%2 == 0){
     background(252,83,86);
     fill(#FFFFFF);
  }else{
     background(255,255,255);
     fill(#000000);
  }
  textSize(100);
  text("0:"+time,0, 0, width, height);
  
  okay_button = new Button("Estoy bien", (width/2)-290, (height/2)+400, 600, 200);
  okay_button.buttonDraw();
  
  // If user clicks button, change to screen 2
  if(okay_button.isClicked()){
    mode = "screen5";
  }
}

// Phone Call Screen
void screen4(){
  sound.stop();
  background(252,83,86);
  textSize(60);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Llamando al 112...", width/2,height/2);
  // TODO: Send Location
  String msg = "ESTO ES UN SMS DE PRUEBA, CALMA ;) Latitude: " + latitude + " Longitude: " + longitude + " Altitude: " + altitude;
  String numero = "0";
  //sendSMS(numero,msg);
  end_button = new Button("Finalizar Llamada", (width/2)-290, (height/2)+150, 600, 200);
  end_button.buttonDraw();
  // If user clicks, ends call and goes to screen1
  if(end_button.isClicked()){
    mode = "screen1";
  }
}

// Okay Screen
void screen5(){
  sound.stop();
  vibe.stop();
  println("entra");
  background(59, 129, 250);
  ok_icon = loadImage("ok.png");
  showImage();
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(20);
  text("Reestablecido correctamente",270,500);
  mode = "screen1";
}

// make phone call
void makeCall(){
  if(hasPermission("android.permission.CALL_PHONE")){
    Intent callIntent = new Intent(Intent.ACTION_CALL);
    callIntent.setData(Uri.parse("tel:"+112));
    startActivity(callIntent);
  }
}

// send SMS
public void sendSMS(String phoneNo, String msg) {
  if(hasPermission("android.permission.SEND_SMS") && message_sent == true){
    try {      
        SmsManager smsManager = SmsManager.getDefault();
        smsManager.sendTextMessage(phoneNo, null, msg, null, null);    
        println("MESSAGE SENT");
    } catch (Exception ex) {
        println(ex.getMessage().toString());
        ex.printStackTrace();
    }   
  }
}

// Function to get Accelerometer coordinates
void onAccelerometerEvent(float x, float y, float z){
  halt=x+y+z-9.7;
}

// Function to get GPS coordinates
void onLocationEvent(double _latitude, double _longitude, double _altitude)
{
  longitude = _longitude;
  latitude = _latitude;
  altitude = _altitude;
  println("lat/lon/alt: " + latitude + "/" + longitude + "/" + altitude);
}

// print location or error message
void printLocation(){
  if (location == null  || location.getProvider() == "none")
    text("Location data is unavailable. \n" +
      "Please check your location settings.", 0, 0, width, height);
  else
    text("Latitude: " + latitude + "\n" + 
      "Longitude: " + longitude + "\n" + 
      "Altitude: " + altitude + "\n" + 
      "Provider: " + location.getProvider(), 0, 0, width, height);  
}
