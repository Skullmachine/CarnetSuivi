package dii.vrp.data;

/**
 * Defines the interface to demands
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 17, 2016
 *
 */
public interface IDemands {
	/**
	 * @param i
	 * @return the demand of node <code>i</code>
	 */
	public double getDemand(int i);
	/**
	 * Sets the demande of a node
	 * @param i the node's ID
	 * @param demand the demand to set
	 */
	public void setDemand(int i, double demand);
	/**
	 * Sets the demands.
	 * @param demands the demands to set.
	 */
	public void setDemands(double [] demands);

}
