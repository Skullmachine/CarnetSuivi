package dii.vrp.test;

import dii.vrp.data.ArrayDistanceMatrix;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.data.UY734;
import dii.vrp.tp.ISolution;
import dii.vrp.tp.ITSPHeuristic;
import dii.vrp.tp.NaiveNNHeuristic;
import dii.vrp.util.EuclideanCalculator;

/**
 * Tests the NaiveNNHeuristic
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public class TNaiveNNHeuristic {
	/**
	 * Runs the test
	 * @param args none
	 */
	public static void main(String args[]){
		//Set up the instance data
		double[][] coordinates=UY734.getCoordinates();
		IDistanceMatrix distances=new ArrayDistanceMatrix(EuclideanCalculator.calc(coordinates));

		//Set up the heuristic
		ITSPHeuristic nnh=new NaiveNNHeuristic(distances);
			
		//Run the heuristic
		ISolution s=nnh.run();
		long start=System.currentTimeMillis();
		
		System.out.println("*** CPU ***");
		System.out.println(System.currentTimeMillis()-start);
		System.out.println("*** SOLUTION ***");
		System.out.println(s);
		
	}

}
