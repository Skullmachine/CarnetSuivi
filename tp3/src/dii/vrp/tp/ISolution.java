/* Log of changes:
 * Mar 24, 2012   Solution implemented
 */

/* To Do List:
 * 
 */
package dii.vrp.tp;

/**
 * Defines an interface of solutions
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @since Mar 24, 2012
 *
 */
public interface ISolution extends Cloneable{
	
	/**
	 * 
	 * @return the objective function of the solution
	 */
	public double getOF();
	/**
	 * 
	 * @param of the objective function to set
	 */
	public void setOF(final double of);
	/**
	 * 
	 * @return a dept copy of the solution
	 */
	public ISolution clone();
	
}
