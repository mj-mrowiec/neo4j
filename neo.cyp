// To clean the base
MATCH (n) DETACH DELETE n;

// Detecting the relationships
MATCH (n:Person)-[rel]->(m:Movie)
WHERE n.name = 'Keanu' AND type(rel) = 'ACTED_IN'
RETURN m.title;

// name starts with
MATCH (a:Person)-[:ACTED_IN]->(:Movie)
WHERE a.name STARTS WITH 'James'
RETURN a.name

// exists
MATCH (a:Person)-[:ACTED_IN]->(:Movie)
WHERE exists(a.birn)
RETURN a.name

// contains
MATCH (:Person)-[r:REVIEWED]->(m:Movie)
WHERE toLower(r.summary) CONTAINS 'fun'
RETURN  m.title as Movie, r.summary as Review, r.rating as Rating

// one type of rel over the other one
MATCH (a:Person)-[:PRODUCED]->(m:Movie)
WHERE NOT ((a)-[:DIRECTED]->(:Movie))
RETURN a.name, m.title