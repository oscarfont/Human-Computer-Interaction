class AccelerometerManager{
  // Attributes
  float V0x,V0y,V0z;
  float Vx, Vy, Vz;
  
  // Constructor
  AccelerometerManager(){
    V0x = 0.0;
    V0y = 0.0;
    V0z = 0.0;
  }
  // update speeds
  void update(float newV0x, float newV0y, float newV0z){
    V0x = newV0x;
    V0y = newV0y;
    V0z = newV0z;
  }
  
  // Compute Speeds
  float speedX(float ax){ Vx = V0x + ax; return Vx; }
  float speedY(float ay){ Vy = V0y + ay; return Vy; }
  float speedZ(float az){ Vz = V0z + az; return Vz; }
  float speed(){return sqrt(Vx+Vy+Vz);}
  
  // restart
  void restart(){
    V0x = 0.0;
    V0y = 0.0;
    V0z = 0.0;
  }
}
