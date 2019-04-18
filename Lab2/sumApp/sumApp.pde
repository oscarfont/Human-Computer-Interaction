import processing.sound.*;
import java.util.Map;

boolean[] keys;
boolean start = false;
int[][] setOperations = { {3,3,6,0}, {3,1,2,1}, {6,3,9,0}, {5,2,3,1}, {8,2,10,0} }; //Les 3 primeres xifres son els numeros de la operació, l'ultima indica si es suma 0 o resta 1
int operation = 0;
int firstNumber = 2;
int secondNumber = 1;
int result = 3;
int sign = 0;
String operationString = "";
String screen = "homeScreen";
SoundManager manager;
int initialTime;

void setup() {
    size(800, 200);
    background(255);
    keys = new boolean[3];
    manager = new SoundManager();
    manager.addSound("correct", new SoundFile(this,"correct.mp3"));
    manager.addSound("wrong", new SoundFile(this,"wrong.mp3"));
    initialTime = int(millis()/1000);
    fill(0);
}
void draw() {
    background(255);
    textSize(32);

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
            
        case "wrongScreen":
            wrongScreen();
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
        fill(0, 102, 153);
        text(firstNumber + " + _ = " + result, 10, 30);

    } else {
        if (value == secondNumber) {
            fill(33, 255, 0);
            operationString = str(firstNumber) + " + " + str(value) + " = " + str(result);
            text(operationString, 10, 30);
            screen = "correctScreen";
        } else {
            fill(0, 102, 153);
            operationString = str(firstNumber) + " + " + str(value) + " = " + str(result);
            text(operationString, 10, 30);
            screen = "wrongScreen";
        }
    }
}

void drawSub() {
    int value = numKeys();

    if (value == 0) {
        fill(0, 102, 153);
        text(firstNumber + " - _ = " + result, 10, 30);
    } else {
        if (value == secondNumber) {
            fill(33, 255, 0);
            operationString = str(firstNumber) + " - " + str(value) + " = " + str(result);
            text(operationString, 10, 30);
            screen = "correctScreen";

        } else {
            fill(0, 102, 153);
            operationString = str(firstNumber) + " - " + str(value) + " = " + str(result);
            text(operationString, 10, 30);
            screen = "wrongScreen";
        }
    }
}

void homeScreen() {
    // PONER INSTRUCCIONES EN LA HOME SCREEN
    int t = (int(millis()/1000)-initialTime);
    if(t%2 == 0){
       fill(#FFFFFF);
    }else{
       fill(#000000);
    }
    text("Pulsa espacio para empezar", 180, 100);
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
    text(operationString + "\nCorrecto! \nSaca todas las piezas de la base", 10, 30);
    
    if (value == 0) {
        screen = "operationScreen";
        manager.stopSound();
        changeOperation();
    }
}

void wrongScreen() {
    int value = numKeys();
    manager.playSound("wrong");
    text(operationString + "\nIncorrecto! \n¡Fíjate bien en las piezas que pones en la base!", 10, 30);
    
    if (value == 0) {
        screen = "operationScreen";
        manager.stopSound();
    }
}

void creditsScreen() {
    text("Credits: Daniel Roig & @ofont99", 10, 30);
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
