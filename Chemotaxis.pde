int totalBac = 100;
Bacteria[] movables = new Bacteria[totalBac];

float centerX = 500;
float centerY = 500;
int spread = 100;

double easing = 0.02;

int targetX, targetY, targetW, targetH, winCount, maxCurrent;

void setup()   
{
  size(1000, 1000);
  background(0);
  
  for (int i = 0; i < movables.length; i++) {
    Bacteria charles = new Bacteria();
    movables[i] = charles;
  }
  
  targetX = 700;
  targetY = 200;
  targetW = 150;
  targetH = 300;
  winCount = 80;
} 
void draw()   
{
  int bacteriaInside = 0;
  centerX = (float)(centerX + easing * (mouseX - centerX));
  centerY = (float)(centerY + easing * (mouseY - centerY));
  
  //int totalX = 0;
  //int totalY = 0;
  background(0);
  
  fill(0, 255, 0);
  rect(targetX, targetY, targetW, targetH);
  
  for (int i = 0; i < movables.length; i++) {
    movables[i].move(movables);
    movables[i].show(); 
    
    //totalX += movables[i].myX;
    //totalY += movables[i].myY;
    
    if (movables[i].myX >= targetX
    && movables[i].myX <= targetX + targetW
    && movables[i].myY >= targetY
    && movables[i].myY <= targetY + targetH) {
      bacteriaInside++;
    }
  }
  
  if (bacteriaInside >= maxCurrent) {
    maxCurrent = bacteriaInside;
  }
  
  if (bacteriaInside >= winCount) {
    randomizeRound();
  }
  
  textAlign(RIGHT, BOTTOM);
  textSize(36);
  fill(255);
  text("Max: " + maxCurrent, 970, 970);
  text(bacteriaInside + "/" + winCount, 970, 930);
  
  //float avgX = totalX / totalBac;
  //float avgY = totalY / totalBac;
  
  fill(255.0, 120);
  noStroke();
  //ellipse(avgX, avgY, spread, spread);
}

void randomizeRound() {
  targetW = (int)(Math.random()*150+75);
  targetH = (int)(Math.random()*150+75);
  targetX = (int)(Math.random()*(1000-targetW));
  targetY = (int)(Math.random()*(1000-targetH));
  winCount = (int)(Math.min(targetW*targetH/270, 100));
  maxCurrent = 0;
}

int clampPos(int pos) {
  return Math.max(10, Math.min(990, pos));
}

void mousePressed() {
  for (Bacteria other : movables) {
    other.blastX = 0.5*(other.myX - centerX);
    other.blastY = 0.5*(other.myY - centerY);
  }
}

class Bacteria    
{
  int myX, myY, bacColor;
  float blastX, blastY;
  
  Bacteria() {
    myX = (int)(Math.random()*200+400);
    myY = (int)(Math.random()*200+400);
    bacColor = color((int)(Math.random()*155+100));
  }
  
  void move(Bacteria[] allBac) {
    myX += (int)(0.05 * (centerX - myX));
    myY += (int)(0.05 * (centerY - myY));
    myX += (int)(Math.random()*5-2);
    myY += (int)(Math.random()*5-2);
    myX += (int)blastX;
    myY += (int)blastY;
    
    blastX *= 0.85;
    blastY *= 0.85;
    
    int pushX = 0;
    int pushY = 0;
    
    for (Bacteria other : allBac) {
      if (other != this) {
        double dist = Math.sqrt(Math.pow((other.myX - myX), 2) + Math.pow((other.myY - myY), 2));
        
        if (dist < 20 && dist > 0) {
         pushX += myX - other.myX;
         pushY += myY - other.myY;
        }
        
      }
    }
    
    myX += (pushX * 0.1);
    myY += (pushY * 0.1);
    
    myX = clampPos(myX);
    myY = clampPos(myY);
  }
  
  void show() {
    fill(bacColor);
    ellipse(myX, myY, 20, 20);
  }
}
