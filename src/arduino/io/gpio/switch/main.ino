const int D8 = 8;
const int D12 = 12;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(D8, OUTPUT);     
  pinMode(D12, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {

  int button = digitalRead(D12);

  if (button == HIGH) {
    digitalWrite(D8, HIGH);
  } else {
    digitalWrite(D8, LOW);
  }

}
