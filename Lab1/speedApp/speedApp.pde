import ketai.sensors.*;

KetaiSensor sensor;


float halt=0;

String mode="screen3";
String time = "10";
int t;
int interval = 50;

void setup()
{
  fullScreen();  
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 36);
}

void draw(){
  
  switch(mode){
    case "screen1":
      screen1();
    case "screen2":
      screen2();
    case "screen3":
      screen3();
    case "screen4":
      screen4();
  }
}


void screen1(){
}

void screen2(){
}

void screen3(){ //Timer
  background(78, 93, 75);
  
  t = interval-int(millis()/1000);
  time = nf(t , 2);
  
  if(t == 0){
    mode="screen4";
  }
  text("0:"+time,0, 0, width, height);
}


void screen4(){ //Calling

}



void onAccelerometerEvent(float x, float y, float z){
  halt=x+y+z;
}
