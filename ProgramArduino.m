% Class: ENGR 1182.02
% Date: 4/5/24
% Professor: Dr. Ratcliff
% Author: Logan Oden
% Description: This program is designed to properly program the arduino, 
% two force sensitive buttons, two motor  four different motors,   .

% Basic clc and clear functions.
clc;
clear;

% For button connections (up and down buttons for controlling table).
upConnection = 'A0';
downConnection = 'A1';

% For motor A, B, C, and D PWM pin (voltage and speed).
AmotorConnection = 'D2';
BmotorConnection = 'D8';
CmotorConnection = 'D9';
DmotorConnection = 'D10';

% For motor A, B, C, and D direction 1 and 2 pins (clockwise and counterclockwise,
% respectively).
Adirection1 = 'D4';
Adirection2 = 'D3';

Bdirection1 = 'D7';
Bdirection2 = 'D6';

Cdirection1 = 'D41';
Cdirection2 = 'D43';

Ddirection1 = 'D29';
Ddirection2 = 'D31';

% Astandby pin for controlling whether the motor is on or off.
Astandby = 'D5';
Bstandby = 'D39';

% Setup arduino.
a = arduino('COM5', 'Mega2560');

% Setup displacement measurements to ensure table doesn't over/under
% adjust beyond its capabilities.
currentDisp = 0;
% The maximum and minimum displacement values may be subject to change depending
% on how far the table legs vertically displace every time the code in the 
% loop runs. In addition, these values depends on the physical limitations of the
% adjustability, which will be determined during exhaustive testing.
maxDisp = 9;
minDisp = .01;

% Begin infinite loop.
while (true) 
    % Determine if force is applied to either or both of the up and down
    % buttons.
    upButtonClicked = readVoltage(a, upConnection) > 0;
    downButtonClicked = readVoltage(a, downConnection) > 0;
    % Ensure both buttons are not clicked before moving on.
    if (~(upButtonClicked && downButtonClicked) && (upButtonClicked || downButtonClicked))
        % Turn the motor on.
        writeDigitalPin(a, Astandby, 1);
        writeDigitalPin(a, Bstandby, 1);
        % If up button clicked and table is ewithin an acceptable range from
        % maximum upward displacement, then set one direction of motor to 
        % high and other direction to low, causing the motor to spin clockwise. 
        if (upButtonClicked && (currentDisp < maxDisp))
            writeDigitalPin(a, Adirection1, 1);
            writeDigitalPin(a, Adirection2, 0);
            writeDigitalPin(a, Bdirection1, 1);
            writeDigitalPin(a, Bdirection2, 0);
            writeDigitalPin(a, Cdirection1, 1);
            writeDigitalPin(a, Cdirection2, 0);
            writeDigitalPin(a, Ddirection1, 1);
            writeDigitalPin(a, Ddirection2, 0);
            % Set the speed of the motor to 1
            writePWMVoltage(a, AmotorConnection, 1);
            writePWMVoltage(a, BmotorConnection, 1);
            writePWMVoltage(a, CmotorConnection, 1);
            writePWMVoltage(a, DmotorConnection, 1);
            % Increase current displacement by .1 as a result.
            currentDisp = currentDisp + .1;
            % Turn off motor to reduce accidents
            %writeDigitalPin(a, Astandby, 0);
            %writeDigitalPin(a, Bstandby, 0);
        % If down button clicked and table is within an acceptable range from
        % maximum downward displacement, then set one direction of motor to 
        % high and other direction to low, causing motor to spin counterclockwise.
        elseif (downButtonClicked && (currentDisp > minDisp))
            writeDigitalPin(a, Adirection2, 1);
            writeDigitalPin(a, Adirection1, 0);
            writeDigitalPin(a, Bdirection2, 1);
            writeDigitalPin(a, Bdirection1, 0);
            writeDigitalPin(a, Cdirection2, 1);
            writeDigitalPin(a, Cdirection1, 0);
            writeDigitalPin(a, Ddirection2, 1);
            writeDigitalPin(a, Ddirection1, 0);
            % Set the speed of the motor to 1.
            writePWMVoltage(a, AmotorConnection, 1);
            writePWMVoltage(a, BmotorConnection, 1);
            writePWMVoltage(a, CmotorConnection, 1);
            writePWMVoltage(a, DmotorConnection, 1);
            % Decrease current displacement by .1 as a result.
            currentDisp = currentDisp - .1;
            % Turn off motor to reduce accidents
            %writeDigitalPin(a, Astandby, 0);
            %writeDigitalPin(a, Bstandby, 0);
        else 
            % If both buttons are clicked, then turn off the motor
            % (power-saving and accident-proof).
            writeDigitalPin(a, Astandby, 0);
            writeDigitalPin(a, Bstandby, 0);
        end
    else 
        % If neither button is clicked, turn the motor off (power-saving).
        writeDigitalPin(a, Astandby, 0);
        writeDigitalPin(a, Bstandby, 0);
    end
end