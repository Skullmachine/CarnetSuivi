/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dii.vrp.tp;

import dii.vrp.data.IDemands;
import dii.vrp.data.IDistanceMatrix;
import java.util.HashSet;
import java.util.Set;


public class Relocate implements INeighborhood{

    private class Relocation{
        int rOut;
        int iOut;
        double deltaOFOut;
        int rIn;
        int iIn;
        double deltaOFIn;
        double demand;
        public Relocation(int rOut, int iOut, double deltaOFOut, int rIn, int iIn, double deltaOFIn, double demand){
            this.rOut=rOut;
            this.iOut=iOut;
            this.deltaOFOut=deltaOFOut;
            this.rIn=rIn;
            this.iIn=iIn;
            this.deltaOFIn=deltaOFIn;
            this.demand=demand;
        }
    }

    private final IDistanceMatrix distances;
    private final IDemands demands;
    private double Q;
    private ExplorationStrategy strategy=ExplorationStrategy.BEST_IMPROVEMENT;
    private final double epsilon=0.00001; //the tolerance
    
    public Relocate(IDistanceMatrix distances, IDemands demands, double Q) {
        this.distances = distances;
        this.demands = demands;
        this.Q=Q;
    }
    
    @Override
    public ISolution explore(ISolution s) {
        VRPSolution best=(VRPSolution)s.clone();
        Relocation bestMove=null;
        double bestDelta=0; //Best OF improvement we have found
        double delta=Double.NaN; //Last delta OF found
        int node=-1; 
        double savings;
        double cost=Double.NaN;
        double demand=Double.NaN;
        double load=Double.NaN;
        
        //Check all possible extractions
        for(int route=0;route<best.size();route++){
            for(int position=0;position<best.size(route)-1;position++){
                node=best.getNode(route, position);
                demand=demands.getDemand(node);
                savings=this.getSavings(best,route,position);
                //Check all possible insertions
                for(int r=0;r<best.size();r++){
                    load=best.getLoad(r);
                    if(load+demand<Q||route==r){
                        //Search for an insertion position
                        for(int i=0;i<best.size(r)-1;i++){
                            cost=route==r&&(i-position==1||i==position)?Double.MAX_VALUE:this.getCost(best,r,i,node);
                            delta=cost-savings;
                            if(delta<bestDelta-epsilon){
                                if(this.strategy==ExplorationStrategy.FIRST_IMPROVEMENT)
                                    return this.executeMove(new Relocation(route,position,savings,r,i,cost,demand),best);
                                else{
                                    bestMove=new Relocation(route, position, savings,r,i,cost,demand);
                                    bestDelta=delta;
                                }
                            }
                        }
                    }
                }
            }
        }
        if(bestMove==null)
            return null;
        return this.executeMove(bestMove,best);
    }    
    
    private ISolution executeMove(Relocation m, VRPSolution s){
        if(m==null)
            return null;
        
        if(m.rOut==m.rIn&&m.iOut<m.iIn)
            s.insert(s.remove(m.rOut, m.iOut), m.rIn,m.iIn-1);
        else
            s.insert(s.remove(m.rOut, m.iOut), m.rIn,m.iIn);
                  
        s.setCost(m.rOut,s.getCost(m.rOut)-m.deltaOFOut);
        s.setCost(m.rOut,s.getCost(m.rIn)+m.deltaOFIn);
        s.setOF(s.getOF()-m.deltaOFOut+m.deltaOFIn);
        
        //Update load
        if(m.rIn!=m.rOut){
            s.setLoad(m.rOut,s.getLoad(m.rOut)-m.demand);
            s.setLoad(m.rIn,s.getLoad(m.rIn)+m.demand);
        }
        
        return s;
    }
    
    private double getCost(VRPSolution s, int r, int i, int node){
        int pred=s.getNode(r, i-1);
        int succ=s.getNode(r, i+1);
        return distances.getDistance(pred, node)+distances.getDistance(node, succ)-distances.getDistance(pred, succ);
    }
    
    private double getSavings(VRPSolution s,int r, int i){
        int node=s.getNode(r, i);
        int pred=s.getNode(r, i-1);
        int succ=s.getNode(r, i+1);
       return distances.getDistance(pred, node)+distances.getDistance(node, succ)-distances.getDistance(pred, succ);
    }
    
    @Override
    public void setExplorationStrategy(ExplorationStrategy strategy) {
        
    }
    
    @Override
    public ExplorationStrategy getStrategy(){
        return null;
    }
    
    
}
