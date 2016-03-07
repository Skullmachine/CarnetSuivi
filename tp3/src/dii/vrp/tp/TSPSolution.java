package dii.vrp.tp;

import java.util.List;

import dii.vrp.tp.ArrayRoute;

/**
 * Wraps an {@link ArrayList} to model a TSPSolution
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public class TSPSolution implements IRoute, ISolution {
	
	/**
	 * Stores the route
	 */
	private IRoute route;
	/**
	 * The objective function
	 */
	private double of=Double.NaN;
	/**
	 * Constructs a new TSPSolution
	 */
	public TSPSolution(){
		this.route=(IRoute) new ArrayRoute();
	}
	
	@Override
	public double getOF() {
		return of;
	}

	@Override
	public void setOF(double of) {
		this.of=of;
	}

	@Override
	public TSPSolution clone() {
		TSPSolution clone=new TSPSolution();
		clone.route=this.route.clone();
		clone.of=this.of;
		return clone;
	}

	@Override
	public int size() {
		return this.route.size();
	}

	@Override
	public boolean contains(int nodeID) {
		return this.route.contains(nodeID);
	}

	@Override
	public void reverse() {
		this.route.reverse();
	}

	@Override
	public int positionOf(int nodeID) {
		return this.route.positionOf(nodeID);
	}

	@Override
	public int get(int i) {
		return this.route.get(i);
	}

	@Override
	public void add(int nodeID) {
		this.route.add(nodeID);
	}

	@Override
	public void insert(int nodeID, int i) {
		this.route.insert(nodeID, i);

	}

	@Override
	public boolean removeID(int nodeID) {
		return this.route.removeID(nodeID);
	}

	@Override
	public int remove(int i) {
		return this.route.remove(i);
	}

	@Override
	public void swap(int i, int j) {
		this.route.swap(i, j);
	}

	@Override
	public void relocate(int i, int j) {
		this.route.relocate(i, j);
	}
	
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		sb.append(this.of+"|"+this.route.toString());
		return sb.toString();
	}

	@Override
	public List<Integer> getRoute() {
		return this.route.getRoute();
	}

}
