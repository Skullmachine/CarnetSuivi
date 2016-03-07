package dii.vrp.data;

import dii.vrp.tp.TSPSolution;

public class PrinsExample {

	/**
	 * Builds the distance matrix for the example on page 5 of Prins (2004)
	 * @return the distance matrix
	 */
	public static IDistanceMatrix getDistances(){
		
		IDistanceMatrix distances=new ArrayDistanceMatrix(6);
		distances.setDistance(0, 1, 20);
		distances.setDistance(1, 0, 20);
		distances.setDistance(0, 2, 25);
		distances.setDistance(2, 0, 25);
		distances.setDistance(0, 3, 30);
		distances.setDistance(3, 0, 30);
		distances.setDistance(0, 4, 40);
		distances.setDistance(4, 0, 40);
		distances.setDistance(0, 5, 35);
		distances.setDistance(5, 0, 35);
		distances.setDistance(1, 2, 10);
		distances.setDistance(2, 3, 30);
		distances.setDistance(3, 4, 25);
		distances.setDistance(4, 5, 15);
		
		return distances;
		
	}
	/**
	 * Builds the demands for the example in page 5 of Prins 2004
	 * @return the demands
	 */
	public static IDemands getDemands(){
		IDemands demands=new ArrayDemands(6);
		demands.setDemand(1,5);
		demands.setDemand(2,4);
		demands.setDemand(3,4);
		demands.setDemand(4,2);
		demands.setDemand(5,7);
		return demands;
	}
	/**
	 * 
	 * @return the capacity for the example in page 5 of Prins 2004
	 */
	public static double getCapacity(){
		return 10;
	}
	
	public static TSPSolution getTSPTour(){
		TSPSolution tour=new TSPSolution();
		tour.add(0);
		tour.add(1);
		tour.add(2);
		tour.add(3);
		tour.add(4);
		tour.add(5);
		tour.add(0);
		return tour;
	}
	
}
