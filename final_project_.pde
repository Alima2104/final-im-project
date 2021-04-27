Particle p1;
import processing.serial.*; //import library
Serial myPort; //create serial object

import processing.pdf.*;
import java.util.Calendar;

import geomerative.*;

import processing.sound.*;
SoundFile file;


boolean recordPDF = false;

float lengthh;
int intensity;

char typedKey = '>';
float spacing = 20;
float spaceWidth = 150; // width of letter ' '
int fontSize = 250;
float lineSpacing = fontSize*2;
float stepSize = 2;
float danceFactor = 1;
float letterX = 150;
float textW = 50;
float letterY = lineSpacing;

color cl;

PFont mono;

RFont font;
RGroup grp;
RPoint[] pnts;

boolean freeze = false;

String state;

PImage startscreen;
PImage nextscreen;
PImage sound;

void setup () {
  size(1200,800); 
  
  startscreen = loadImage("firstscreen.jpeg");
  nextscreen = loadImage("secondscreen.jpeg");
  sound = loadImage("sound_icon.png");
  
  state = "START";
  
  mono = createFont("Franklin Goth Ext Condensed.ttf", 32);
  textFont(mono);
  
  surface.setResizable(true);  
  smooth();

  frameRate(15);

  RG.init(this);
  font = new RFont("FreeSansNoPunch.ttf", fontSize, RFont.LEFT);

  RCommand.setSegmentLength(20);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  RCommand.setSegmentAngle(random(0,HALF_PI));

  grp = font.toGroup(typedKey+"");
  textW = grp.getWidth();
  pnts = grp.getPoints(); 

  background(255);
  
  printArray(Serial.list()); //printing array
  String portname=Serial.list()[1]; //choose the correct port number!
  println(portname);
  myPort = new Serial(this, portname, 9600); //set the baud rate
  myPort.clear(); //clear the buffer
  myPort.bufferUntil('\n'); //wait until new line
  background(255);
  strokeWeight(1);
  smooth();
  
  p1 = new Particle();

}

float customNoise(float value) {
  float retValue = pow(sin(value), 3);
  return retValue;
}

void draw() { 
  
   if (state == "START") { 
     startSession();
   }
   
   else if (state == "IN") {
     instruction();
   }
   
  else if (state == "PLAY") { 
    
  noStroke();
  rectMode(CORNER);
  fill(204, 102, 0, 50);
  rect(width-200, 0, 200, 50); //green
  fill(255, 204, 0, 50);
  rect(width-200, 80, 200, 50); //blue
  fill(50, 55, 100, 50);
  rect(width-200, 160, 200, 50); //red
  
  noFill();
  pushMatrix();

  // translation according the amoutn of letters
  translate(letterX,letterY);
  // distortion on/off
  if (mousePressed) danceFactor = map(mouseX, 0,width, 1,3);
  else danceFactor = 1;

  // are there points to draw?
  if (grp.getWidth() > 0) {
    // let the points dance
    for (int i = 0; i < pnts.length; i++ ) {
      pnts[i].x += random(-stepSize,stepSize)*danceFactor;
      pnts[i].y += random(-stepSize,stepSize)*danceFactor;  
    }

    //  ------ lines: connected rounded  ------
    strokeWeight(0.08);
    //stroke(200,0,0);
    beginShape();
    // start controlpoint
    curveVertex(pnts[pnts.length-1].x,pnts[pnts.length-1].y);
    // only these points are drawn
    for (int i=0; i<pnts.length; i++){
      curveVertex(pnts[i].x, pnts[i].y);
    }
    curveVertex(pnts[0].x, pnts[0].y);
    // end controlpoint
    curveVertex(pnts[1].x, pnts[1].y);
    endShape();

    //  ------ lines: connected straight  ------
    strokeWeight(0.1);
    stroke(0);
    beginShape();
    for (int i=0; i<pnts.length; i++){
      vertex(pnts[i].x, pnts[i].y);
      ellipse(pnts[i].x, pnts[i].y, 7, 7);
    }
    vertex(pnts[0].x, pnts[0].y);
    endShape();
  }

  popMatrix();
  
  noStroke();
  fill(255);
  mouseClicked();
  p1.drawParticle(lengthh, random(height/2-150, height/2+150), intensity, cl);

  }
}
  
  void mouseClicked(){
    if (mouseX>(width-200) && mouseX<width && mouseY>0 && mouseY<50) {
      cl= color(204, 102, 0, 50);
  }
  if ( mouseX>(width-200) && mouseX<width && mouseY>80 && mouseY<130){
    cl = color(255, 204, 0, 50);
  }
   if(mouseX>(width-200) && mouseX<width && mouseY>160 && mouseY<210) {
     cl= color(50, 55, 100, 50);
   }
  
  }
  
 
  

void startSession(){
  imageMode(CORNER);
  startscreen.resize(width, height);
  image(startscreen, 0, 0);
  textAlign(CENTER);
  textSize(100);
  fill(123, 101, 181);
  text("ART THERAPY:", width/2, height/2-200);
  textSize(50);
  fill(123, 101, 181);
  text("interactive media edition", width/2, height/2-100);
  fill(151, 131, 201);
  textSize(70);
  text("CLICK ANYWHERE TO CONTINUE!", width/2, height/2+200);
  sound.resize(50, 50);
  image(sound, width-100, 10);
  if (mousePressed) {
    state = "IN";
    background(255);
  }
}

void instruction(){
  imageMode(CORNER);
  nextscreen.resize(width, height);
  image(nextscreen, 0, 0);
  textAlign(CENTER);
  textSize(50);
  fill(255, 0, 0);
  text("Click anywhere to start!", width/2, height/2+200);
  textSize(30);
  fill(100, 0, 0);
  text("Welcome!\n " +
    "Instructions: \n Are you stressed? Try this!\n Once you start, you should type the word that causes your stress using the keyboard \n Then you can make it an art piece by beating the material you see in front of you! \n " +
    " Use the knob to change the size of spots on the screen! \n And make sure to screenshot the result you got! ", width/2, height/2-200);
  sound.resize(50, 50);
  image(sound, width-100, 10);
  if (mousePressed) {
   // state = "PLAY";
    background(255);
    fill(255);
    noStroke();
    rect(0, 0, 50, height);
    state = "PLAY";
  }
}

void keyReleased() {
  if (keyCode == TAB) saveFrame(timestamp()+"_##.png");
  if (keyCode == SHIFT) {
    // switch loop on/off
    freeze = !freeze;
    if (freeze == true) noLoop();
    else loop();
  } 
  
  // ------ pdf export ------
  // press CONTROL to start pdf recordPDF and ALT to stop it
  // ONLY by pressing ALT the pdf is saved to disk!
  if (keyCode == CONTROL) {
    if (recordPDF == false) {
      beginRecord(PDF, timestamp()+".pdf");
      println("recording started");
      recordPDF = true;
    }
  } 
  else if (keyCode == ALT) {
    if (recordPDF) {
      println("recording stopped");
      endRecord();
      recordPDF = false;
    }
  } 
}

void keyPressed() {
  if (key != CODED) {
    switch(key) {
    case ENTER:
    case RETURN:
      grp = font.toGroup(""); 
      letterY += lineSpacing;
      textW = letterX = 150;
      break;
    case ESC:
    case TAB:
      break;
    case BACKSPACE:
    case DELETE:
      background(255);
      grp = font.toGroup(""); 
      textW = letterX = 150;
      letterY = lineSpacing;
      freeze = false;
      loop();
      break;
    case ' ':
      grp = font.toGroup(""); 
      letterX += spaceWidth;
      freeze = false;
      loop();
      break;
    default:
      typedKey = key;
      // add to actual pos the letter width
      textW += spacing;
      letterX += textW;
      grp = font.toGroup(typedKey+"");
      textW = grp.getWidth();
      pnts = grp.getPoints(); 
      freeze = false;
      loop();
    }
  } 
}

// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}



void serialEvent(Serial myPort) { //whenever receives incoming serial message, this function is called 
  String s=myPort.readStringUntil('\n'); //read the string until new line character
  s=trim(s); //safeguard to trim extra characters (whitespaces)
  if (s!=null) { //check to make sure it's not null
    println(s); 
    int values[]=int(split(s,',')); //sending value s
    lengthh=(int)map(values[0], 0, 40, width-50, 50);
    intensity=(int)map(values[1], 0, 1023, 20, 70);
  }
  myPort.write("\n"); //other side of the handshake, send back over to arduino
}

