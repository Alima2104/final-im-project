import processing.serial.*; //import library
Serial myPort; //create serial object

float lengthh;
 
 ArrayList <Particle> particles;
 
 float radius = 100;
 float x, y; 
 float noiseval = random(10);
 float radVariance, thisRadius, rad;

void setup () {
 size(500,300);
 printArray(Serial.list()); //printing array
  String portname=Serial.list()[1]; //choose the correct port number!
  println(portname);
  myPort = new Serial(this, portname, 9600); //set the baud rate
  myPort.clear(); //clear the buffer
  myPort.bufferUntil('\n'); //wait until new line
 background(255);
 strokeWeight(1);
 smooth();

 float centX[] = {random(width), random(width), random(width)};
 float centY[] = {random(height), random(height), random(height)};
 stroke(0, 30);
 noFill();
 
 particles = new ArrayList <Particle>();
 
 for (int i=0; i<10; i++){
 particles.add(new Particle());
 }
 //ellipse(centX,centY,radius*2,radius*2);
//}
 
 //void draw(){
 for (int n=0; n<3; n++) {

 stroke(20, 50, 70);
 strokeWeight(1);

 beginShape();
 fill(30, 100, 70, 50);
 
 for (float ang = 0; ang <= 360; ang += 1) {

 noiseval += 0.1;
 radVariance = 30 * customNoise(noiseval);

 thisRadius = radius + radVariance;
 rad = radians(ang);
 x = centX[n] + (thisRadius * cos(rad));
 y = centY[n] + (thisRadius * sin(rad));

 curveVertex(x,y);
 }
 endShape();
}
 }

float customNoise(float value) {
 float retValue = pow(sin(value), 3);
 return retValue;
}
void draw() {
  //background(255);
  stroke(5);
  ellipse(width/2, height/2, lengthh, lengthh);
 
}

void serialEvent(Serial myPort) { //whenever receives incoming serial message, this function is called 
  String s=myPort.readStringUntil('\n'); //read the string until new line character
  s=trim(s); //safeguard to trim extra characters (whitespaces)
  if (s!=null) { //check to make sure it's not null
    println(s); 
    int value = int(s);  //sending value s
    lengthh=(int)map(value, 0, 40, 0, 100); 
  }
  myPort.write("\n"); //other side of the handshake, send back over to arduino
}
