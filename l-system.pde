String axiom = "X";
String sentence = new String(axiom);
Rule[] rules = new Rule[]
{
  new Rule("F", "FF", 1),
  new Rule("F", "F[+F]F[-F][F]", 1),
  new Rule("F", "FF-[-F+F+F]+[+F-F-F]", 1),
  new Rule("F", "[+F][-F]F[++F][--F]", 1),
  new Rule("X", "FX", 1),
  new Rule("X", "F[+X][-X]FX", 1),
  new Rule("X", "F[+X]F[-X]+X", 1),
  new Rule("X", "F-[[X]+X]+F[+FX]-X", 1),
};

Turtle turtle = new Turtle();

int n = 0; // Iterations already done.

float len_ = 2; // Def: 2, change to 15 to see up closer.
float angle_ = radians(25.7);
int iterations = 7; // Def: 7, change to 3 so your computer won't burn.

HScrollbar hs1;
HScrollbar hs2;
HScrollbar hs3;

void setup()
{
  size(800, 800);

  colorMode(HSB);

  hs1 = new HScrollbar(0, 12, width, 16, 16, true);
  hs2 = new HScrollbar(0, 38, width, 16, 16, true);
  hs3 = new HScrollbar(0, 64, width, 16, 16, true);
}

void draw()
{
  pmouseX = pclientX;
  pmouseY = pclientY;
  mouseX = clientX;
  mouseY = clientY;
  mousePressed = pressedMouse;

  hs1._update();
  hs2._update();
  hs3._update();

  len_ = map(hs1.getPos(), 1.0, width, 1, 15);
  angle_ = map(hs2.getPos(), 1.0, width, 0, PI / 2);
  iterations = round(map(hs3.getPos(), 1.0, width, 1.0, 6.0));

  if(n <= iterations)
  {
    background(150);
    n += 1;
    turtle.reset();
    generate();
    turtle.process_sentence();
  }
  hs1.display();
  hs2.display();
  hs3.display();
}

void generate()
{
  String nextSentence = "";
  for(int i = 0; i < sentence.length(); i++)
  {
    char current = sentence.charAt(i);
    Rule rule = pick_weighted_rule(current);
    if(rule == null)
    {
      nextSentence += current;
    }
    else
    {
      nextSentence += rule.B;
    }
  }
  sentence = nextSentence;
}

Rule pick_weighted_rule(char syl)
{
  int max_value = 0;
  ArrayList<Rule> possibilities = new ArrayList<Rule>();
  for(int i = 0; i < rules.length; i++)
  {
    if(syl != rules[i].A.charAt(0))
    {
      continue;
    }
    max_value += rules[i].probability;
    possibilities.add(rules[i]);
  }

  int size_ = possibilities.size();
  if(size_ == 0)
  {
    return null;
  }

  float random_value = random(0, max_value);
  int current_value = 0;
  for(int i = 0; i < size_; i++)
  {
    Rule rule = possibilities.get(i);
    current_value += rule.probability;
    if(random_value <= current_value)
    {
      return rule;
    }
  }
  return null;
}

/*
Rule pick_weighted_rule(char syl)
{
  ArrayList<String[]> possibilities = new ArrayList<String[]>();
  for(int i = 0; i < rules.length; i++)
  {
    if(syl != rules[i][0].charAt(0))
    {
      continue;
    }
    int amount = let2num(rules[i][2]);
    for(int j = 0; j < amount; j++)
    {
      possibilities.add(rules[i]);
    }
  }
  if(possibilities.size() == 0)
  {
    return null;
  }
  return possibilities.get(round(random(0, possibilities.size() - 1))); 
}
*/

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
        sentence = new String(axiom);
        n = 0;
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
    fill(0.0, 0.0, 80.0);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0.0, 0.0, 0.0);
    } else {
      fill(0.0, 0.0, 40.0);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

class Rule
{
  String A;
  String B;

  int probability;

  public Rule(String A, String B, int probability)
  {
    this.A = A;
    this.B = B;
    this.probability = probability;
  }
}

class Turtle
{
  PVector pos;
  PVector old_pos;

  ArrayList<PVector> saved_poses;
  ArrayList<PVector> saved_old_poses;

  float rotation_angle;

  ArrayList<Float> saved_rotation_angles;

  float hue;
  float satu;
  float bri;

  ArrayList<Float> saved_hues;
  ArrayList<Float> saved_satus;
  ArrayList<Float> saved_bris;

  int last_save = 0;

  public Turtle()
  {
    this.reset();
  }

  public void process_sentence()
  {
    for(int i = 0; i < sentence.length(); i++)
    {
      if(this.hue > 100)
      {
        this.hue -= random(0, 60);
      }
      if(this.satu > 255)
      {
        this.satu -= random(0, 60);
      }
      if(this.bri > 255)
      {
        this.bri = 255;
      }
      char current = sentence.charAt(i);
      if(current == "F")
      {
        this.last_save++;
        this.hue -= random(0, 0.15) / this.last_save;
        this.satu -= random(0, 0.1);
        this.bri += 0.01;
        stroke(this.hue, this.satu, this.bri);

        this.old_pos.set(this.pos);

        this.pos.y -= len_;

        PVector rotated_pos = PVector.sub(this.pos, this.old_pos);
        rotated_pos.rotate(this.rotation_angle);
        this.pos.set(PVector.add(this.old_pos, rotated_pos));

        line(this.old_pos.x, this.old_pos.y, this.pos.x, this.pos.y);
      }
      else if(current == "+")
      {
        this.last_save++;
        this.hue += 0.04 * this.last_save;
        this.satu += 0.1;
        this.rotation_angle += angle_;
      }
      else if(current == "-")
      {
        this.last_save++;
        this.hue += 0.04 * this.last_save;
        this.satu += 0.1;
        this.rotation_angle -= angle_;
      }
      else if(current == "[")
      {
        this.push();
      }
      else if(current == "]")
      {
        this.pop();
      }
    }
  }

  public void reset()
  {
    PVector pos = new PVector(width / 2, height);
    this.old_pos = new PVector();
    this.old_pos.set(pos);
    this.pos = pos;

    saved_poses = new ArrayList<PVector>();
    saved_old_poses = new ArrayList<PVector>();

    rotation_angle = 0.0;

    saved_rotation_angles = new ArrayList<Float>();

    hue = 30.0;
    satu = 70.0;
    bri = 70.0;

    saved_hues = new ArrayList<Float>();
    saved_satus = new ArrayList<Float>();
    saved_bris = new ArrayList<Float>();
  }

  public void push()
  {
    PVector saved_pos = new PVector();
    saved_pos.set(this.pos);
    this.saved_poses.add(saved_pos);
    PVector saved_old_pos = new PVector();
    saved_old_pos.set(this.old_pos);
    this.saved_old_poses.add(saved_old_pos);
    this.saved_rotation_angles.add(this.rotation_angle);
    this.saved_hues.add(this.hue);
    this.saved_satus.add(this.satu);
    this.saved_bris.add(this.bri);

    this.last_save = 0;
  }

  public void pop()
  {
    int size_ = this.saved_poses.size() - 1;
    this.pos = this.saved_poses.get(size_);
    this.saved_poses.remove(size_);

    size_ = this.saved_old_poses.size() - 1;
    this.old_pos = this.saved_old_poses.get(size_);
    this.saved_old_poses.remove(size_);

    size_ = this.saved_rotation_angles.size() - 1;
    this.rotation_angle = this.saved_rotation_angles.get(size_);
    this.saved_rotation_angles.remove(size_);

    size_ = this.saved_hues.size() - 1;
    this.hue = this.saved_hues.get(size_);
    this.saved_hues.remove(size_);

    size_ = this.saved_satus.size() - 1;
    this.saved_satus.get(size_);
    this.saved_satus.remove(size_);

    size_ = this.saved_bris.size() - 1;
    this.saved_bris.get(size_);
    this.saved_bris.remove(size_);
  }
}
