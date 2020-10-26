//count for every kind of gw or ew, level of engagement
int close, semi, around, center, negative, positive, neutral = 0;
//int engagelow, engagemid, engagehigh = 0;
int rowCount = 0;

//pie chart
float emotion_negpie;
float emotion_pospie;
float emotion_neupie;

String[] label = {"netural", "positive", "negative"};
color[] emotionColor={#C24269, #E06C92, #8F304D};
String[] label1={"semi", "close", "center", "around"};
color[] attentionColor={#2B3D8B, #213070, #7C91C8, #3A4DA5};
float semipie, closepie, centerpie, aroundpie;


//for visualization
float engagement;
float size;
float allengage=0.0;

float attention;
float emotion;
String emotionStatus;

Table table; 
PImage img;

//for the floating blob
float phase = 0;
float zoff = 0;

//for moving and hover and click interaction
float bx;
float by;
boolean overBlob = false;
boolean locked = false;
boolean click= false;
float xOffset = 0.0; 
float yOffset = 0.0; 
float xOn=0.0;
float yOn=0.0;

void setup() {
  size(250, 250);

  bx = width/9.0;
  by = height/8.0*6;
}

void draw() {
  background(#272623);
  //Redraw each time new data is in csv file
  close= 0;
  semi= 0;
  around= 0;
  center= 0; 
  negative= 0; 
  positive= 0;
  neutral = 0;

   engagement=0;
   size=0;
   allengage=0.0;

   attention=0;
   emotion=0;
   emotionStatus = "";

  loadData();
  transData();

  float[] data={emotion_neupie, emotion_pospie, emotion_negpie};
  float[] data1={semipie, closepie, centerpie, aroundpie};
  //See if the cursor is over the blub
  if (mouseX > bx-size && mouseX < bx+size && 
    mouseY > by-size && mouseY < by+size) {
    overBlob = true;
    //If mousepressed then show most detail
    if (mousePressed == true) {
      drawBlob4(size+120, data, data1);
    } else {
      //If hover show more detail
      drawBlob2();
    }
  } else {
    //When not hovered show default blob
    overBlob = false;
    drawBlob();
  }
}

void loadData() {
  //Load csv into sketch
  table = loadTable("../util/database.csv", "header");
  
  //Get amount of rows, representing amount of students
  rowCount = table.getRowCount();
  
  for (TableRow row : table.rows()) {
    //Define if eyes are closed, semi open, around the screen or in the middle looking
    if (row.getFloat("gw")==0) close++;
    else if (row.getFloat("gw")==1.5) semi++;
    else if (row.getFloat("gw")==2) around++;
    else center++;

    //Define if emotion weight is positive, negative or neutral
    if (row.getFloat("ew")==0.25 || row.getFloat("ew")==0.3) negative++;
    else if (row.getFloat("ew")==0.6) positive++;
    else neutral++;

    //Put overall engagement in one variable
    allengage += row.getFloat("ci");
  }
}

void transData() {
  
  //Average engagement = allengagement divided by amount students
  engagement = allengage/rowCount;
  
  size = map(engagement, 0, 1, 50, 80);
  
  //Attention is based on amount of students looking at center screen
  attention = center*1.0/rowCount;
  
  //Determine most prominent emotion in database csv.
  if (neutral >= negative && neutral >= positive) {
    emotionStatus = "neutral";
    emotion = (neutral*1.0)/rowCount;
  } else if (positive >= negative) {
    emotionStatus = "positive";
    emotion = positive*1.0/rowCount;
  } else {
    emotionStatus = "negative";
    emotion = negative*1.0/rowCount;
  } 

  emotion_neupie=(neutral*1.0/rowCount)*360;
  emotion_pospie=(positive*1.0/rowCount)*360;
  emotion_negpie=(negative*1.0/rowCount)*360;

  closepie=(close*1.0/rowCount)*360;
  semipie=(semi*1.0/rowCount)*360;
  centerpie=(center*1.0/rowCount)*360;
  aroundpie=(around*1.0/rowCount)*360;
  
}


void drawBlob() {
  translate(bx, by);
  noStroke();
  fill(255);
  beginShape();
  float noiseMax = 0.1;
  for (float a = 0; a < TWO_PI; a += radians(3)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float r = map(noise(xoff, yoff, zoff), 0, 1, size, size+30);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  phase += 0.0001;
  zoff += 0.005;
  drawEngage();
}

void drawEngage() {
  textAlign(CENTER, CENTER);
  textSize(18);
  fill(13, 13, 13);
  text(nf(engagement*100, 0, 1) + "% engaged", 0, 0);
}

void drawBlob2() {
  translate(bx, by);
  noStroke();
  float blobcolor = map(emotion, 0, 1, 0, 255);
  fill(255, 200, blobcolor);
  beginShape();
  float noiseMax = attention*100;
  for (float a = 0; a < TWO_PI; a += radians(3)) {
    float xoff = map(cos(a + phase), -1, 1, 0, noiseMax);
    float yoff = map(sin(a + phase), -1, 1, 0, noiseMax);
    float r = map(noise(xoff, yoff, zoff), 0, 1, size, size+30);
    float x = r * cos(a);
    float y = r * sin(a);
    vertex(x, y);
  }
  endShape(CLOSE);
  phase += 0.0001;
  zoff += 0.005;
  drawNote();
}

void drawNote() {
  textAlign(CENTER, CENTER);
  textSize(18);
  fill(13, 13, 13);
  text(nf(attention*100, 0, 1) + "% focused", 0, -10);
  textSize(13);
  text(nf(emotion*100, 0, 1) + "% "+emotionStatus, 0, 10);
}

void drawBlob4(float diameter, float[] data, float[] data1) {
  float lastAngle=0;
  noStroke();
  beginShape();
  for (int i = 0; i < data.length; i++) {
    fill(emotionColor[i]);
    arc(bx, by, diameter, diameter, lastAngle, lastAngle+radians(data[i]));
    lastAngle += radians(data[i]);
  }
  for (int i = 0; i < data.length; i++) {
    // Place the label of the arc in the middle of the slice outside circle
    float phi = lastAngle+radians(data[i]) / 2;
    float lx = bx + (70 + (DIAMETER+0) / 2) * cos (phi);
    float ly = by + (70 + (DIAMETER+0) / 2) * sin (phi);
    textAlign(CENTER);
    fill(255);
    text (label[i], lx, ly);
    lastAngle += radians(data[i]);
  }

  for (int i = 0; i < data1.length; i++) {
    stroke(255);
    fill(attentionColor[i]);
    arc(bx, by, diameter/2, diameter/2, lastAngle, lastAngle+radians(data1[i]));
    lastAngle += radians(data1[i]);
  }
  for (int i = 0; i < data1.length; i++) {
    // Place the label of the arc in the middle of the slice outside circle
    float phi = lastAngle+radians(data1[i]) / 2;
    float lx = bx + (20+(DIAMETER+20) / 2) * cos (phi);
    float ly = by + (20+(DIAMETER+20) / 2) * sin (phi);
    textAlign(CENTER);
    fill(255);
    text (label1[i], lx, ly);
    lastAngle += radians(data1[i]);
  }
}


void mousePressed() {
  if (overBlob) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by;
}

void mouseDragged() {
  if (locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset;
  }
}


void mouseReleased() {
  locked = false;
}
