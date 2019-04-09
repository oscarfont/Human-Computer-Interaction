import ketai.sensors.*;

KetaiSensor sensor;
float velocidad=0;
float vx=0;
float vy=0;
float vz=0;

float ax=0;
float ay=0;
float az=0;

void setup()
{
  fullScreen();  
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(displayDensity * 36);
}

void draw(){
  background(78, 93, 75);
  text("Velocidad: " + nfp(velocidad, 1, 3), 0, 0, width, height);
}


void onAccelerometerEvent(float x, float y, float z, long a, int b){
  
  vx= x + ax;
  vy= y + ay;
  vz= z + az;
  
  ax=x;
  ay=y;
  az=z;
  
  velocidad=sqrt(sq(vx)+sq(vy)+sq(vz)); 
  
  //Mai es 0 perque sempre suma a x, y o z (depen de com estigui el telefon), 
  //9.7 que es laceleracio de la gravetat. No se si al final podriem afegir -19 que es el que hi ha quan esta parat
}
