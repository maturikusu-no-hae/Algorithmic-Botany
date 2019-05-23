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

void setup()
{
  size(800, 800);

  colorMode(HSB);

  setRules(rules);
}

void draw()
{
  pmouseX = pclientX;
  pmouseY = pclientY;
  mouseX = clientX;
  mouseY = clientY;
  mousePressed = pressedMouse;

  len_ = map(getSliderValue("myRange1"), 1.0, 100.0, 1, 15);
  angle_ = map(getSliderValue("myRange2"), 1.0, 100.0, 0, PI / 2);
  iterations = round(map(getSliderValue("myRange3"), 1.0, 100.0, 1.0, 6.0));

  if(n <= iterations)
  {
    if(newRules)
    {
      rules = new Rule[round(saved_array.length / 3)];
      for(int i = 0; i < saved_array.length; i += 3)
      {
        rules[round(i / 3)] = new Rule(saved_array[i], saved_array[i + 1], round(saved_array[i + 2]));
      }
      newRules = false;
    }
    background(150);
    n += 1;
    turtle.reset();
    generate();
    turtle.process_sentence();
  }

  if(updateTree)
  {
    sentence = new String(axiom);
    n = 0;
    updateTree = false;
  }
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
