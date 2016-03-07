package dii.vrp.data;

import dii.vrp.data.IDemands;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.tp.VRPRoute;

public class CVRPRouteEvaluator {
	
	private final IDistanceMatrix distances;
	private final IDemands demands;
	
	public CVRPRouteEvaluator(IDistanceMatrix distances, IDemands demands){
		this.distances=distances;
		this.demands=demands;
	}
	
	/**
	 * Evaluates a VRP route
	 * @param route
	 * @param distances
	 * @param demands
	 * @return
	 */
	public VRPRoute eval(final VRPRoute route){
		VRPRoute r=(VRPRoute) route.clone();
		double cost=0;
		double load=demands.getDemand(r.get(0));
		for(int i=1;i<r.size();i++){
			cost+=distances.getDistance(r.get(i-1),r.get(i));
			load+=demands.getDemand(r.get(i));
		}
		r.setCost(cost);
		r.setLoad(load);
		return r;
	}
	
}
