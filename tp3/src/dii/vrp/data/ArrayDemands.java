package dii.vrp.data;

/**
 * Implements the demands using an array as the subjacent data structure.
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 19, 2016
 *
 */
public class ArrayDemands implements IDemands {
	
	/**
	 * Stores the demands
	 */
	private final double[] demands;
	
	public ArrayDemands(int n){
		this.demands=new double[n];
	}
	
	public ArrayDemands(double[] demands){
		this.demands=demands.clone();
	}
	
	@Override
	public double getDemand(int i) {
		return this.demands[i];
	}

	@Override
	public void setDemand(int i, double demand) {
		this.demands[i]=demand;
	}

	@Override
	public void setDemands(double[] demands) {
		for(int i=0;i<demands.length;i++)
			this.demands[i]=demands[i];
	}

}
