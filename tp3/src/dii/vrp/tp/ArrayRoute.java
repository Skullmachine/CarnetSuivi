package dii.vrp.tp;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Implements a route using an {@link ArrayList} as the underlying data structure
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Dec 5, 2015
 *
 */
public class ArrayRoute implements IRoute {
	/**
	 * Holds the route
	 */
	private ArrayList<Integer> route=new ArrayList<>();
	
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
		Collections.reverse(route);
	}

	@Override
	public int positionOf(int nodeID) {
		return route.indexOf(nodeID);
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
		if(i==route.size())
			route.add(nodeID);
		else
			route.add(i,nodeID);
	}

	@Override
	public boolean removeID(int nodeID) {
		return route.remove(new Integer(nodeID));
	}

	@Override
	public int remove(int i) {
		return route.remove(i);
	}

	@Override
	public void swap(int i, int j) {
		int temp=this.get(i);
		route.set(i,this.get(j));
		route.set(j, temp);
	}

	@Override
	public void relocate(int i, int j) {
		if(i<j){
			route.add(j,this.get(i));
			route.remove(i);
		}else{
			route.add(j,this.remove(i));
		}
	}

	@Override
	public IRoute clone() {
		ArrayRoute clone=new ArrayRoute();
		for(Integer i:route){
			clone.add(i);
		}
		return clone;
	}
	
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		sb.append("[\t");
		for(Integer i:this.route)
			sb.append(i+"\t");
		sb.append("]");
		return sb.toString();
	}
	/**
	 * To guarantee object encapsulation this method returns a hard copy of the list of nodes in the route. Therefore, the method runs in O(n), 
	 * where n is the number of nodes in the route. If client classes do not really need a copy of the list, they can iterate
	 * through the route more efficiently using method {@link #get(int)} within a ≤code>for</code> loop.
	 */
	@Override
	public List<Integer> getRoute() {
		return new ArrayList<Integer>(this.route);
	}


}
