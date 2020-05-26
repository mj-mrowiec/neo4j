// cwiczenia z neo
:play 4.0-intro-neo4j-exercises

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

// Double relations relations
MATCH (a1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(a2:Person)
WHERE exists( (a2)-[:DIRECTED]->(m) )
RETURN  a1.name as Actor, a2.name as `Actor/Director`, m.title as Movie

// actors that acted in the same move as gene hackman
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person),(a2:Person)-[:ACTED_IN]->(m) 
WHERE a.name = 'Ene Hackman' 
RETURN m.title, d.name, a2.name;

// #hoops away
MATCH (p1:Person)-[:FOLLOWS*3]-(p2:Person)
WHERE p1.name = 'James Thompson'
RETURN p1, p2

// optional MATCH
MATCH (p:Person)
WHERE p.name STARTS WITH 'Tom'
OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)
RETURN p.name, m.title

// co-actor
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person)
WHERE p.name = 'Tom Cruise'
RETURN p.name, collect(p2.name), m.title

// by the count
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)
WITH  a, count(a) AS numMovies, collect(m.title) AS movies
WHERE numMovies = 5
RETURN a.name, movies

//
MATCH (m:Movie)
WITH m, size((:Person)-[:DIRECTED]->(m)) AS directors
WHERE directors >= 2
OPTIONAL MATCH (p:Person)-[:REVIEWED]->(m)
RETURN  m.title, p.name

// map
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)
WHERE a.name = 'Tom Hanks'
RETURN  m {.title, .released}

// date calculation
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)
WHERE a.name = 'Tom Hanks'
RETURN  m.title, m.released, date().year  - m.released as yearsAgoReleased, m.released  - a.born AS `age of Tom`

// Unwind
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WITH p, collect(m) AS movies
WHERE size(movies)  > 5
WITH p, movies UNWIND movies AS movie
RETURN p.name, movie.title

// SET 
MATCH (m:Movie)
WHERE m.released < 2010
SET m:OlderMovie
RETURN DISTINCT labels(m)

// Remove property
MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
SET m.lengthInMinutes = null

MATCH (p:Person)
WHERE p.name = 'Robin Wright'
REMOVE p.birthPlace

// Create relationship
MATCH (m:Movie)
WHERE m.title = 'Forrest Gump'
MATCH (p:Person)
WHERE p.name = 'Tom Hanks' OR p.name = 'Robin Wright' OR p.name = 'Gary Sinise'
CREATE (p)-[:ACTED_IN]->(m)

// Setting roles
MATCH (p:Person)-[rel:ACTED_IN]->(m:Movie)
WHERE m.title = 'Forrest Gump'
SET rel.roles =
CASE p.name
  WHEN 'Tom Hanks' THEN ['Forrest Gump']
  WHEN 'Robin Wright' THEN ['Jenny Curran']
  WHEN 'Gary Sinise' THEN ['Lieutenant Dan Taylor']
END

// Remove
MATCH (p:Person)-[rel:ACTED_IN]->(m:Movie)
WHERE m.title = 'Forrest Gump'
REMOVE rel.roles

// CREATE node
MERGE (m:Movie {title:'Forrest Gump'})
ON CREATE SET m.released = 1994
RETURN m

MERGE (m:Movie {title: 'Forrest Gump'})
ON CREATE SET m.released = 1994
ON MATCH SET m.tagline = "Life is like a box of chocolates...you never know what you're gonna get."
RETURN m

// Delete node plus relationships
MATCH (p:Person {name: 'Robert Zemeckis'})--()
WHERE NOT EXISTS (p.born)
DETACH DELETE p

// Create relationship
MATCH (p:Person), (m:Movie)
WHERE p.name = 'Robert Zemeckis' AND m.title = 'Forrest Gump'
MERGE (p)-[:DIRECTED]->(m)

// Multiple relationship
MATCH (p:Person), (m:Movie)
WHERE p.name IN ['Tom Hanks','Gary Sinise', 'Robin Wright']
      AND m.title = 'Forrest Gump'
MERGE (p)-[:ACTED_IN]->(m)

// Create Constrant
CREATE CONSTRAINT PersonNameUniqueConstraint ON (p:Person) ASSERT p.name IS UNIQUE

// Constraint on relationship
CREATE CONSTRAINT ActedInRolesExistConstraint ON ()-[r:ACTED_IN]-() ASSERT exists(r.roles)

// Create Node Key
CREATE CONSTRAINT MovieTitleReleasedConstraint ON (m:Movie) ASSERT (m.title, m.released) IS NODE KEY

// Create weight relationship
MATCH (n1)-[r1:NEXT]-(n2)
WITH count(r1) as count_rel, n
CREATE (n1)-[:WEIGHT {weight: count_rel}]->(n2)

// Create Index
CREATE INDEX PersonBornIndex FOR (p:Person) ON (p.born)

// Add param
:param year => 2000
:params {year: 20, rating:40}

// show query plan
EXPLAIN MATCH (r:Person)-[rel:REVIEWED]->(m:Movie)<-[:ACTED_IN]-(a:Person)
WHERE m.released = $year AND
      rel.rating > $ratingValue
RETURN  DISTINCT r.name, m.title, m.released, rel.rating, collect(a.name)