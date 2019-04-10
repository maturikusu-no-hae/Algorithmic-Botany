public class Stars extends PhysicsObj {
  
  private PVector target = new PVector();
  private PVector startPos;
  private float kX;
  private float kY;
  private float Size;
  private float visibleSize = 2;
  
  public Stars(PVector dest, PVector start) {
    super(start);
    startPos = start.copy();
    this.Size = random(1.5, 6);
    this.target = dest.copy();
    if(target.x != this.pos.x)
    {
      this.kX = Math.signum(this.target.x - this.pos.x);
    }
    if(target.y != pos.y)
    {
      this.kY = Math.signum(this.target.y - this.pos.y);
    }
    
    stars.add(this);
  }
  
  @Override
  public void drawSelf() 
  {
    if(sun.Light < 10*(this.Size/3)) {
      stroke(this.Color);
      fill(this.Color);
      ellipse(this.pos.x, this.pos.y, this.visibleSize, this.visibleSize);
    }
  }
  
  @Override
  public void applySpeed() 
  {
    this.SpeedX = this.AccX*dt;
    this.SpeedY = this.AccY*dt;
    
    if(this.pos.x * this.kX < this.target.x * this.kX) {
      this.pos.x += this.kX * this.SpeedX;
    }
    if(this.pos.y * this.kY < this.target.y * this.kY) {
      this.pos.y += this.kY * this.SpeedY;
    }
  }
  
  @Override
  public void setColor() 
  {
    this.visibleSize = map(sun.Light, 0,10 * (this.Size/3), this.Size,1);
    this.Color = color(0,0,map(sun.Light, 100.0, 0.0, 178.5, 255.0));
  }
  
  @Override
  public void setAcceleration()
  {
    this.AccX = map(this.pos.x, startPos.x, target.x, (0.01 / this.Size), (0.05 / this.Size));
    this.AccY = map(this.pos.y, startPos.y, target.y, (0.01 / this.Size), (0.05 / this.Size));
  }
}
