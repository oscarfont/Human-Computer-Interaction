/*Before running this code install P5 and OpenCV for processing*/
import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.core.Scalar;
//import controlP5.*;
// import processing.video.*;
import java.awt.*;

Scalar mLowerBound = new Scalar(0);
Scalar mUpperBound = new Scalar(0);
    
// ControlP5 cp5;
int sliderMinHue=0;
int sliderMaxHue=7;
int sliderMinSat=115;
int sliderMaxSat=130;
int sliderMinVal=114;
int sliderMaxVal=145;
PImage img;
PImage result;

OpenCV opencv;
// Capture video;

ArrayList<Contour> contours;
ArrayList<Contour> polygons;


int lowerb = 50;
int upperb = 100;
Mat mask;

void setup() {
  size(1024, 768);
  result = new PImage();     
     
  img = loadImage("sampleToClean.jpg");
  
  // video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, img);
  opencv.useColor(HSB);
  
  calculate();
}

void calculate() {
  opencv.loadImage(img);

  image(img, 0, 0 );

  noFill();
  // stroke(0, 255, 0);
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
  
  mask = opencv.matHSV.clone(); // mascara del video azul
  org.opencv.core.Core.inRange(opencv.matHSV, mLowerBound, mUpperBound, mask); //image binarizarion using H,S,V channels at the same time
  
  opencv.toPImage(mask,result); 
  
  //-------------------------------------------------------
  //the opencv wrapper for processing only allows to use inRange in a single channell.
  //  opencv.setGray(opencv.getH().clone());
  //  opencv.inRange(sliderMinHue, sliderMaxHue); 
  image(opencv.getSnapshot(mask), 3*width/4, 3*height/4, width/4,height/4);
  //-------------------------------------------------------
//   image(opencv.getSnapshot(mask),0, 0 );

    OpenCV opencv2 = new OpenCV(this, opencv.getSnapshot(mask));

  opencv2.gray();

 opencv2.erode();
 opencv2.dilate();
  contours = opencv2.findContours();
  
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
