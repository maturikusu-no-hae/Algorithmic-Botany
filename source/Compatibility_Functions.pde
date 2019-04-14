public static class Compatibility_Functions
{
  public static float signum(float f)
  {
    return abs(f) / f;
  }

  public static boolean isNaN(float f)
  {
    return (f != f);
  }
}
