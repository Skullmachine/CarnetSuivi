package dii.vrp.test;

import java.util.Random;

import dii.vrp.data.IDemands;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.data.VRPREPInstanceReader;
import dii.vrp.tp.ISolution;
import dii.vrp.tp.ISplit;
import dii.vrp.tp.NNHeuristic;
import dii.vrp.tp.SFRSHeuristic;
import dii.vrp.tp.Split;

/**
 * Runs a randomized sequence-first, route-second heuristic for the CVRP
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 22, 2016
 *
 */
public class TRandomizedSFRSHeuristic {

	/**
	 * Runs the experiment
	 * @param args nothing
	 */
	public static void main(String[] args){

		//Parameters
		int T=10000; //Iterations
		String file= "./data/christofides-et-al-1979-cmt/CMT01.xml"; //Instance
		
		//Read data from the instance file
		IDistanceMatrix distances=null;
		IDemands demands=null;
		double Q=Double.NaN;
		try(VRPREPInstanceReader parser=new VRPREPInstanceReader(file)){
			distances=parser.getDistanceMatrix();
			demands=parser.getDemands();
			Q=parser.getCapacity("0");
		}
		
		//Initialie the sequence-first, route-second heuristic
		NNHeuristic rnn=new NNHeuristic(distances);
		rnn.setRandomized(true);
		rnn.setRandomGen(new Random(1));
		rnn.setRandomizationFactor(3);
		ISplit split=new Split(distances, demands, Q);
		SFRSHeuristic h=new SFRSHeuristic(rnn, split);
		ISolution best=null;
		for(int t=1; t<=T;t++){
			ISolution s=h.run();
			if(best==null)
				best=s;
			if(s.getOF()<best.getOF()){
				best=s;
				//System.out.println("*** NEW BEST SOLUTION FOUND ***");
			}
		}
		
		//Run the heuristic and report the results
		System.out.println(best);
	}

}
