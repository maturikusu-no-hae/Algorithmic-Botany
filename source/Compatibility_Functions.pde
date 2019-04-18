/*
  The project while written in Java-esque language heavily depends
  upon use of JavaScript, whose functions not declared directly by
  Processing may differ from Java functions.

  For the nefarious purposes of not having to think more about such
  stuff this module is created.

  See signum() function.
*/

public static class Compatibility_Functions
{
  public static float signum(float f)
  {
    // Use the pair of these to imply that code in this commented block
    // Should be uncommented after parsing.
    /*~
    return Math.sign(f);
    ~*/
    // Use the pair of these to imply that code in this uncommented block
    // Should be commeneted after parsing.
    /*!-*/
    return Math.signum(f);
    /*-!*/
  }

  public static boolean isNaN(float f)
  {
    return (f != f);
  }
}
