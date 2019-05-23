public class Branch extends PhysicsObj
{
  PVector start;
  PVector end;
  PVector default_end;
  color Color = color(30.0, 110.0, 110.0);

  Tree source;
  boolean is_root = false;

  float default_len = 0.0;

  float friction = 0.1;

  float angle = PI / 8;
  float length_loss = 0.67;

  ArrayList<Branch> sub_branches = new ArrayList<Branch>();
  ArrayList<Leaf> my_leaves = new ArrayList<Leaf>();

  public Branch(PVector start, PVector end)
  {
    this.start = start;
    this.end = end;
    this.default_end = new PVector();
    this.default_end.set(this.end);

    this.default_len = PVector.sub(this.end, this.start).mag();

    processees.add(this);
    renderees.add(this);

    length_loss = map(hs2.getPos(), 1.0, width, 0.1, 0.7);
    angle = map(hs3.getPos(), 1.0, width, 0.0, PI / 2);
  }

  public void grow(Tree source)
  {
    PVector dir_ = PVector.sub(this.end, this.start);
    if(dir_.mag() < min_grown_length)
    {
      Leaf leaf = new Leaf(this.end);
      source.leaves.add(leaf);
      this.my_leaves.add(leaf);
      return;
    }

    dir_.rotate(this.angle);
    dir_.mult(this.length_loss);
    PVector newEndA = PVector.add(this.end, dir_);
    Branch newBranchA = new Branch(this.end, newEndA);
    newBranchA.source = source;

    source.branches.add(newBranchA);
    source.growing_branches.add(newBranchA);
    this.sub_branches.add(newBranchA);

    dir_.rotate(-2 * this.angle);
    PVector newEndB = PVector.add(this.end, dir_);
    Branch newBranchB = new Branch(this.end, newEndB);
    newBranchB.source = source;

    source.branches.add(newBranchB);
    source.growing_branches.add(newBranchB);
    this.sub_branches.add(newBranchB);
  }

  public ArrayList<Branch> get_all_sub_branches()
  {
    ArrayList<Branch> retval = new ArrayList<Branch>();
    for(Branch branch : this.sub_branches)
    {
      for(Branch ret_branch : branch.get_all_sub_branches())
      {
        retval.add(ret_branch);
      }
      retval.add(branch);
    }
    return retval;
  }

  public void setAcceleration()
  {
    float x_offset_acc = (this.default_end.x - this.end.x) * this.friction * this.default_len;
    float y_offset_acc = (this.default_end.y - this.end.y) * this.friction * this.default_len;
    float z_offset_acc = (this.default_end.z - this.end.z) * this.friction * this.default_len;

    this.AccX = wind_acc_x - this.SpeedX * (this.friction + airFriction) * this.default_len + x_offset_acc;
    this.AccY = wind_acc_y + gravity - this.SpeedY * (this.friction + airFriction) * this.default_len + y_offset_acc;
    this.AccZ = wind_acc_z - this.SpeedZ * (this.friction + airFriction) * this.default_len + z_offset_acc;

    if(mousePressed)
    {
      float x_offset = this.end.x - mouseX;
      float y_offset = this.end.y - mouseY;

      this.AccX += x_offset * mouse_acc_x;
      this.AccY += y_offset * mouse_acc_y;
    }
  }

  public void applySpeed()
  {
    this.SpeedX += this.AccX * dt / this.default_len;
    this.SpeedY += this.AccY * dt / this.default_len;
    this.SpeedZ += this.AccZ * dt / this.default_len;

    if(abs(this.SpeedX) > 10 || abs(this.SpeedY) > 10 || abs(this.SpeedZ) > 10)
    {
      for(int i = this.my_leaves.size() - 1; i >= 0; i--)
      {
        Leaf leaf = this.my_leaves.get(i);
        this.my_leaves.remove(leaf);
        this.source.leaves.remove(leaf);
        leaf.fall();
      }
    }

    PVector b_old_vector = PVector.sub(this.end, this.start);
    PVector b_speed = new PVector(this.SpeedX * dt, this.SpeedY * dt, this.SpeedZ * dt);
    PVector b_end_speed = PVector.add(b_speed, this.end);

    PVector b_false_vector = PVector.sub(b_end_speed, this.start);
    b_false_vector.mult(this.default_len / b_false_vector.mag());

    this.end.add(PVector.sub(b_false_vector, b_old_vector));
  }

  public void setColor()
  {
    this.Color = color(42.0, sun.Light * 0.5, min(100.0, sun.Light + moon.Light) * 0.5);
  }

  public void drawSelf()
  {
    stroke(this.Color);
    line(start.x, start.y, start.z, end.x, end.y, end.z);
  }
}
