class Button {
  String label; // button label
  float x;      // top left corner x position
  float y;      // top left corner y position
  float w;      // width of button
  float h;  // height of button

  // constructor
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
   
  }
  
  void buttonDraw() {
    stroke(255);
    fill(255);   
    rect(x, y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(55);
    text(label, x + (w / 2), y + (h / 2));
    
  }
  
  boolean isClicked(){
    if(mousePressed && mouseX>x && mouseX <x+w && mouseY>y && mouseY <y+h){
      return true;
    }else{
      return false;
    }
  }
}
