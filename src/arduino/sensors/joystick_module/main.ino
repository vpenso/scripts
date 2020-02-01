#include <Servo.h> // include the servo library

const int baudrate = 9600;

const int xPin = A0;
const int yPin = A1;
const int swPin = 2;
// The servo requires a port with PWM support
const int servoPin = 3;

int xVal;
int yVal;
int swVal;

// Servo position in degree
int servoAngel = 90; // set the servo to mid-point

Servo servo;

void setup() {
  Serial.begin(baudrate);
  pinMode(swPin,INPUT);
  digitalWrite(swPin,HIGH);
  // Configure the PWM pin connected the signal input of a server 
  servo.attach(servoPin);
  servo.write(servoAngel);
}

void loop() {
  // Read the analog signals for the two axis potentiometers
  xVal = analogRead(xPin);
  yVal = analogRead(yPin);
  //  Read the digital push button
  swVal = digitalRead(swPin);
  // Prefix the output if the push button is pressed
  if (! swVal)
    Serial.print("** ");
  // Continuously print values for the two axis
  Serial.print(xVal);
  Serial.print(" x:y ");
  Serial.println(yVal);
 
  // Map an analog input signal to the server angel
  servoAngel = map(xVal,0,1023,0,180);
  // Control the servo shaft angel
  servo.write(servoAngel);
  Serial.print(servoAngel);
  Serial.println(" degree");
}
