package dii.vrp.data;

import dii.vrp.tp.VRPRoute;
import dii.vrp.tp.VRPSolution;

/**
 * Hard-codes solutions for instance 01 of the CMT set
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 25, 2016
 *
 */
public class CMT01 {
	/**
	 * Retrieves the optimal solution
	 * @param evaluator
	 * @return the optimal solution to the CMT01 instance
	 */
	public static VRPSolution getOptimalSolution(CVRPRouteEvaluator evaluator){

		VRPSolution s=new VRPSolution();
		double cost=0;
		
		//Route 1
		VRPRoute r=new VRPRoute();
		r.add(0);
		r.add(46);
		r.add(5);
		r.add(49);
		r.add(10);
		r.add(39);
		r.add(33);
		r.add(45);
		r.add(15);
		r.add(44);
		r.add(37);
		r.add(12);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		//Route 2
		r=new VRPRoute();
		r.add(0);
		r.add(11);
		r.add(2);
		r.add(29);
		r.add(21);
		r.add(16);
		r.add(50);
		r.add(34);
		r.add(30);
		r.add(9);
		r.add(38);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 3
		r=new VRPRoute();
		r.add(0);
		r.add(8);
		r.add(26);
		r.add(31);
		r.add(28);
		r.add(3);
		r.add(36);
		r.add(35);
		r.add(20);
		r.add(22);
		r.add(1);
		r.add(32);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 4
		r=new VRPRoute();
		r.add(0);
		r.add(27);
		r.add(48);
		r.add(23);
		r.add(7);
		r.add(43);
		r.add(24);
		r.add(25);
		r.add(14);
		r.add(6);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 5
		r=new VRPRoute();
		r.add(0);
		r.add(18);
		r.add(13);
		r.add(41);
		r.add(40);
		r.add(19);
		r.add(42);
		r.add(17);
		r.add(4);
		r.add(47);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		s.setOF(cost);
		return s;

	}
	
	/**
	 * Retrieves a solution that is 1 relocate movement away from the optimal solution
	 * @param evaluator
	 * @return a solution that is 1 relocate movement away from the optimal solution
	 */
	public static VRPSolution getS1(CVRPRouteEvaluator evaluator){

		VRPSolution s=new VRPSolution();
		double cost=0;
		
		//Route 1
		VRPRoute r=new VRPRoute();
		r.add(0);
		r.add(5);
		r.add(46); //RELOCATING NODE 46 TO POSITION 1 LEADS TO THE OPTIMAL SOLUTION
		r.add(49);
		r.add(10);
		r.add(39);
		r.add(33);
		r.add(45);
		r.add(15);
		r.add(44);
		r.add(37);
		r.add(12);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		//Route 2
		r=new VRPRoute();
		r.add(0);
		r.add(11);
		r.add(2);
		r.add(29);
		r.add(21);
		r.add(16);
		r.add(50);
		r.add(34);
		r.add(30);
		r.add(9);
		r.add(38);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 3
		r=new VRPRoute();
		r.add(0);
		r.add(8);
		r.add(26);
		r.add(31);
		r.add(28);
		r.add(3);
		r.add(36);
		r.add(35);
		r.add(20);
		r.add(22);
		r.add(1);
		r.add(32);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 4
		r=new VRPRoute();
		r.add(0);
		r.add(27);
		r.add(48);
		r.add(23);
		r.add(7);
		r.add(43);
		r.add(24);
		r.add(25);
		r.add(14);
		r.add(6);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 5
		r=new VRPRoute();
		r.add(0);
		r.add(18);
		r.add(13);
		r.add(41);
		r.add(40);
		r.add(19);
		r.add(42);
		r.add(17);
		r.add(4);
		r.add(47);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		s.setOF(cost);
		return s;

	}
	
	/**
	 * Retrieves a solution that is two relocate moves away from the optimum
	 * @param evaluator 
	 * @return a solution that is two relocate moves away from the optimum
	 */
	public static VRPSolution getS2(CVRPRouteEvaluator evaluator){

		VRPSolution s=new VRPSolution();
		double cost=0;
		
		//Route 1
		VRPRoute r=new VRPRoute();
		r.add(0);
		r.add(5);
		r.add(46); //M1= RELOCATING NODE 46 TO POSITION 1 LEADS TO THE OPTIMAL SOLUTION
		r.add(49);
		r.add(10);
		r.add(39);
		r.add(33);
		r.add(45);
		r.add(15);
		r.add(44);
		r.add(37);
		r.add(12);
		r.add(11); //M2: M1 + RELOCATING NODE 11 TO POSITION 1 IN ROUTE 2 LEADS TO THE OPTIMAL SOLUTION
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		//Route 2
		r=new VRPRoute();
		r.add(0);
		r.add(2);
		r.add(29);
		r.add(21);
		r.add(16);
		r.add(50);
		r.add(34);
		r.add(30);
		r.add(9);
		r.add(38);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 3
		r=new VRPRoute();
		r.add(0);
		r.add(8);
		r.add(26);
		r.add(31);
		r.add(28);
		r.add(3);
		r.add(36);
		r.add(35);
		r.add(20);
		r.add(22);
		r.add(1);
		r.add(32);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 4
		r=new VRPRoute();
		r.add(0);
		r.add(27);
		r.add(48);
		r.add(23);
		r.add(7);
		r.add(43);
		r.add(24);
		r.add(25);
		r.add(14);
		r.add(6);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);

		//Route 5
		r=new VRPRoute();
		r.add(0);
		r.add(18);
		r.add(13);
		r.add(41);
		r.add(40);
		r.add(19);
		r.add(42);
		r.add(17);
		r.add(4);
		r.add(47);
		r.add(0);
		s.addRoute(evaluator.eval(r));
		cost+=s.getCost(s.size()-1);
		
		s.setOF(cost);
		return s;

	}
	
}
