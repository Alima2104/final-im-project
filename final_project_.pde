Particle p1;
Design designs;
import processing.serial.*; //import library
Serial myPort; //create serial object

import processing.pdf.*;
import java.util.Calendar;

import geomerative.*;

import processing.sound.*;
SoundFile file;
Timer countDownTimer;

int LEDonOff= 0;

boolean soundOnOff = false;
boolean recordPDF = false;
int yOnOff, rOnOff, bOnOff;

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

int startTime = 0;

color cl;

PFont mono;

RFont font;
RGroup grp;
RPoint[] pnts;

boolean freeze = false;

String state;

PImage startscreen;
PImage nextscreen;
PImage lastscreen;
PImage sound;
PImage nextButton;
PImage nextButton2;
PImage soundOff;

void setup () {
  size(1200, 800); 

  startscreen = loadImage("firstscreen.jpeg");
  nextscreen = loadImage("secondscreen.jpeg");
  lastscreen = loadImage("bg_3.jpeg");
  sound = loadImage("sound_icon.png");
  soundOff = loadImage("soundOff.png");
  nextButton = loadImage("button1.png");
  nextButton2 = loadImage("button2.png");

  sound.resize(50, 50);
  image(sound, width-100, 10);

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
  RCommand.setSegmentAngle(random(0, HALF_PI));

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
  //strokeWeight(1);
  smooth();

  cl = color(255, 0, 0, 0);

  file = new SoundFile(this, "musicc.mp3");


  p1 = new Particle();

  designs = new Design();
  // designs[0] = newDesign[]
}

float customNoise(float value) {
  float retValue = pow(sin(value), 3);
  return retValue;
}

void draw() { 

  if (state == "START") { 
    startSession();
  } else if (state == "IN") {
    instruction();
  } else if (state == "FINISH") {
    endSession();
  } else if (state == "PLAY") { 


    LEDonOff= 1;
    noStroke();

    noFill();
    pushMatrix();

    // translation according the amoutn of letters
    translate(letterX, letterY);
    // distortion on/off
    if (mousePressed) danceFactor = map(mouseX, 0, width, 1, 3);
    else danceFactor = 1;

    // are there points to draw?
    if (grp.getWidth() > 0) {
      // let the points dance
      for (int i = 0; i < pnts.length; i++ ) {
        pnts[i].x += random(-stepSize, stepSize)*danceFactor;
        pnts[i].y += random(-stepSize, stepSize)*danceFactor;
      }

      //  ------ lines: connected rounded  ------
      strokeWeight(0.08);
      //stroke(200,0,0);
      beginShape();
      // start controlpoint
      curveVertex(pnts[pnts.length-1].x, pnts[pnts.length-1].y);
      // only these points are drawn
      for (int i=0; i<pnts.length; i++) {
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
      for (int i=0; i<pnts.length; i++) {
        vertex(pnts[i].x, pnts[i].y);
        ellipse(pnts[i].x, pnts[i].y, 7, 7);
      }
      vertex(pnts[0].x, pnts[0].y);
      endShape();
    }

    popMatrix();

    noStroke();
    //fill(255);
    //cl = color(255, 0, 0, 0);


    if (yOnOff == 1) {
      cl = color(255, 205, 0, 50);
    }

    if (rOnOff == 1) {
      cl = color(204, 102, 0, 50);
    }
    
    if (bOnOff == 1) {
      cl = color(50, 55, 100, 50);
    }

    //mouseClicked();
    p1.drawParticle(lengthh, random(height/2-150, height/2+150), intensity, cl);

    designs.display(0, 0, width/3, 100, color(204, 102, 0, 50));
    designs.display(width/3, 0, width/3, 100, color(255, 204, 0, 50));
    designs.display(2*width/3, 0, width/3, 100, color(50, 55, 100, 50));
  }
}

void startSession() {
  
  imageMode(CORNER);
  startscreen.resize(width, height);
  image(startscreen, 0, 0);
  if (soundOnOff) 
  {  
    sound.resize(50, 50);
    image(sound, width-100, 10);
  }
  if (!soundOnOff) 
  { 
    soundOff.resize(50, 50);
    image(soundOff, width-100, 10);
  }
  textAlign(CENTER);
  textSize(100);
  fill(123, 101, 181);
  text("ART THERAPY:", width/2, height/2-200);
  textSize(50);
  fill(123, 101, 181);
  text("interactive media edition", width/2, height/2-100);
  fill(151, 131, 201);
  textSize(70);
  imageMode(CENTER);
  nextButton.resize(350, 100);
  image(nextButton, width/2, height-200);
  textSize(50);
  fill(123, 101, 255);
  text("continue >>", width/2, height-185);
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>10 && mouseY<60 && (soundOnOff == false))
  {
    soundOnOff = true;
     file.play();
  }
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>60 && mouseY<110 && (soundOnOff == true))
  {
    soundOnOff = false;
    //  file.play();
  }
  if (mousePressed  && mouseX>(width/2-175) && mouseX<(width/2+175) && mouseY>height-250 && mouseY<height-150) {
    state = "IN";
    background(255);
  }
}

void instruction() {
  imageMode(CORNER);
  nextscreen.resize(width, height);
  image(nextscreen, 0, 0);
  if (soundOnOff) 
  {  
    sound.resize(50, 50);
    image(sound, width-100, 10);
  }
  if (!soundOnOff) 
  { 
    soundOff.resize(50, 50);
    image(soundOff, width-100, 10);
  }
  textAlign(CENTER);
  textSize(50);
  fill(255, 0, 0);
  text("ENJOY <3!", width/2, height/2+200);
  textSize(30);
  fill(100, 0, 0);
  text("INSTRUCTIONS\n " +
    "Once you start, TYPE THE WORD that causes your stress using the keyboard \n BEAT THE SPONGE in front of you \n " +
    " USE THE KNOB to change the size of spots  \n press BUTTONS to change colors \n press TAB to screenshot \n press ENTER when you finish \n TURN ON the song", width/2, height/2-200);
  imageMode(CENTER);
  nextButton2.resize(350, 100);
  image(nextButton2, width/2, height-100);
  textSize(50);
  fill(255, 101, 55);
  text("continue >>", width/2, height-85);
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>10 && mouseY<60 && (soundOnOff == false))
  {
    soundOnOff = true;
    file.play();
  }
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>60 && mouseY<110 && (soundOnOff == true))
  {
    soundOnOff = false;
    //  file.play();
  }
  if (mousePressed && mouseX>(width/2-175) && mouseX<(width/2+175) && mouseY>height-150 && mouseY<height-50) {
    background(255);
    fill(255);
    noStroke();
    rect(0, 0, 50, height);
    state = "PLAY";
  }
}

void endSession() {
  LEDonOff= 0;
  imageMode(CORNER);
  lastscreen.resize(width, height);
  image(lastscreen, 0, 0);
  if (soundOnOff) 
  {  
    sound.resize(50, 50);
    image(sound, width-100, 10);
  }
  if (!soundOnOff) 
  { 
    soundOff.resize(50, 50);
    image(soundOff, width-100, 10);
  }
  textAlign(CENTER);
  textSize(100);
  fill(123, 101, 181);
  text("thank you!", width/2, height/2-200);
  textSize(50);
  fill(123, 101, 181);
  text("I hope you enjoyed! \n If you want to paint another piece, \n click the button below", width/2, height/2-100);
  imageMode(CENTER);
  nextButton2.resize(350, 100);
  image(nextButton2, width/2, height-100);
  textSize(50);
  fill(255, 101, 55);
  text("again >>", width/2, height-85);
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>10 && mouseY<60 && (soundOnOff == false))
  {
    soundOnOff = true;
    //  file.play();
  }
  if (mousePressed && mouseX>(width-100) && mouseX<(width-50) && mouseY>60 && mouseY<110 && (soundOnOff == true))
  {
    soundOnOff = false;
    //  file.play();
  }
  if (mousePressed && mouseX>(width/2-175) && mouseX<(width/2+175) && mouseY>height-150 && mouseY<height-50) {
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
}

void keyPressed() {
  if (key != CODED) {
    switch(key) {
    case ENTER:
      state = "FINISH";
      break;
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

String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}

void serialEvent(Serial myPort) { //whenever receives incoming serial message, this function is called
  println(LEDonOff); 
  myPort.write(int(LEDonOff)+"\n"); 
  String s=myPort.readStringUntil('\n'); //read the string until new line character
  s=trim(s); //safeguard to trim extra characters (whitespaces)
  if (s!=null) { //check to make sure it's not null
    println(s); 
    int values[]=int(split(s, ',')); //sending value s
    lengthh=(int)map(values[0], 0, 40, width-50, 50);
    intensity=(int)map(values[1], 0, 1023, 20, 70);
    yOnOff= values[2];
    rOnOff = values[3];
    bOnOff = values[4];
  }
  myPort.write("\n"); //other side of the handshake, send back over to arduino
}
