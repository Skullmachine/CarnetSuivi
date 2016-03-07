package dii.vrp.tp;

import java.util.List;

public interface IVRPSolution extends ISolution{
	
	public void addRoute(IRoute r);
	
	public void setRoute(IRoute r, int i);
	
	public List<IRoute> getRoutes();
	
	
	
}
