package dii.vrp.tp;

import java.util.Random;
import dii.vrp.data.IDistanceMatrix;
import dii.vrp.tp.NNFinder;

/**
 * Implements a nearest neighbor heuristic.</br>
 * </br>
 * --- DEFAULT BEHAVIOR ---
 * <ol>
 * 	<li>{@link #run} method: if the heuristic is running in randomized mode and the random number generator has not been defined (by calling method {@link #setRandomGen(Random)}),
 * the random number generator is initialized with an instance of {@link Random} built using the default constructor.
 * <li> The default randomization factor is K=1.
 * </ol>
 * --- ASSUMPTIONS ---
 * <ol>
 * 	<li>The {@link #run} method assumes that the default start node is node 0.
 * </ol>
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 17, 2016
 *
 */
public class NNHeuristic implements ITSPHeuristic, IRandomizedHeuristic {

	/**
	 * The nearest neighbor finder
	 */
	private final NNFinder finder;
	/**
	 * The number of nodes in the instance
	 */
	private final int n;
	/**
	 * The random number generator
	 */
	private Random rnd=null;
	/**
	 * The starting node
	 */
	private int initNode=0;
	/**
	 * The distance matrix
	 */
	private final IDistanceMatrix distances;

	/**
	 * True if the heuristic runs in randomized mode and false otherwise
	 */
	private boolean randomized=false;
	/**
	 * Randomization factor
	 */
	private int K=1;	
	/**
	 * Constructs a new nearest neighbor heuristic
	 * @param finder
	 */
	public NNHeuristic(IDistanceMatrix distances){
		this.finder=new NNFinder(distances, distances.size());
		this.n=distances.size();
		this.distances=distances;
	}

	@Override
	public TSPSolution run() {

		//Init OF
		double of=0;
		
		//Initialized random number generator (if needed)
		if(randomized&&rnd==null)
			rnd=new Random();

		//Compute nodes to route
		int toRoute=n;

		//Initialize node status
		boolean[] nodeStatus=new boolean[toRoute];

		//Initialize the tour
		TSPSolution tour;
		int init=this.initNode;
		//if(randomized)
			//init=1+rnd.nextInt(K);
		tour=new TSPSolution();
		tour.add(init);
		nodeStatus[init]=true;
		toRoute--;

		//complete the tour
		int k=1;
		while(toRoute>0){
			//Find the nearest neighbor
			int i=tour.get(tour.size()-1);
			if(randomized)
				k=1+rnd.nextInt(K);
			int nn=finder.findNN(i, nodeStatus,k);
			tour.add(nn);
			of+=distances.getDistance(tour.get(tour.size()-2),tour.get(tour.size()-1));
			nodeStatus[nn]=true;
			toRoute--;			
		}
		tour.add(0);
		of+=distances.getDistance(tour.get(tour.size()-2),tour.get(tour.size()-1));
		tour.setOF(of);
		return tour;
	}

	@Override
	public synchronized void setRandomized(boolean flag) {
		this.randomized=flag;
	}

	@Override
	public synchronized void setRandomGen(Random rnd) {
		this.rnd=rnd;
	}

	@Override
	public synchronized boolean isRandomized() {
		return this.randomized;
	}

	@Override
	public synchronized void setRandomizationFactor(int K) {
		this.K=K;
	}

	@Override
	public void setInitNode(int i) {
		this.initNode=i;		
	}

}
