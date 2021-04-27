const int trigPin = 9;
const int echoPin = 10;
// defines variables
long duration;
int distance;
void setup() {
pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(echoPin, INPUT); // Sets the echoPin as an Input
pinMode(A0, INPUT);
Serial.begin(9600); // Starts the serial communication
Serial.println("0,0");
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
// Prints the distance on the Serial Monitor
//Serial.print("Distance: ");
//Serial.println(distance);
//int intensity = analogRead(A0); 
//rSerial.println(intensity);
while (Serial.available()>0) { //whenever there is anything available in serial buffer, do
    if (Serial.read() == '\n') { //whenever there is new line, it means that all info came correctly
      int intensity = analogRead(A0); 
      delay(1);
      Serial.print(distance); //send info to the processing
      Serial.print(',');
      Serial.println(intensity);
    }
  }
}
