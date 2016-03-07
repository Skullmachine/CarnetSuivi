package dii.vrp.tp;

import java.util.List;

/**
 * Implements the interface to a route. Implementing classes can use any data structure (arrays, linked lists, etc.) store route information.
 * In jVRP a route is defined as a sequence of nodes. Node in position 0 is the starting point of the route, and node in position {@link #size()} is the ending
 * point of the route.</br>
 * Implementing classes must provide an implementation for method {@link #clone}
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Dec 5, 2015
 * @see {@link Cloneable}
 * @see {@link Object#clone}
 *
 */
public interface IRoute extends Cloneable{
	/**
	 * @return the number of nodes in the route
	 */
	public int size();
	/**
	 * @param nodeID the ID of the node
	 * @return true if the route contains node <code>nodeID</code>, false otherwise
	 */
	public boolean contains(int nodeID);
	/**
	 * Reverses the direction of the route. Let node 4 be in position 0 of the route and node 20 be in position {@link #size()}.
	 * After the call node 20 should appear in position 0 and node 4 in position {@link #size()}.
	 */
	public void reverse();
	/**
	 * 
	 * @param nodeID
	 * @return Returns the position of the first occurrence of node <code>nodeID</code> in the route, or -1 if the route does not contain the node.
	 */
	public int positionOf(int nodeID);
	/**
	 * @param i
	 * @return the ID of the node in position <code>i</code>
	 */
	public int get(int i);
	/**
	 * Appends node <code>nodeID</code> to the route (i.e., at the last position of the route).
	 * @param nodeID the node to append
	 */
	public void add(int nodeID);
	/**
	 * TODO add example of an insertion
	 * Inserts a node at a given possition of the route. Implementing classes should deal with indices bounds. Implementing clases should
	 * ensure that after the insertion, the node previouly in position <code>i</code> is in position <code>i+1</code>
	 * @param nodeID the node to insert
	 * @param i the inserting position
	 */
	public void insert(int nodeID, int i);
	/**
	 * Removes the first occurrence of the specified node from the route, if it is present.
	 * @param nodeID the node to remove
	 * @return true if the node was removed from the route, false otherwise (e.g., the node was not in the route)
	 */
	public boolean removeID(int nodeID);
	/**
	 * Removes the node in position <code>i</code> of the route. Implementing classes
	 * must ensure that the removal shifts the nodes to the left (e.g., the node in position <code>i+1<code> moves to <code>i</code>).
	 * @param i the position
	 * @return the ID of the removed node
	 */
	public int remove(int i);
	/**
	 * Swaps nodes in positions <code>i</code> and <code>j</code>
	 * @param i
	 * @param j
	 */
	public void swap(int i, int j);
	/**
	 * Relocates removes the node in position <code>i</code> from the route and re-inserts it at position <code>j</code>. Implementing classes
	 * must ensure that the removal shifts the nodes to the left (e.g., <code>i+1<code> moves to <code>i</code>) and that
	 * the insertion shifts the nodes to the right (e.g., the node in position <code>j</code> moves to <code>j+1</code>).
	 * @param i
	 * @param j
	 */
	public void relocate(int i, int j);
	/**
	 * 
	 * @return a hard copy of the route
	 */
	public IRoute clone();
	/**
	 * 
	 * @return the list of customers in the route. Implementing classes must ensure that nodes appear in the list in the same order
	 * in which they are visited by the route.
	 */
	public List<Integer> getRoute();
	
	
}
