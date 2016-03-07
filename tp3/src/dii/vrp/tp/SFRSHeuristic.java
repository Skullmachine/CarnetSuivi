package dii.vrp.tp;

import java.util.Random;

/**
 * Iplements a sequence-first, cluster-second heuristic. The heuristic generates a giant TSP visition all customers in the instance
 * and then splits the tour into feasible routes for the VRP in hand.
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 21, 2016
 *
 */
public class SFRSHeuristic implements IOptimizationAlgorithm, IRandomizedHeuristic{
	/**
	 * The split procedure
	 */
	private final ISplit s;
	/**
	 * The TSP heuristic
	 */
	private final ITSPHeuristic h;	

	public SFRSHeuristic(final ITSPHeuristic h, final ISplit s){
		this.h=h;
		this.s=s;
	}

	@Override
	public ISolution run() {
		return s.split(h.run());
	}

	@Override
	public void setRandomized(boolean flag) {
		if(h instanceof IRandomizedHeuristic)
			((IRandomizedHeuristic) h).setRandomized(flag);
	}

	@Override
	public void setRandomGen(Random rnd) {
		if(h instanceof IRandomizedHeuristic)
			((IRandomizedHeuristic) h).setRandomGen(rnd);
	}

	@Override
	public boolean isRandomized() {
		if(h instanceof IRandomizedHeuristic)
			return ((IRandomizedHeuristic) h).isRandomized();
		else
			return false;
	}

	@Override
	public void setRandomizationFactor(int K) {
		if(h instanceof IRandomizedHeuristic)
			((IRandomizedHeuristic) h).setRandomizationFactor(K);
	}

}
