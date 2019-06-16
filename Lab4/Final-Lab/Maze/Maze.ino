
 /**
 * infra red : 6
 * touch: 13
 * screen: 11
 * led bar: 8
 * sound: 7
 * holes: 2
 */
 
#include <SerialLCD.h>
#include <SoftwareSerial.h> 
#include <Grove_LED_Bar.h>


static int VALUE = 5;
static int VALUE_LED = 10;
static bool FLAG = false;
const int TouchPin=13;
const int holePin = 2;
const int infrared = 6;
const int buzzer = 7;
int holeStatus = 0;
int COUNTER = 6000;


SerialLCD slcd(11,12);
Grove_LED_Bar bar(9, 8, 0);  // Clock pin, Data pin, Orientation


void setup() {
  
  pinMode(TouchPin, INPUT);
  pinMode(holePin, INPUT);
  slcd.begin();
  bar.begin();
  Serial.begin(9600);
  pinMode(infrared,INPUT);
  pinMode(buzzer, OUTPUT);
  // Turn on all the leds
  for (int i = VALUE+1; i  < 11; i++) {
    bar.setLed(i, 1);  
  }  
  
}

void buzzer() {
  digitalWrite(buzzer, HIGH);
  delay(90);
  digitalWrite(buzzer, LOW);
}

void gameOverLed() {
  slcd.clear();
  slcd.print("    GAME OVER");
  bar.setLed(0, 1);  
  for (int i = 10; i > VALUE; i--) {
        bar.setLed(i, 0);  
  }
}

void resetGame() {
  gameOverLed();
  while (1) {
    int sensorValue = digitalRead(TouchPin);
    if(sensorValue==1) {
      buzzer();
      asm volatile ("  jmp 0");
    }
  }
}

void loop() {
  if (COUNTER == 0) {
      resetGame();
  }
    holeStatus = digitalRead(holePin);
    slcd.setCursor(0, 0);
    char cstr[16];
    itoa(COUNTER/100, cstr, 10);
    String linea = "Time : " + String(cstr);
    char array[linea.length() - 2];
    linea.toCharArray(array, linea.length() - 2);
    slcd.print(" Time : ");
    slcd.print(cstr);       
    COUNTER--;
    if(digitalRead(6) == LOW){
      while(1){
        bar.setLed(VALUE,0);
        slcd.clear();
        slcd.print("    YOU WIN!");
        delay(3000);
      }
   }
    if(holeStatus==HIGH)  {
      Serial.println(FLAG);
      Serial.println("Somebody is here." + String(VALUE));
      if (FLAG) {
        if (VALUE == 1) {
          buzzer();
          bar.setLed(VALUE,0);
          resetGame();
        }
        bar.setLed(VALUE_LED,0);
        VALUE--;
        VALUE_LED--;
        FLAG = false;
      }
    } else {
      Serial.println("Nobody.");
      if (!FLAG) {
        FLAG = true;
        slcd.setCursor(0, 1);
      }
    }
}
