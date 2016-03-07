package dii.vrp.test;

import dii.vrp.data.ArrayDistanceMatrix;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.data.UY734;
import dii.vrp.tp.ITSPHeuristic;
import dii.vrp.tp.NNHeuristic;
import dii.vrp.tp.NaiveNNHeuristic;
import dii.vrp.util.EuclideanCalculator;


public class TNNvsNAIVE {


	/**
	 * Compares the execution time of the {@link NaiveNNHeuristic} and {@link NNHeuristic}.
	 */
	public static void main(String[] args){
		//SetUp Experiment
		double[][] coordinates=UY734.getCoordinates();
		IDistanceMatrix distances=new ArrayDistanceMatrix(EuclideanCalculator.calc(coordinates));
		int T=100;

		for(int e=1;e<=T;e++){

			//Generate T times the naive implementation
			long start=System.currentTimeMillis();
			ITSPHeuristic nnh=new NaiveNNHeuristic(distances);

			for(int t=1;t<=e;t++){
				nnh.run();
			}
			System.out.print(e+"\t"+(System.currentTimeMillis()-start));

			//Generate 1000 random solutions using the pre-computed neighbors approach
			start=System.currentTimeMillis();
			nnh=new NNHeuristic(distances);
			for(int t=1;t<=e;t++){
				nnh.run();
			}
			System.out.println("\t"+(System.currentTimeMillis()-start));

		}

	}

}
