package dii.vrp.tp;

import java.util.ArrayList;
import java.util.List;

/**
 * Models a VRP solution
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 21, 2016
 *
 */
public class VRPSolution implements ISolution {
	/**
	 * The routes
	 */
	private List<IRoute> routes;
	/**
	 * The objective function
	 */
	private double of=Double.NaN;
	
	public VRPSolution(){
		this.routes=new ArrayList<IRoute>();
	}
	
	@Override
	public double getOF() {
		return this.of;
	}

	@Override
	public void setOF(double of) {
		this.of=of;
	}

	@Override
	public ISolution clone() {
		VRPSolution clone=new VRPSolution();
		clone.of=this.of;
		clone.routes=this.cloneRoutes();
		return clone;
	}
	/**
	 * 
	 * @return the number of routes in the solution
	 */
	public int size(){
		return this.routes.size();
	}
	/**
	 * 
	 * @param r the route index
	 * @return the size of route <code>r</code> (i.e., the number of nodes visited by the route)
	 */
	public int size(int r){
		return this.routes.get(r).size();
	}
	/**
	 * 
	 * @param r the route index
	 * @return the load of route <code>r</code>
	 */
	public double getLoad(int r){
		return ((VRPRoute)this.routes.get(r)).getLoad();
	}
	/**
	 * 
	 * @param r the route index
	 * @return the cost of route <code>r</code>
	 */
	public double getCost(int r){
		return ((VRPRoute)this.routes.get(r)).getCost();
	}
	/**
	 * 
	 * @return a hard copy of the routes in the solution
	 */
	public List<IRoute> getRoutes(){
		return this.cloneRoutes();
	}
	/**
	 * Returns a copy of the route in position <code>i</code> in the solution
	 * @param r 
	 * @return copy of the route in position <code>i</code> in the solution
	 */
	public IRoute getRoute(int r){
		return routes.get(r).clone();
	}
	/**
	 * Sets the set of routes in the solution. For encapsulation purposes the method makes calls {@link #clone()} on each route 
	 * @param routes
	 */
	public void setRoutes(List<IRoute> routes){
		this.routes=new ArrayList<>();
		for(IRoute r:routes)
			this.routes.add(r.clone());
	}
	/**
	 * Adds a route to the solution.
	 * @param r the route to add
	 */
	public void addRoute(final IRoute r){
		this.routes.add(r.clone());
	}
	/**
	 * Inserts a route into a specific position of the solution
	 * @param r the route to insert
	 * @param i the possition in which the route must be inserted
	 */
	public void insertRoute(final IRoute r, int i){
		this.routes.add(i, r);
	}
	/**
	 * 
	 * @param r the index of the route
	 * @param i the position in the route
	 * @return Returns the node in position <code>i</code> of route <code>r</code>
	 */
	public int getNode(int r, int i){
		return this.routes.get(r).get(i);
	}
	/**
	 * Sets the cost of a route
	 * @param r the route
	 * @param cost the cost to set
	 */
	public void setCost(int r, double cost){
		((VRPRoute)this.routes.get(r)).setCost(cost);
	}
	/**
	 * Sets the load of a route
	 * @param r the route
	 * @param load the load to set
	 */
	public void setLoad(int r, double load){
		((VRPRoute) this.routes.get(r)).setLoad(load);
	}	
	/**
	 * Removes route <code>r</code> from the solution.</br>
	 * 
	 * <strong>Examples</strong><br>
	 * 
	 * Assume the current solution <code>s</code> has two routes <code>{0,3,4,5,0}</code> and <code>{0,2,1,0}</code>.</br>
	 * 
	 * <code>remove(1)</code> leads to <code>s={{0,3,4,5,0}}</code>.</br>
	 * 
	 * Any call to the method with <code>r>=s.sise()</code> or <code>r<0</code> results on an {@link IndexOutOfBoundsException}.</br>
	 * 
	 * 
	 * @param r the index of the route to remove
	 * @return the removed route
	 */
	public IRoute remove(int r){
		return this.routes.remove(r); //need no cloning since the route no longer defines the state of this route solution object
	}
	/**
	 * Removes the node in position <code>i</code> of route <code>r</code>
	 * 
	 * <strong>Examples</strong><br>
	 * 
	 * Assume the current solution <code>s</code> has two routes <code>{0,3,4,5,0}</code> and <code>{0,2,1,0}</code>.</br>
	 * 
	 * <code>remove(1,0)</code> leads to <code>s={{0,3,4,5,0},{2,1,0}}</code></br>
	 * <code>insert(1,1)</code> leads to <code>s={{0,3,4,5,0},{0,1,0}}</code></br>
	 * <code>insert(1,3)</code> leads to <code>s={{0,3,4,5,0},{0,2,1}}</code></br>
	 * 
	 * Any call to the method with <code>i>=r.sise()</code> or <code>i<0</code> results on an {@link IndexOutOfBoundsException}.</br>
	 * 
	 * Note that for the sake of flexibility this method does not check semantic constraints such as: the first and last node in the route should be the same, or
	 * a node cannot be visited more than once by a route. Client classes are responsible for controling these constraints depending on the VRP in hand.
	 * 
	 * @param r the route
	 * @param i the position in route <code>r</code> 
	 * @return the ID of the removed node
	 */
	public int remove(int r, int i){
		return this.routes.get(r).remove(i);
	}
	/**
	 * Inserts <code>node</code> in position <code>i</code> of route <code>r</code></br>
	 * 
	 * <strong>Examples</strong><br>
	 * 
	 * Assume the current solution <code>s</code> has two routes <code>{0,3,4,5,0}</code> and <code>{0,2,1,0}</code>.</br>
	 * 
	 * <code>insert(6,1,0)</code> leads to <code>s={{0,3,4,5,0},{6,0,2,1,0}}</code></br>
	 * <code>insert(6,1,1)</code> leads to <code>s={{0,3,4,5,0},{0,6,2,1,0}}</code></br>
	 * <code>insert(6,1,3)</code> leads to <code>s={{0,3,4,5,0},{0,2,1,6,0}}</code></br> 
	 * <code>insert(6,1,4)</code> leads to <code>s={{0,3,4,5,0},{0,2,1,0,6}}</code></br>
	 * 
	 * Any call to the method with <code>i>r.sise()</code> or <code>i<0</code> results on an {@link IndexOutOfBoundsException}.</br>
	 * 
	 * Note that for the sake of flexibility this method does not check semantic constraints such as: the first and last node in the route should be the same, or
	 * a node cannot be visited more than once by a route. Client classes are responsible for controling these constraints depending on the VRP in hand.
	 * 
	 * @param node the ID of the node to insert
	 * @param r the route
	 * @param i the position in route <code>r</code>
	 */
	public void insert(int node, int r, int i){
		if(this.routes.get(r).size()==i)
			this.routes.get(r).add(node);
		else
			this.routes.get(r).insert(node, i);
	}
	/**
	 * Removes from the solution every route <code>r</code> with <code>r.size()==size</code>
	 * @param size the size of the routes to remove
	 */
	public void removeRoutesBysize(int size){
		for(int r=0;r<this.routes.size();r++){
			if(routes.get(r).size()==size){
				this.routes.remove(r);
				r--;
			}
		}
	}
	
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		sb.append(this.of+"\n");
		for(IRoute r:routes){
			sb.append(r.toString()+"\n");
		}
		return sb.toString();
	}
	
	/**
	 * Internal method for cloning the list of routes
	 * @return a hard copy of the list of routes
	 */
	private List<IRoute> cloneRoutes(){
		List<IRoute> clone=new ArrayList<>();
		for(IRoute r:routes)
			clone.add(r.clone());
		return clone;
	}
	
}
