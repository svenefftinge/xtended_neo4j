package de.javamagazin.xtendOnNeo4jExample;

import org.neo4j.graphdb.GraphDatabaseService;
import org.neo4j.graphdb.Transaction;
import org.neo4j.graphdb.factory.GraphDatabaseFactory;

public class StartNeo4J {

	public static void main(String[] args) {
		final GraphDatabaseService graphDb = new GraphDatabaseFactory()
		    .newEmbeddedDatabaseBuilder( "./neo4j" )
		    .newGraphDatabase();
	    
	    Transaction tx = graphDb.beginTx();
	    
	    Person person = new Person(graphDb.createNode());
	    person.setFirstName("Horst");
	    person.setName("Rubesch");
	    person.setAge(42);
        tx.success();
        
        System.out.println(person.getFullName()+" is " + person.getAge());
        
        graphDb.shutdown();
	}
}


