package de.javamagazin.xtendOnNeo4jExample

import org.neo4j.graphdb.factory.GraphDatabaseFactory

class StartNeo4J_ {

	def static void main(String[] args) {
		val graphDb = new GraphDatabaseFactory()
			.newEmbeddedDatabaseBuilder("./neo4j")
			.newGraphDatabase();

		val tx = graphDb.beginTx

		val person = new Person(graphDb.createNode) => [
			firstName = "Horst"
			name = "Rubesch"
			age = 42
		]
		tx.success
		println('''«person.fullName» is «person.age».''');
		graphDb.shutdown
	}

}
