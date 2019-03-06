public class Tree
{
  ArrayList<Branch> branches = new ArrayList<Branch>();
  ArrayList<Leaf> leaves = new ArrayList<Leaf>();

  ArrayList<Branch> growing_branches = new ArrayList<Branch>();

  Branch root;

  int grown_times = 0;

  public Tree(float x, float y)
  {
    this.root = new Branch(new PVector(x, y), new PVector(x, y - map(hs1.getPos(), 1.0, width, 1.0, 200.0)));
    this.root.source = this;
    this.branches.add(root);
    this.growing_branches.add(root);
  }

  public void Del()
  {
    for(Branch branch : branches)
    {
      processees.remove(branch);
      renderees.remove(branch);
    }
    for(Leaf leaf : leaves)
    {
      renderees.remove(leaf);
    }
  }

  public void grow()
  {
    if(grown_times > max_grown_times)
    {
      return;
    }
    for(int i = this.growing_branches.size() - 1; i >= 0; i--)
    {
      Branch branch = this.growing_branches.get(i);
      branch.grow(this);
      this.growing_branches.remove(branch);
    }
    grown_times++;
  }
}
