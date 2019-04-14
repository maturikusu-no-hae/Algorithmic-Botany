public class Stars extends PhysicsObj
{  
  PVector target = new PVector();
  PVector startPos;
  float kX;
  float kY;
  float Size;
  float visibleSize = 2;

  float hue = 0.0;
  
  public Stars(PVector dest, PVector start)
  {
    super(start);
    this.startPos = start;
    this.Size = random(1.5, 6);
    this.target = dest;
    this.hue = random(0.0, 360.0);

    if(this.target.x != this.pos.x)
    {
      this.kX = Math.signum(this.target.x - this.pos.x);
    }
    if(this.target.y != pos.y)
    {
      this.kY = Math.signum(this.target.y - this.pos.y);
    }
    
    stars.add(this);
  }

  public void drawSelf() 
  {
    if(sun.Light < this.Size * 3.3)
    {
      stroke(this.Color);
      fill(this.Color);
      ellipse(this.pos.x, this.pos.y, this.visibleSize, this.visibleSize);
    }
  }

  public void applySpeed() 
  {
    this.SpeedX += this.AccX * dt;
    this.SpeedY += this.AccY * dt;
    
    if(this.pos.x * this.kX < this.target.x * this.kX)
    {
      this.pos.x += this.kX * this.SpeedX;
    }

    if(this.pos.y * this.kY < this.target.y * this.kY)
    {
      this.pos.y += this.kY * this.SpeedY;
    }
  }

  public void setColor() 
  {
    this.visibleSize = map(sun.Light, 0, this.Size * 3.3, this.Size, 1) + random(-this.Size / 5, this.Size / 5);
    this.Color = color(this.hue, 5, map(sun.Light, 100.0, 0.0, 178.5, 255.0));
  }

  public void setAcceleration()
  {
    this.AccX = map(this.pos.x, startPos.x, target.x, (0.01 / this.Size), (0.05 / this.Size));
    this.AccY = map(this.pos.y, startPos.y, target.y, (0.01 / this.Size), (0.05 / this.Size));
  }
}
