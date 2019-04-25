/*Before running this code install P5 and OpenCV for processing*/
import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.core.Scalar;
import controlP5.*;
import processing.video.*;
import java.awt.*;

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
Capture video;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;


int lowerb = 50;
int upperb = 100;
Mat mask;

color trackBlue = color (0,0,255);

void setup() {
  size(640, 480);
  result = new PImage();     
     
  // img = loadImage("hsv_samples.jpg");
  
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv = new OpenCV(this, video);
  
  opencv.useColor(HSB);
  
  video.start();
  

}

void draw() {
   scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);


  
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
  
  //-------------------------------------------------------
  //the opencv wrapper for processing only allows to use inRange in a single channell.
  //  opencv.setGray(opencv.getH().clone());
  //  opencv.inRange(sliderMinHue, sliderMaxHue); 
  //image(opencv.getOutput(), 3*width/4, 3*height/4, width/4,height/4);
  //-------------------------------------------------------
  image(opencv.getSnapshot(mask), 3*width/4, 3*height/4, width/4,height/4);
  
  
    opencv.gray();
  opencv.threshold(70);

  opencv.getOutput();
  contours = opencv.findContours();
  
  println("found " + contours.size() + " contours");
  
  for (Contour contour : contours) {
    stroke(0, 0, 255);
    contour.draw();
    
        stroke(255, 0, 0);

    beginShape();
    for (PVector point : contour.getPolygonApproximation().getPoints()) {
      vertex(point.x, point.y);
    }
    endShape();
  }

}

void captureEvent(Capture c) {
  c.read();
}
