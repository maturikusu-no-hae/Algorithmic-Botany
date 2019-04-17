public class PhysicsObj
{
  // The current position of this very object.
  public PVector pos;

  // These variables are related to how the object moves. They should be private or restricted really.
  public float SpeedX = 0.0;
  public float SpeedY = 0.0;
  public float SpeedZ = 0.0;

  public float AccX = 0.0;
  public float AccY = 0.0;
  public float AccZ = 0.0;

  // The very color of our object. It's placed here so we can easily dynamically change it based on lightning.
  public color Color;

  // Used to flag those objects that are up for deletion.
  boolean deleting;

  public PhysicsObj()
  {
  }

  public PhysicsObj(PVector pos)
  {
    this.pos = pos;
  }

  // Call this function only in draw/threading processing function to process the object.
  public void process()
  {
    this.setAcceleration();
    this.applySpeed();
    this.stayInCanvas();
  }

  public void render()
  {
    this.setColor();
    this.drawSelf();
  }

  // This function should set the acceleration based on all the forces that this object should account for.
  public void setAcceleration()
  {
    this.AccX = 0.0;
    this.AccY = 0.0;
    this.AccZ = 0.0;
  }

  // This function should be overwritten only when special features are added, such as falling off leaves, or such.
  public void applySpeed()
  {
    this.SpeedX += this.AccX * dt;
    this.SpeedY += this.AccY * dt;
    this.SpeedZ += this.AccZ * dt;

    this.pos.x += this.SpeedX * dt;
    this.pos.y += this.SpeedY * dt;
    this.pos.z += this.SpeedZ * dt;
  }

  // This function should have contents of helping our object staying in canvas. If ever required.
  public void stayInCanvas()
  {
  }

  // Set our color based on light, mostly.
  public void setColor()
  {
  }

  // This function is called to draw the object.
  public void drawSelf()
  {
  }
}
