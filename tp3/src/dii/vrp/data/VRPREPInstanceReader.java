package dii.vrp.data;

import java.util.Iterator;

import org.jdom2.Document;
import org.jdom2.Element;

import dii.vrp.util.EuclideanCalculator;
import dii.vrp.util.XMLParser;

/**
 * Reads VRP instances compiling with the VRP-REP instance specification
 * @author Jorge E. Mendoza (dev@jorge-mendoza.com)
 * @version %I%, %G%
 * @since Jan 22, 2016
 *
 */
public class VRPREPInstanceReader implements AutoCloseable{
	
	/**
	 * The in-memory version of the XML file
	 */
	private Document xml=null;
	/**
	 * Construcs a new VRPREPInstanceReader
	 * @param pathname
	 */
	public VRPREPInstanceReader(String pathname){
		this.xml=XMLParser.parse(pathname);	
		if(xml==null)
			throw new IllegalStateException("The arc file cannot be read");
	}
	/**
	 * Parses the XML instance file and retrieves the distance matrix
	 * @return the distance matrix
	 */
	public IDistanceMatrix getDistanceMatrix(){

		//Read the coordinates
		Element nodes=xml.getRootElement().getChild("network").getChild("nodes");

		double[][] coordinates=new double[nodes.getChildren().size()][2];
		Iterator<Element> it=nodes.getChildren().iterator();
		while(it.hasNext()){
			Element node=it.next();
			int type=Integer.valueOf(node.getAttributeValue("type"));
			int id=type==0?0:Integer.valueOf(node.getAttributeValue("id"));
			Element cx=node.getChild("cx");
			Element cy=node.getChild("cy");
			coordinates[id][0]=Double.valueOf(cx.getValue());
			coordinates[id][1]=Double.valueOf(cy.getValue());
		}
		ArrayDistanceMatrix distances=new ArrayDistanceMatrix(EuclideanCalculator.calc(coordinates));
		return distances;
	}
	/**
	 * Parses the XML instance file and retrieves the customer demands
	 * @return the demands
	 */
	public IDemands getDemands(){

		//Read the requests
		Element requests=xml.getRootElement().getChild("requests");
		double[] demands=new double[requests.getChildren().size()+1];
		Iterator<Element> it=requests.getChildren().iterator();
		//Extract the quantit and store it in the demand vector
		while(it.hasNext()){
			Element request=it.next();
			int nodeId=Integer.valueOf(request.getAttributeValue("node"));
			double quantity=Double.valueOf(request.getChild("quantity").getValue());
			demands[nodeId]=quantity;
		}
		return new ArrayDemands(demands);
	}

	/**
	 * Parses the XML instance file and retrieves the vehicle capacity
	 * @arg type the type of vehicle
	 * @return
	 */
	public double getCapacity(String type){
		//Read the requests
		Element fleet=xml.getRootElement().getChild("fleet");
		Iterator<Element> vehicles=fleet.getChildren().iterator();
		double Q=Double.NaN;
		while(vehicles.hasNext()){
			Element v=vehicles.next();
			if(v.getAttributeValue("type").equals(type)){
				Q=Double.valueOf(v.getChildText("capacity"));
				break;
			}
		}
		return Q;
	}

	@Override
	public void close() {
		this.xml=null;	
	}

}
