package dii.vrp.tp;

/**
 * Defines the interface for TSP heuristics
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public interface ITSPHeuristic extends IOptimizationAlgorithm{
	/**
	 * Sets the initial node in the TSP tour
	 * @param i the initial node of the tour
	 */
	public void setInitNode(int i);
	
	@Override
	public TSPSolution run();
	
}
