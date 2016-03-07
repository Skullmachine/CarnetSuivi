package dii.vrp.data;

/**
 * Defines the interface to distance matrices
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Dec 4, 2015
 *
 */
public interface IDistanceMatrix {
	/**
	 * 
	 * @param i
	 * @param j
	 * @return the distance between nodes <code>i</code> and <code>j</code>
	 */
	public double getDistance(int i, int j);
	/**
	 * Sets the distance between nodes <code>i</code> and <code>j</code>
	 * @param i
	 * @param j
	 * @param distance the distance between nodes <code>i</code> and <code>j</code>
	 */
	public void setDistance(int i, int j, double distance);
	/**
	 * 
	 * @return the size of the distance matrix. Implementing classes are responsible for defining exactly
	 * what the <code>size</code> means to them.
	 */
	public int size();
		
}
