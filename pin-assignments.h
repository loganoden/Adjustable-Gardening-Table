#ifndef ARDUINO_H
#define ARDUINO_H

// Button pins (Analog inputs for force sensitive resistors)
#define UP_BUTTON A0    // Up button connected to analog pin A0
#define DOWN_BUTTON A1  // Down button connected to analog pin A1

// Motor A pin definitions
#define MOTOR_A_SPEED 2   // PWM pin for speed control
#define MOTOR_A_DIR1 4    // Direction control 1
#define MOTOR_A_DIR2 3    // Direction control 2
#define MOTOR_A_STANDBY 5 // Standby control

// Motor B pin definitions
#define MOTOR_B_SPEED 8    // PWM pin for speed control
#define MOTOR_B_DIR1 7     // Direction control 1
#define MOTOR_B_DIR2 6     // Direction control 2
#define MOTOR_B_STANDBY 39 // Standby control

// Motor C pin definitions
#define MOTOR_C_SPEED 9    // PWM pin for speed control
#define MOTOR_C_DIR1 41    // Direction control 1
#define MOTOR_C_DIR2 43    // Direction control 2
#define MOTOR_C_STANDBY 45 // Standby control

// Motor D pin definitions
#define MOTOR_D_SPEED 10   // PWM pin for speed control
#define MOTOR_D_DIR1 29    // Direction control 1
#define MOTOR_D_DIR2 31    // Direction control 2
#define MOTOR_D_STANDBY 33 // Standby control

#endif // ARDUINO_H
