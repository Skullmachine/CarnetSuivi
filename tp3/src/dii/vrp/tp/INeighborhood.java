package dii.vrp.tp;

/**
 * Defines the interface for neighborhoods
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public interface INeighborhood {
	/**
	 * Sets the neighborhood's exploration strategy
	 * @param strategy the new exploration strategy
	 */
	public void setExplorationStrategy(ExplorationStrategy strategy);
	/**
	 * 
	 * @return the current exploration strategy
	 */
	public ExplorationStrategy getStrategy();
	
	/**
	 * Explores the neighborhood and returns a neighbor solution. Depending on the exploration strategy, the returned solution may be
	 * the best solution in the neighborhood of <code>s</code> or the first improving solution found during the exploration. Implementing classes
	 * should enssure that the returned solution is evaluated (i.e., its objective function is computed).
	 * @param s the solution from where the neighborhood exploration starts
	 * @return an improving neighborh solution of <code>s</code> if found and <code>null</code> otherwise.
	 */
	public ISolution explore(ISolution s);
	
	
}
