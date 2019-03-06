public class Leaf extends PhysicsObj
{ 
  boolean falling = false;

  int Size = 8;

  public Leaf(PVector pos)
  {
    super(pos);
    renderees.add(this);
  }

  public void setAcceleration()
  {
    if(falling)
    {
      this.AccX = -this.SpeedX * airFriction * PI * pow(this.Size / 2, 2) + wind_acc_x;
      this.AccY = gravity - this.SpeedY * airFriction * PI * pow(this.Size / 2, 2) + wind_acc_y;

      if(mousePressed)
      {
        float x_offset = this.pos.x - mouseX;
        float y_offset = this.pos.y - mouseY;

        this.AccX += x_offset * mouse_acc_x;
        this.AccY += y_offset * mouse_acc_y;
      }
    }
  }

  public void applySpeed()
  {
    this.SpeedX += this.AccX * dt / (PI * pow(this.Size / 2, 2));
    this.SpeedY += this.AccY * dt / (PI * pow(this.Size / 2, 2));

    this.pos.x += this.SpeedX * dt;
    this.pos.y += this.SpeedY * dt;
  }

  public void stayInCanvas()
  {
    if((this.pos.y + this.Size / 2) > height)
    {
      this.SpeedX -= this.SpeedX * groundFriction * dt; // We both multiply by (PI * pow(this.Size / 2, 2)), as that is our contact area, and divide by it, as it's our "mass". Weird stuff.
      this.SpeedY -= this.SpeedY * groundFriction * dt;
      this.SpeedY *= -1;
      this.pos.y = height - this.Size / 2;
    }
    else if((this.pos.y - this.Size / 2) < -this.Size)
    {
      this.SpeedY = 0.0;
      this.pos.y = -this.Size / 2;
    }
    if((this.pos.x - this.Size / 2) < 0.0 || (this.pos.x + this.Size / 2) > width)
    {
      processees.remove(this);
      renderees.remove(this);
    }
  }

  public void setColor()
  {
    this.Color = color(140.0, sun.Light, min(100.0, sun.Light + moon.Light), 50.0);
  }

  public void drawSelf()
  {
    stroke(this.Color);
    fill(this.Color);
    ellipse(this.pos.x, this.pos.y, this.Size, this.Size);

    if(!falling && dist(this.pos.x, this.pos.y, mouseX, mouseY) < (this.Size / 2) + 2)
    {
      this.fall();
    }
  }

  public void fall()
  {
    PVector old_pos = this.pos;
    this.pos = new PVector();
    this.pos.set(old_pos);
    this.falling = true;
    processees.add(this);
  }
}
