// People that acted and directed the movie
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(p)
RETURN p, m

// Hoops
[:Follows*3]

// Optional Match that person is director of that movie
// + name of the actor starts with Tom
OPTIONAL MATCH

// title of the movie and distinct list of the actors
collect(DISTINCT m.title)

// only movies with five and more actors
WITH collect(p.name) as a
WHERE a>5

// Map of values based on the movie 
MATCH (m:Movie)
RETURN m {.title .rating}

// Unwind the list of movies under one actor whe the number of movies 
// higher than 5
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.name STARTS WITH 'Tom'
WITH p, collect(m) as mlist
WHERE size(mlist) < 5
WITH p, mlist UNWIND mlist as x
RETURN p.name, x.title
// Set new labels to the movies older than 2010 OlderMovie


// Remove birthPlace property from the person Robin Wright


// Create relationship between two nodes


// setting role based on the name of the actor
// role in the connection


// Create the node and on creation set property of the movie


// Delete node when the born property is not there


// Create for multiple people multiple relationship 


// Create Constant on node when the name is unique


// Create variable 


// load csv file
