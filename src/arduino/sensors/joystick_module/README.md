## Read Input from a JoyStick

Connections:

| From               | To                              |
|--------------------|---------------------------------|
| Joystick **GND**   | Ground **0V**                   |
| Joystick **+5V**   | Positive **5V**                 |
| Joystick **VRx**   | Arduino **A0** (analog input)   |
| Joystick **VRy**   | Arduino **A1** (analog input)   |
| Joystick **SW**    | Arduino **D2** (digital input)  |

Following code illustrates how to read the analog and digital signals from the joystick:

```arduino
const int baudrate = 9600;

const int xPin = A0;
const int yPin = A1;
const int swPin = 2;

int xVal;
int yVal;
int swVal;

void setup() {
  Serial.begin(baudrate);
  pinMode(swPin,INPUT);
  digitalWrite(swPin,HIGH);
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
}
```

## Control a Servo Motor with the Joystick

Connections:

| From                | To                          |
|---------------------|-----------------------------|
| Servo **GND**       | Ground 0V                   |
| Servo **VSS**       | Positive 5V                 |
| Servo **PWM**       | Arduino **D3** (PWM output) |

Following code configures the servo motor and maps the analog joystick signal to the an angel between 0° and 180°:

```arduino
#include <Servo.h> // include the servo library

[…]

// The servo requires a port with PWM support
const int servoPin = 3;

// Servo position in degree
int servoAngel = 90; // set the servo to mid-point

Servo servo;

void setup() {
  […]
  // Configure the PWM pin connected the signal input of a server 
  servo.attach(servoPin);
  servo.write(servoAngel);
}

void loop() {
  […]
 
  // Map an analog input signal to the server angel
  servoAngel = map(xVal,0,1023,0,180);
  // Control the servo shaft angel
  servo.write(servoAngel);
  Serial.print(servoAngel);
  Serial.println(" degree");
}

```
