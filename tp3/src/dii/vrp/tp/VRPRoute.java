package dii.vrp.tp;

import java.util.List;

/**
 * Models a VRP route. This implementation wraps a {@link ArrayList} to support {@IRoute} services.
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 21, 2016
 *
 */
public class VRPRoute implements IRoute{
	/**
	 * The route
	 */
	private IRoute route;
	/**
	 * The total load of the route
	 */
	private double load=Double.NaN;
	/**
	 * The total cost of the route
	 */
	private double cost=Double.NaN;
	/**
	 * 
	 */
	public VRPRoute(){
		this.route=new ArrayRoute();
	}
	
	@Override
	public int size() {
		return route.size();
	}

	@Override
	public boolean contains(int nodeID) {
		return route.contains(nodeID);
	}

	@Override
	public void reverse() {
		route.reverse();
	}

	@Override
	public int positionOf(int nodeID) {
		return route.positionOf(nodeID);
	}

	@Override
	public int get(int i) {
		return route.get(i);
	}

	@Override
	public void add(int nodeID) {
		route.add(nodeID);
	}

	@Override
	public void insert(int nodeID, int i) {
		route.insert(nodeID, i);	
	}

	@Override
	public boolean removeID(int nodeID) {
		return route.removeID(nodeID);
	}

	@Override
	public int remove(int i) {
		return route.remove(i);
	}

	@Override
	public void swap(int i, int j) {
		route.swap(i, j);
	}

	@Override
	public void relocate(int i, int j) {
		route.relocate(i, j);		
	}

	@Override
	public IRoute clone() {
		VRPRoute clone=new VRPRoute();
		clone.route=this.route.clone();
		clone.cost=this.cost;
		clone.load=this.load;
		return clone;
	}
	
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		sb.append(this.cost+"|"+this.load+"|"+this.route);
		return sb.toString();
	}

	/**
	 * @return the load
	 */
	public double getLoad() {
		return load;
	}

	/**
	 * @param load the load to set
	 */
	public void setLoad(double load) {
		this.load = load;
	}

	/**
	 * @return the cost
	 */
	public double getCost() {
		return cost;
	}

	/**
	 * @param cost the cost to set
	 */
	public void setCost(double cost) {
		this.cost = cost;
	}

	@Override
	public List<Integer> getRoute() {
		return this.route.getRoute();
	}

}
