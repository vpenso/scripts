#define BUTTON 2
#define MOTOR 9

void setup() {
  pinMode(BUTTON,INPUT);
  pinMode(MOTOR,OUTPUT);
}

void loop() {
  if(digitalRead(BUTTON) == HIGH) {
    analogWrite(MOTOR,255);
    delay(200);
  }
  delay(1);
}
