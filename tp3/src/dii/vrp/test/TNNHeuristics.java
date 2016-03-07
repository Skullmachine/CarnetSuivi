package dii.vrp.test;

import dii.vrp.data.ArrayDistanceMatrix;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.data.UY734;
import dii.vrp.tp.ISolution;
import dii.vrp.tp.ITSPHeuristic;
import dii.vrp.tp.NNHeuristic;
import dii.vrp.tp.NaiveNNHeuristic;
import dii.vrp.util.EuclideanCalculator;


public class TNNHeuristics {

	/**
	 * Runs the DII router
	 * @param args [0] the file holding the arcs' information
	 * @param args [1] the file holding the nodes' information
	 */
	public static void main(String[] args){
		//Read data
		double[][] coordinates=UY734.getCoordinates();
		IDistanceMatrix distances=new ArrayDistanceMatrix(EuclideanCalculator.calc(coordinates));
		
		
		long start=System.currentTimeMillis();
		ITSPHeuristic nn=new NaiveNNHeuristic(distances);
		ISolution sol=nn.run();
		System.out.println("CPU 1 = "+(System.currentTimeMillis()-start));
		System.out.println(sol);
		
		start=System.currentTimeMillis();
		nn=new NNHeuristic(distances);
		sol=nn.run();
		System.out.println("CPU 2 = "+(System.currentTimeMillis()-start));
		System.out.println(sol);
		
	}

}
