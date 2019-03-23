ArrayList<Tree> trees = new ArrayList<Tree>();

ArrayList<PhysicsObj> processees = new ArrayList<PhysicsObj>();
ArrayList<PhysicsObj> renderees = new ArrayList<PhysicsObj>();
float[][] BotanySign ={{53,250},{57,194},{60,140},{98,165},{110,225},{176,200},{217,196},{176,240},{220,230},{300,190},{330,195},{265,185},{295,250},{410,192},{390,220},{430,220},{445,252},{375,255},
{408,220},{500,252},{520,195},{554,232},{575,175},{625,172},{658,195},{692,167},{675,240},{295,215},{538,215},{512,218},{567,200}};

float gravity = 1.0;
float airFriction = 0.001;
float groundFriction = 0.7;

float mouse_acc_x = 0.05; 
float mouse_acc_y = 0.05;

float wind_acc_x = 0.0;
float wind_acc_y = 0.0;

int max_grown_times = 15; // Default: 15.
int min_grown_length = 4; // Default: 4.

int max_random_drops = 300;
int random_drops = max_random_drops;
int unique_raindrop_number = 0;

float dt = 1.0;

HScrollbar hs1;
HScrollbar hs2;
HScrollbar hs3;
HScrollbar hs4;
HScrollbar hs5;

Tree tree;
Sun sun;
// Moon moon;

void setup()
{
  size(800, 800);

  hs1 = new HScrollbar(0, 12, width, 16, 16, true);
  hs2 = new HScrollbar(0, 34, width, 16, 16, true);
  hs3 = new HScrollbar(0, 56, width, 16, 16, true);
  hs4 = new HScrollbar(0, 78, width, 16, 16, false);
  hs5 = new HScrollbar(0, 100, width, 16, 16, false);

  colorMode(HSB);
  sun = new Sun();
  // moon = new Moon();
  for(int i = 0;i<BotanySign.length;i++)
  {
    new Stars(new PVector(BotanySign[i][0],BotanySign[i][1]),new PVector(random(width),random(120,height/2)));
    println(i);
  }
  
  for(int i = 0; i < max_random_drops; i++)
  {
    new Drop(new PVector());
  }

  colorMode(HSB);
  tree = new Tree(width / 2, height);
  //trees.add(new Tree(width / 2, height));
}

void draw()
{
  /*
  pmouseX = pclientX;
  pmouseY = pclientY;
  mouseX = clientX;
  mouseY = clientY;
  mousePressed = pressedMouse;
  */

  background(150.0, min(sun.Light + 25.0, 230.0), min(sun.Light + 25.0, 230.0));
  if(mousePressed) 
  {
  println(pmouseX + " " + pmouseY);
  }
  sun.drawSelf();
  // moon.drawSelf();

  tree.grow();

  wind_acc_x = map(hs4.getPos(), 1.0, width, -10.0, 10.0);

  random_drops = round(map(hs5.getPos(), 1.0, width, 0.0, max_random_drops));

  for(int i = processees.size() - 1; i >= 0; i--)
  {
    PhysicsObj physics_obj = processees.get(i);
    physics_obj.process();
  }

  for(int i = renderees.size() - 1; i >= 0; i--)
  {
    PhysicsObj render_obj = renderees.get(i);
    render_obj.render();
  }

  hs1._update();
  hs2._update();
  hs3._update();
  hs4._update();
  hs5._update();
  hs1.display();
  hs2.display();
  hs3.display();
  hs4.display();
  hs5.display();

/*
  for(Tree tree : trees)
  {
    tree.drawSelf();
    tree.grow();
  }
*/
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  boolean update;

  HScrollbar (float xp, float yp, int sw, int sh, int l, boolean update) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
    this.update = update;
  }

  void _update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
      if(this.update)
      {
        tree.Del();
        tree = new Tree(width / 2, height);
      }
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}
