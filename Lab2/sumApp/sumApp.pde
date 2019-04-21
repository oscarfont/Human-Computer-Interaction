import processing.sound.*;
import java.util.Map;

boolean[] keys;
boolean start = false;
int[][] setOperations = { {3,3,6,0}, {3,1,2,1}, {6,3,9,0}, {5,2,3,1},{8,2,10,0} }; //Les 3 primeres xifres son els numeros de la operació, l'ultima indica si es suma 0 o resta 1
int operation = 0;
int firstNumber = 2;
int secondNumber = 1;
int result = 3;
int sign = 0;
String operationString = "";
String screen = "homeScreen";
SoundManager manager;
int initialTime;
PImage bg;
PFont font;


void setup() {
    size(1200,700);
    keys = new boolean[3];
    manager = new SoundManager();
    manager.addSound("correct", new SoundFile(this,"correct.mp3"));
    manager.addSound("wrong", new SoundFile(this,"wrong.mp3"));
    initialTime = int(millis()/1000);
    font = createFont("orange.ttf",50);
    bg = loadImage("board.png");
  }
void draw() {
    textFont(font);
    background(bg);
    switch (screen) {
        case "homeScreen":
            homeScreen();
            break;

        case "operationScreen":
            operationScreen();
            break;

        case "correctScreen":
            correctScreen();
            break;

        case "creditsScreen":
            creditsScreen();
            break;

    }


}

void keyPressed() {
    if (key == 'q')
        keys[0] = true;
    if (key == 'w')
        keys[1] = true;
    if (key == 'e')
        keys[2] = true;
    if(key == 32){
        start = true;
    }
}

void keyReleased() {
    if (key == 'q')
        keys[0] = false;
    if (key == 'w')
        keys[1] = false;
    if (key == 'e')
        keys[2] = false;
}

void drawSum() {
    int value = numKeys();

    if (value == 0) {
        textSize(130);
        fill(#FFFFFF);
        text(firstNumber + " + _ = " + result, 420, 330);

    } else {
        if (value == secondNumber) {
            operationString = str(firstNumber) + " + " + str(value) + " = " + str(result);
            text(operationString, 420, 330);
            screen = "correctScreen";
        } else {
            operationString = str(firstNumber) + " + " + str(value) + " = " + str(result);
            textSize(130);
            fill(#FFFFFF);
            text(operationString,420,330);
            fill(#FF1E00);
            textSize(150);
            text("Incorrecto!",300,450);
            fill(#079DFF);
            textSize(50);
            text("¡Fíjate bien en las piezas que pones en la base!",120,540);
            //manager.playSound("wrong");
            //manager.stopSound();
        }
    }
}

void drawSub() {
    int value = numKeys();

    if (value == 0) {
        textSize(130);
        fill(#FFFFFF);
        text(firstNumber + " - _ = " + result, 420, 330);
    } else {
        if (value == secondNumber) {
            operationString = str(firstNumber) + " - " + str(value) + " = " + str(result);
            text(operationString, 420, 330);
            screen = "correctScreen";

        } else {
            operationString = str(firstNumber) + " - " + str(value) + " = " + str(result);
            textSize(130);
            fill(#FFFFFF);
            text(operationString,420,330);
            fill(#FF1E00);
            textSize(150);
            text("Incorrecto!",300,450);
            fill(#079DFF);
            textSize(50);
            text("¡Fíjate bien en las piezas que pones en la base!",120,540);
            //manager.playSound("wrong");
            //manager.stopSound();
        }
    }
}

void homeScreen() {
    // PONER INSTRUCCIONES EN LA HOME SCREEN
    textSize(150);
    fill(#FFFFFF);
    text("SumApp",320,300);
    
    int t = (int(millis()/1000)-initialTime);
    if(t%2 == 0){
       fill(#FFFFFF);
    }else{
       fill(#079DFF);
    }
    textSize(50);
    text("Pulsa espacio para empezar", 300, 400);
    if(start){
      screen = "operationScreen";
    }
}

void operationScreen() {
    if (operation < setOperations.length) {

        switch (sign) {
            case 0: //suma
                drawSum();
                break;

            case 1: //resta
                drawSub();
                break;
        }

    } else {
        screen = "creditsScreen";
    }
}


void correctScreen() {
    int value = numKeys();
    manager.playSound("correct");
    textSize(130);
    fill(#FFFFFF);
    text(operationString,420,330);
    fill(#46B63F);
    textSize(150);
    text("Correcto!",300,450);
    fill(#079DFF);
    textSize(60);
    text("Saca todas las piezas de la base", 200, 550);
    
    if (value == 0) {
        screen = "operationScreen";
        manager.stopSound();
        changeOperation();
    }
}


void creditsScreen() {
    fill(#FFFFFF);
    text("Credits: Daniel Roig & @ofont99 \n & Estefania Cons", 150, 330);
}

void changeOperation() {
    firstNumber = setOperations[operation][0];
    secondNumber = setOperations[operation][1];
    result = setOperations[operation][2];
    sign = setOperations[operation][3];
    operation++;
}

int numKeys() {
    int num = 0;
    for (int i = 0; i < keys.length; i++) {
        if (keys[i] == true) {
            num++;
        }
    }
    return num;
}
