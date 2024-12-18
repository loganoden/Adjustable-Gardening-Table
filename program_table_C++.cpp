#include <Arduino.h>
#include "pin-assignments.h"

// Constants
const int BUTTON_THRESHOLD = 100;  // Analog reading threshold for button press
const int MOTOR_SPEED = 255;       // Motor speed (0-255)
const float HEIGHT_INCREMENT = 0.1; // Height change per cycle
const float MAX_HEIGHT = 9.0;      // Maximum height in inches
const float MIN_HEIGHT = 0.0;      // Minimum height in inches

// Variables
float currentHeight = 0.0;
unsigned long lastMoveTime = 0;
const int MOVE_DELAY = 50; // Delay between movements in milliseconds

void setup() {
  // Initialize serial communication for debugging
  Serial.begin(9600);
  
  // Configure motor control pins
  pinMode(MOTOR_A_SPEED, OUTPUT);
  pinMode(MOTOR_A_DIR1, OUTPUT);
  pinMode(MOTOR_A_DIR2, OUTPUT);
  pinMode(MOTOR_A_STANDBY, OUTPUT);
  
  pinMode(MOTOR_B_SPEED, OUTPUT);
  pinMode(MOTOR_B_DIR1, OUTPUT);
  pinMode(MOTOR_B_DIR2, OUTPUT);
  pinMode(MOTOR_B_STANDBY, OUTPUT);
  
  pinMode(MOTOR_C_SPEED, OUTPUT);
  pinMode(MOTOR_C_DIR1, OUTPUT);
  pinMode(MOTOR_C_DIR2, OUTPUT);
  pinMode(MOTOR_C_STANDBY, OUTPUT);
  
  pinMode(MOTOR_D_SPEED, OUTPUT);
  pinMode(MOTOR_D_DIR1, OUTPUT);
  pinMode(MOTOR_D_DIR2, OUTPUT);
  pinMode(MOTOR_D_STANDBY, OUTPUT);
  
  // Initialize all motors to stopped state
  stopAllMotors();
  
  Serial.println("Table Control System Initialized");
}

void loop() {
  // Read button states
  int upValue = analogRead(UP_BUTTON);
  int downValue = analogRead(DOWN_BUTTON);
  
  // Check if enough time has passed since last movement
  if (millis() - lastMoveTime >= MOVE_DELAY) {
    
    // Debug output
    Serial.print("Up Button: ");
    Serial.print(upValue);
    Serial.print(" Down Button: ");
    Serial.println(downValue);
    
    // Process button inputs
    bool upPressed = (upValue > BUTTON_THRESHOLD);
    bool downPressed = (downValue > BUTTON_THRESHOLD);
    
    // Ensure only one button is pressed
    if (upPressed && !downPressed && currentHeight < MAX_HEIGHT) {
      moveTableUp();
      currentHeight += HEIGHT_INCREMENT;
      Serial.print("Moving Up. Height: ");
      Serial.println(currentHeight);
    }
    else if (downPressed && !upPressed && currentHeight > MIN_HEIGHT) {
      moveTableDown();
      currentHeight -= HEIGHT_INCREMENT;
      Serial.print("Moving Down. Height: ");
      Serial.println(currentHeight);
    }
    else {
      stopAllMotors();
    }
    
    lastMoveTime = millis();
  }
}

void moveTableUp() {
  // Enable all motors
  digitalWrite(MOTOR_A_STANDBY, HIGH);
  digitalWrite(MOTOR_B_STANDBY, HIGH);
  digitalWrite(MOTOR_C_STANDBY, HIGH);
  digitalWrite(MOTOR_D_STANDBY, HIGH);
  
  // Set direction for upward movement
  setMotorUp(MOTOR_A_DIR1, MOTOR_A_DIR2, MOTOR_A_SPEED);
  setMotorUp(MOTOR_B_DIR1, MOTOR_B_DIR2, MOTOR_B_SPEED);
  setMotorUp(MOTOR_C_DIR1, MOTOR_C_DIR2, MOTOR_C_SPEED);
  setMotorUp(MOTOR_D_DIR1, MOTOR_D_DIR2, MOTOR_D_SPEED);
}

void moveTableDown() {
  // Enable all motors
  digitalWrite(MOTOR_A_STANDBY, HIGH);
  digitalWrite(MOTOR_B_STANDBY, HIGH);
  digitalWrite(MOTOR_C_STANDBY, HIGH);
  digitalWrite(MOTOR_D_STANDBY, HIGH);
  
  // Set direction for downward movement
  setMotorDown(MOTOR_A_DIR1, MOTOR_A_DIR2, MOTOR_A_SPEED);
  setMotorDown(MOTOR_B_DIR1, MOTOR_B_DIR2, MOTOR_B_SPEED);
  setMotorDown(MOTOR_C_DIR1, MOTOR_C_DIR2, MOTOR_C_SPEED);
  setMotorDown(MOTOR_D_DIR1, MOTOR_D_DIR2, MOTOR_D_SPEED);
}

void setMotorUp(int dir1Pin, int dir2Pin, int speedPin) {
  digitalWrite(dir1Pin, HIGH);
  digitalWrite(dir2Pin, LOW);
  analogWrite(speedPin, MOTOR_SPEED);
}

void setMotorDown(int dir1Pin, int dir2Pin, int speedPin) {
  digitalWrite(dir1Pin, LOW);
  digitalWrite(dir2Pin, HIGH);
  analogWrite(speedPin, MOTOR_SPEED);
}

void stopAllMotors() {
  // Disable all motors via standby pins
  digitalWrite(MOTOR_A_STANDBY, LOW);
  digitalWrite(MOTOR_B_STANDBY, LOW);
  digitalWrite(MOTOR_C_STANDBY, LOW);
  digitalWrite(MOTOR_D_STANDBY, LOW);
  
  // Stop all motors
  analogWrite(MOTOR_A_SPEED, 0);
  analogWrite(MOTOR_B_SPEED, 0);
  analogWrite(MOTOR_C_SPEED, 0);
  analogWrite(MOTOR_D_SPEED, 0);
}
