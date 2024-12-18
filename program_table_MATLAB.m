% Adaptive Gardening Table Control Program
% Hardware Interface: Arduino Mega 2560
% Purpose: Control 4 DC motors for height adjustment using two buttons

% Clear workspace and command window
clear all;
clc;

try
    % Initialize Arduino connection
    a = arduino('COM5', 'Mega2560');
    disp('Arduino connected successfully');
catch ME
    fprintf('Error connecting to Arduino: %s\n', ME.message);
    return;
end

% Button connections (force sensitive resistors)
UP_BUTTON = 'A0';
DOWN_BUTTON = 'A1';

% Motor A connections
MOTOR_A_SPEED = 'D2';    % PWM pin for speed control
MOTOR_A_DIR1 = 'D4';     % Direction control 1
MOTOR_A_DIR2 = 'D3';     % Direction control 2
MOTOR_A_STANDBY = 'D5';  % Standby control

% Motor B connections
MOTOR_B_SPEED = 'D8';    % PWM pin for speed control
MOTOR_B_DIR1 = 'D7';     % Direction control 1
MOTOR_B_DIR2 = 'D6';     % Direction control 2
MOTOR_B_STANDBY = 'D39'; % Standby control

% Motor C connections
MOTOR_C_SPEED = 'D9';    % PWM pin for speed control
MOTOR_C_DIR1 = 'D41';    % Direction control 1
MOTOR_C_DIR2 = 'D43';    % Direction control 2
MOTOR_C_STANDBY = 'D45'; % Standby control

% Motor D connections
MOTOR_D_SPEED = 'D10';   % PWM pin for speed control
MOTOR_D_DIR1 = 'D29';    % Direction control 1
MOTOR_D_DIR2 = 'D31';    % Direction control 2
MOTOR_D_STANDBY = 'D33'; % Standby control

% Constants
BUTTON_THRESHOLD = 0.1;    % Voltage threshold for button press
MOTOR_SPEED = 1;          % Motor speed (0-1)
HEIGHT_INCREMENT = 0.1;    % Height change per cycle
MAX_HEIGHT = 9.0;         % Maximum height in inches
MIN_HEIGHT = 0.0;         % Minimum height in inches

% Initialize current height
currentHeight = 0.0;

% Function to move table up
function moveTableUp(a, motors)
    % Enable all motors
    writeDigitalPin(a, motors.A.standby, 1);
    writeDigitalPin(a, motors.B.standby, 1);
    writeDigitalPin(a, motors.C.standby, 1);
    writeDigitalPin(a, motors.D.standby, 1);
    
    % Set direction and speed for all motors
    setMotorUp(a, motors.A);
    setMotorUp(a, motors.B);
    setMotorUp(a, motors.C);
    setMotorUp(a, motors.D);
end

% Function to move table down
function moveTableDown(a, motors)
    % Enable all motors
    writeDigitalPin(a, motors.A.standby, 1);
    writeDigitalPin(a, motors.B.standby, 1);
    writeDigitalPin(a, motors.C.standby, 1);
    writeDigitalPin(a, motors.D.standby, 1);
    
    % Set direction and speed for all motors
    setMotorDown(a, motors.A);
    setMotorDown(a, motors.B);
    setMotorDown(a, motors.C);
    setMotorDown(a, motors.D);
end

% Function to set motor for upward movement
function setMotorUp(a, motor)
    writeDigitalPin(a, motor.dir1, 1);
    writeDigitalPin(a, motor.dir2, 0);
    writePWMVoltage(a, motor.speed, MOTOR_SPEED);
end

% Function to set motor for downward movement
function setMotorDown(a, motor)
    writeDigitalPin(a, motor.dir1, 0);
    writeDigitalPin(a, motor.dir2, 1);
    writePWMVoltage(a, motor.speed, MOTOR_SPEED);
end

% Function to stop all motors
function stopAllMotors(a, motors)
    % Disable all motors via standby pins
    writeDigitalPin(a, motors.A.standby, 0);
    writeDigitalPin(a, motors.B.standby, 0);
    writeDigitalPin(a, motors.C.standby, 0);
    writeDigitalPin(a, motors.D.standby, 0);
    
    % Stop all motors
    writePWMVoltage(a, motors.A.speed, 0);
    writePWMVoltage(a, motors.B.speed, 0);
    writePWMVoltage(a, motors.C.speed, 0);
    writePWMVoltage(a, motors.D.speed, 0);
end

% Create motor configuration structure
motors = struct();
motors.A = struct('speed', MOTOR_A_SPEED, 'dir1', MOTOR_A_DIR1, 'dir2', MOTOR_A_DIR2, 'standby', MOTOR_A_STANDBY);
motors.B = struct('speed', MOTOR_B_SPEED, 'dir1', MOTOR_B_DIR1, 'dir2', MOTOR_B_DIR2, 'standby', MOTOR_B_STANDBY);
motors.C = struct('speed', MOTOR_C_SPEED, 'dir1', MOTOR_C_DIR1, 'dir2', MOTOR_C_DIR2, 'standby', MOTOR_C_STANDBY);
motors.D = struct('speed', MOTOR_D_SPEED, 'dir1', MOTOR_D_DIR1, 'dir2', MOTOR_D_DIR2, 'standby', MOTOR_D_STANDBY);

% Main control loop
try
    disp('Starting control loop. Press Ctrl+C to stop.');
    while true
        % Read button states
        upValue = readVoltage(a, UP_BUTTON);
        downValue = readVoltage(a, DOWN_BUTTON);
        
        % Process button inputs
        upPressed = (upValue > BUTTON_THRESHOLD);
        downPressed = (downValue > BUTTON_THRESHOLD);
        
        % Display button values for debugging
        fprintf('Up Button: %.3f, Down Button: %.3f\n', upValue, downValue);
        
        % Control logic
        if upPressed && ~downPressed && currentHeight < MAX_HEIGHT
            moveTableUp(a, motors);
            currentHeight = currentHeight + HEIGHT_INCREMENT;
            fprintf('Moving Up. Height: %.2f\n', currentHeight);
        elseif downPressed && ~upPressed && currentHeight > MIN_HEIGHT
            moveTableDown(a, motors);
            currentHeight = currentHeight - HEIGHT_INCREMENT;
            fprintf('Moving Down. Height: %.2f\n', currentHeight);
        else
            stopAllMotors(a, motors);
        end
        
        % Small delay to prevent rapid movements
        pause(0.05);
    end
catch ME
    % Error handling
    fprintf('Error in main loop: %s\n', ME.message);
    % Make sure to stop motors on error
    stopAllMotors(a, motors);
end
