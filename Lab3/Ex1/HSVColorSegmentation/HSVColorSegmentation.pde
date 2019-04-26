/*Before running this code install P5 and OpenCV for processing*/
import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.core.Scalar;
import controlP5.*;

Scalar mLowerBound = new Scalar(0);
Scalar mUpperBound = new Scalar(0);
    
ControlP5 cp5;
int sliderMinHue=100;
int sliderMaxHue=150;
int sliderMinSat=120;
int sliderMaxSat=200;
int sliderMinVal=30;
int sliderMaxVal=200;
PImage img;
PImage result;

OpenCV opencv;


int lowerb = 50;
int upperb = 100;
Mat mask;

void setup() {
  size(1024, 768);
  result = new PImage();
  cp5 = new ControlP5(this);


     
     
     
  img = loadImage("hsv_samples.jpg");
  
  opencv = new OpenCV(this, img);
  opencv.useColor(HSB);
  
  
  

}

void draw() {
  /*            Uncomment to debug slidebars
  print("(minH,maxH)=("+sliderMinHue+","+sliderMaxHue+") --- ");
  print("(minS,maxS)=("+sliderMinSat+","+sliderMaxSat+") ---");
  println("(minV,maxV)=("+sliderMinVal+","+sliderMaxVal+") ---");*/
  
  mLowerBound.val[0]= sliderMinHue;
  mUpperBound.val[0]= sliderMaxHue;
  mLowerBound.val[1]= sliderMinSat;
  mUpperBound.val[1]= sliderMaxSat;
  mLowerBound.val[2]= sliderMinVal;
  mUpperBound.val[2]= sliderMaxVal;
  
  mask = opencv.matHSV.clone();
  org.opencv.core.Core.inRange(opencv.matHSV, mLowerBound, mUpperBound, mask); //image binarizarion using H,S,V channels at the same time
  
  opencv.toPImage(mask,result); 
  opencv.loadImage(img);
  
  image(img, 0, 0);
  //-------------------------------------------------------
  //the opencv wrapper for processing only allows to use inRange in a single channell.
  //  opencv.setGray(opencv.getH().clone());
  //  opencv.inRange(sliderMinHue, sliderMaxHue); 
  //image(opencv.getOutput(), 3*width/4, 3*height/4, width/4,height/4);
  //-------------------------------------------------------
  image(opencv.getSnapshot(mask), 3*width/4, 3*height/4, width/4,height/4);
}
