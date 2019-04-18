boolean[] keys;
int value=0;
 
 void setup(){
   size(200, 200);
   background(255);
   keys=new boolean[3];
   keys[0]=false;
   keys[1]=false;
   fill(0);
   
 }
 void draw(){
   background(255);
   value=numKeys();
   textSize(32);
   
   if(value==0){
     fill(0, 102, 153);
     text("3 + _ = 6", 10, 30); 
   
   }else{
     if(value==3){
       fill(33, 255, 0);
       text("3 + " + value + " = 6", 10, 30); 
     }else{
     fill(0, 102, 153);
     text("3 + " + value + " = 6", 10, 30);
     } 
   }
 }
 
 void keyPressed(){
   if (key=='q')
     keys[0]=true;
   if (key=='w')
     keys[1]=true;
   if (key=='e')
     keys[2]=true;
 }
 
 void keyReleased(){
   if (key=='q')
     keys[0]=false;
   if (key=='w')
     keys[1]=false;
   if (key=='e')
     keys[2]=false;

 } 


 int numKeys(){
  int num=0;
  for(int i=0;i < keys.length;i++){
     if(keys[i]==true){
       num++;
     }
   }
  return num;
 }
