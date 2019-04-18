boolean[] keys;
int[][] setOperations = { {3,3,6,0}, {3,1,2,1}, {6,3,9,0}, {5,2,3,1}, {8,2,10,0} }; //Les 3 primeres xifres son els numeros de la operació, l'ultima indica si es suma 0 o resta 1
int operation = 0;
int firstNumber = 2;
int secondNumber = 1;
int result = 3;
int sign = 0;
boolean correctScreen = false;
String operationString = "";

void setup() {
    size(200, 200);
    background(255);
    keys = new boolean[3];
    fill(0);
}
void draw() {
    background(255);
    textSize(32);
    if (operation < setOperations.length) {
        if (correctScreen) {
            correctScreen();
        } else {
            switch (sign) {
                case 0: //suma
                    drawSum();
                    break;

                case 1: //resta
                    drawSub();
                    break;
            }
        }
    } else {
        text("Credits: Daniel Roig", 10, 30);
    }
}

void keyPressed() {
    if (key == 'q')
        keys[0] = true;
    if (key == 'w')
        keys[1] = true;
    if (key == 'e')
        keys[2] = true;
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
            correctScreen = true;
        } else {
            fill(0, 102, 153);
            text(firstNumber + " + " + value + " = " + result, 10, 30);
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
            correctScreen = true;

        } else {
            fill(0, 102, 153);
            text(firstNumber + " - " + value + " = " + result, 10, 30);
        }
    }
}

void correctScreen() {
    int value = numKeys();
    text(operationString + "\nCorrecto! \nSaca todas las piezas de la base", 10, 30);

    if (value == 0) {
        correctScreen = false;
        changeOperation();
    }
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
