package dii.vrp.data;



/**
 * Implements a distance matrix using an 2-dimensional array as underlying data structure. The implementation
 * assumes that nodes are numbered from 0 to n-1. When setting or getting a distance between <code>i</code> and <code>j</code>
 * the implementation sets/gets the distance in position <code>[i][j]</code> of the array. 
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Dec 4, 2015
 *
 */
public class ArrayDistanceMatrix implements IDistanceMatrix{
	/**
	 * Holds the distance matrix
	 */
	private final double[][] distances;
	/**
	 * Constructs a new distance matrix
	 * @param n the number of nodes (including the depot)
	 */
	public ArrayDistanceMatrix(int n){
		this.distances=new double[n][n];
	}
	/**
	 * Constructs a new distance matrix
	 * @param distances the distance matrix to wrap up
	 */
	public ArrayDistanceMatrix(double[][] distances) {
		if(distances.length!=distances[0].length)
			throw new IllegalArgumentException("argument distances must be a nxn (passed matrix has "+distances.length+"x"+distances[0].length+")");
		this.distances=distances;
	}
	
	@Override
	public double getDistance(int i, int j) {
		return this.distances[i][j];
	}

	@Override
	public void setDistance(int i, int j, double distance) {
		this.distances[i][j]=distance;
	}

	/**
	 * @return a hard copy of the two-dimensional array holding the distance matrix
	 */
	public double[][] getDistanceMatrixCopy(){
		return this.distances.clone();
	}
	
	@Override
	public String toString(){
		StringBuilder sb=new StringBuilder();
		for(int i=0;i<distances.length;i++){
			for(int j=0;j<distances[0].length;j++)
				sb.append(distances[i][j]+"\t");
			sb.append("\n");
		}
		return sb.toString();
	}
	@Override
	public int size() {
		return distances.length;
	}

}
