package dii.vrp.tp;

/**
 * Thefines the interface of heuristics
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public interface IOptimizationAlgorithm {
	/**
	 * Runs the heuristic and returns a solution
	 * @return a solution to the optimization problem at hand
	 */
	public ISolution run();
	
}
