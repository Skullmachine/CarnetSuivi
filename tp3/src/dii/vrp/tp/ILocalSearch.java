package dii.vrp.tp;

/**
 * Defines the interface of local search procedures
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public interface ILocalSearch {
	/**
	 * Runs the local search procedure and returns a local optimum. Implementing classes must ensure that the returned local optimum 
	 * is evaluated (i.e., its objective function is computed)
	 * @param s the starting solution
	 * @param sense the optimization sense (maximization or minimization)
	 * @return a local optimum
	 */
	public ISolution run(final ISolution s, final OptimizationCriterion sense);
		
}
