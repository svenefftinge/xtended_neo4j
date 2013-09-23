package com.itemis.xtendedNeo4j

import org.eclipse.xtend.core.compiler.batch.XtendCompilerTester
import org.junit.Test

class NeoNodeTest {
	
	extension XtendCompilerTester compilerTester = XtendCompilerTester.newXtendCompilerTester(NeoNode)
	
	@Test def void testNeoNode() {
		'''
			import com.itemis.xtendedNeo4j.NeoNode
			
			@NeoNode class Person {
			  String name
			}
	    '''.assertCompilesTo(
	    '''
			import com.itemis.xtendedNeo4j.NeoNode;
			import org.neo4j.graphdb.Node;
			
			@NeoNode
			@SuppressWarnings("all")
			public class Person {
			  private Node underlyingNode;
			  
			  public Person(final Node node) {
			    this.underlyingNode = node;
			  }
			  
			  public Node getUnderlyingNode() {
			    return this.underlyingNode;
			  }
			  
			  public String getName() {
			    return (String)underlyingNode.getProperty("name");
			  }
			  
			  public void setName(final String name) {
			    underlyingNode.setProperty("name", name);
			  }
			  
			  public int hashCode() {
			    return this.underlyingNode.hashCode();
			  }
			  
			  public boolean equals(final Object o) {
			    return o instanceof Person && 
			        underlyingNode.equals( ( (Person)o ).getUnderlyingNode() );
			  }
			  
			  public String toString() {
			    return "Person[name:"+getName()+"]";
			  }
			}
		''')
	}
}