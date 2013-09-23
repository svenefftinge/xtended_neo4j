package de.javamagazin.xtendOnNeo4jExample

import com.itemis.xtendedNeo4j.NeoNode

@NeoNode class Person {
	String firstName
	String name
	Integer age
	
	/**
	 * @return the full name
	 */
	def getFullName() {
		firstName+' '+name
	}
}