package dii.vrp.tp;

/**
 * Enumerates the neighborhood exploration strategies
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public enum ExplorationStrategy {
	/**
	 * Neighborhoods are explored using a fist improvement strategy (that is, the exploration ends as soon as an improving solution is found)
	 */
	FIRST_IMPROVEMENT,
	/**
	 * Neighborhoods are explored using a best improvement strategy (that is, the exploration returns the best neighborh solution)
	 */
	BEST_IMPROVEMENT
	
}
