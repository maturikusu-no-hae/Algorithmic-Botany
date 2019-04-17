public class Sun
{
  float X = width / 2;
  float Y = height * 1.5;
  float Z = -70.0;

  float Light = 0.0;
  float Size = 100.0;

  float hue = 50.0;
  float satur = 100.0;
  float bright = 100.0;

  float SpeedX = 0.0;
  float SpeedY = 0.0;

  float DefaultAccY = -0.0005;

  float AccX = 0.0;
  float AccY = this.DefaultAccY;

  public void drawSelf()
  {
    if(mousePressed)
    {
      if(dist(this.X, this.Y, pmouseX, pmouseY) < (this.Size / 2))
      {
        this.X = mouseX;
        this.Y = mouseY;
      }
    }
    this.SpeedX += this.AccX * dt;
    this.SpeedY += this.AccY * dt;

    this.X += this.SpeedX * dt;
    this.Y += this.SpeedY * dt;

    if(this.Y < -height * 0.5)
    {
      this.Y = -height * 0.5;
      this.SpeedY *= -1;
    }
    else if(this.Y > height * 1.5)
    {
      this.Y = height * 1.5;
      this.AccY = this.DefaultAccY;
      this.SpeedY = 0.0;
    }

    this.Size = map(this.Y, height * 1.5, -height * 0.5, 1.0, 100.0);
    this.Light = map(this.Y, height * 1.5, -height * 0.5, 0.0, 100.0);
    this.hue = map(this.Y, height * 1.5, height * 0.25, 30.0, 50.0);

    stroke(this.hue, this.satur, this.bright);
    fill(this.hue, this.satur, this.bright);
    push();
    translate(this.X, this.Y, this.Z);
    sphere(this.Size / 2);
    pop();
    // ellipse(this.X, this.Y, this.Size, this.Size);
  }
}
