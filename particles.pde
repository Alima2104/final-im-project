class Particle {

  float radius;
  float x, y; 
  float noiseval;
  float radVariance, thisRadius, rad;
  float centX;
  float centY;
  color colour = color(255);

  Particle() {
    radius = 50;
    noiseval = intensity/10;
  }

  void drawParticle(float centX1, float centY1, float intens, color cl) {
    //stroke(20, 50, 70);
    //strokeWeight(1);
    noStroke();
    colour = cl;

    beginShape();
    
    fill(cl);
    //fill(15, 50, 35, 25);
   
    for (float ang = 0; ang <= 360; ang += 1) {
    //  float ang = 360;
      noiseval += 0.1;
      radVariance = 30 * customNoise(noiseval);
      radius = intens;

      thisRadius = radius + radVariance;
      rad = radians(ang);
      x = centX1 + (thisRadius * cos(rad));
      y = centY1 + (thisRadius * sin(rad));

      curveVertex(x, y);
    }
    endShape();
  }
}
