public class Drop extends PhysicsObj
{
  color Color = color(210.0, 100.0, 100.0, 50.0);

  int unique_number = 0;

  float alpha;
  float Length = 0;

  public Drop(PVector pos)
  {
    super(pos);
    this.reset();
    processees.add(this);
    renderees.add(this);
    this.unique_number = unique_raindrop_number++;
  }

  public void reset()
  {
    this.pos.z = random(0.0, 20.0);

    this.pos.x = random(-width / 2, 3 * width / 2);
    this.pos.y = random(-100, -1000);

    this.Length = map(this.pos.z, 0.0, 20.0, 4.0, 16.0);
    this.alpha = map(this.pos.z, 0.0, 20.0, 100.0, 255.0);

    float satur = map(this.pos.z + sun.Light * 0.5, 0.0, 70.0, 5.0, 100.0);
    float bright = map(this.pos.z + min(100.0, sun.Light + moon.Light) * 0.5, 0.0, 70.0, 5.0, 100.0);
    this.Color = color(210.0, satur, bright, this.alpha);

    this.SpeedX = 0;
    this.SpeedY = this.pos.z;
  }

  public void setAcceleration()
  {
    this.AccX = -this.SpeedX * airFriction * this.Length + wind_acc_x;
    this.AccY = gravity - this.SpeedY * airFriction * this.Length + wind_acc_y;
    this.AccZ = - this.SpeedZ * airFriction * this.Length + wind_acc_z;

    if(mousePressed)
    {
      float x_offset = this.pos.x - mouseX;
      float y_offset = this.pos.y - mouseY;

      this.AccX += x_offset * mouse_acc_x;
      this.AccY += y_offset * mouse_acc_y;
    }
  }

  public void applySpeed()
  {
    this.SpeedX += this.AccX * dt / this.Length;
    this.SpeedY += this.AccY * dt / this.Length;
    this.SpeedZ += this.AccZ * dt / this.Length;

    this.pos.x += this.SpeedX * dt;
    this.pos.y += this.SpeedY * dt;
    this.pos.z += this.SpeedZ * dt;
  }

  public void stayInCanvas()
  {
    if(this.pos.y > height)
    {
      this.reset();
    }

    if(this.pos.x > 3 * width / 2 || this.pos.x < -width / 2)
    {
      this.reset();
    }
  }

  public void drawSelf()
  {
    if(this.unique_number <= random_drops)
    {
      stroke(this.Color, alpha);
      line(this.pos.x, this.pos.y, this.pos.z, this.pos.x + this.SpeedX, this.pos.y + this.Length + this.SpeedY, this.pos.z);
    }
  }
}
