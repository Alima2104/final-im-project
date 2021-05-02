const int trigPin = 9;
const int echoPin = 10;
const int yButton = 12;
const int rButton = 13;
const int bButton = 4;
const int LEDpin = 5;
int LED;
// defines variables
long duration;
int distance;
void setup() {
pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin, INPUT); // Sets the echoPin as an Input
pinMode(A0, INPUT);
pinMode(yButton, INPUT);
pinMode(rButton, INPUT);
pinMode(bButton, INPUT);
Serial.begin(9600); // Starts the serial communication
Serial.println("0,0,0,0,0");
}
void loop() {
// Clears the trigPin
digitalWrite(trigPin, LOW);
delayMicroseconds(2);
// Sets the trigPin on HIGH state for 10 micro seconds
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
// Reads the echoPin, returns the sound wave travel time in microseconds
duration = pulseIn(echoPin, HIGH);
// Calculating the distance
distance= duration*0.034/2;

while (Serial.available()>0) { //whenever there is anything available in serial buffer, do
    LED = Serial.parseInt();
    digitalWrite(5, LED);
    if (Serial.read() == '\n') { //whenever there is new line, it means that all info came correctly
      int intensity = analogRead(A0); 
      int yellow = digitalRead(yButton);
      int red = digitalRead(rButton);
      int blue = digitalRead(bButton);
     // delay(1);
      Serial.print(distance); //send info to the processing
      Serial.print(',');
      //delay(1);
      Serial.print(intensity);
      Serial.print(',');
      //delay(1);
      Serial.print(yellow);
      Serial.print(',');
      //delay(1);
      Serial.print(red);
      Serial.print(',');
      Serial.println(blue);
    }
  }
}
