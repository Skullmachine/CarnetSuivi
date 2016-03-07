package dii.vrp.tp;

import dii.vrp.data.IDistanceMatrix;

/**
 * Implements a naive nearest neighbor heuristic that is in practice O(n^2).
 * Default randomizatino factor = 1.
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 17, 2016
 *
 */
public class NaiveNNHeuristic implements ITSPHeuristic{

	private IDistanceMatrix distances;
	private int initNode=0;

	
	public NaiveNNHeuristic(final IDistanceMatrix distances){
		this.distances=distances;
	}

	@Override
	public TSPSolution run() {

		//Compute nodes to route
		int toRoute=distances.size();

		//Initialize node status
		boolean[] nodeStatus=new boolean[toRoute];

		//Initialize the tour
		int init=this.initNode;
		TSPSolution tour=new TSPSolution();
		tour.add(init);
		nodeStatus[init]=true;
		toRoute--;

		//Complete the tour
		while(toRoute>0){
			//Find the nearest neighbor
			double minDist=Double.MAX_VALUE;
			int i=tour.get(tour.size()-1);
			int nn=-1;
			for(int j=0;j<nodeStatus.length;j++){
				if(distances.getDistance(i, j)<minDist&&!nodeStatus[j]&&i!=j){
					nn=j;
					minDist=distances.getDistance(i, j);
				}					
			}
			//Add the nearest not-routed neighbor to the tour
			tour.add(nn);
			nodeStatus[nn]=true;
			toRoute--;
		}
		tour.add(0);
		return tour;
	}

	@Override
	public void setInitNode(int i) {
		this.initNode=i;
	}


}
