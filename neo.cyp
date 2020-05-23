// To clean the base
MATCH (n) DETACH DELETE n;

// Detecting the relationships
MATCH (n:Person)-[rel]->(m:Movie)
WHERE n.name = 'Keanu' AND type(rel) = 'ACTED_IN'
RETURN m.title;