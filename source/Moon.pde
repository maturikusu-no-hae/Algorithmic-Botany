public class Moon
{
  float X = width / 2;
  float Y = height * 1.5;

  float Light = 0.0;
  float Size = 100.0;

  float hue = 190.0;
  float satur = 10.0;
  float bright = 80.0;

  float SpeedX = 0.0;
  float SpeedY = 0.0;

  float DefaultAccY = -0.00025;

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
    this.hue = 190.0;
    this.satur = 10.0;

    float overlap = map(((this.Size + sun.Size) / 2) - dist(this.X, this.Y, sun.X, sun.Y), (this.Size + sun.Size) / 2, 0.0, 100.0, 0.0);
    if(overlap > 0.0 && (this.Y - (this.Size / 2)) < height && (this.Y + (this.Size / 2)) > 0.0)
    {
      if(overlap > this.Size / 2)
      {
        this.hue = sun.hue;
      }
      this.satur = ((this.satur + sun.satur) / 2) * overlap / 100.0;
      sun.Light = max(0.0, sun.Light - overlap);
    }

    this.Light = map(this.Y, height * 1.5, -height * 0.5, 0.0, sun.Light);

    stroke(this.hue, this.satur, this.bright);
    fill(this.hue, this.satur, this.bright);
    ellipse(this.X, this.Y, this.Size, this.Size);
  }
}
