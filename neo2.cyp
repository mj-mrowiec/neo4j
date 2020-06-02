// People that acted and directed the movie
MATCH (p:Person)-[rel:ACCTED_IN]->(m:Movie)
RETURN p,rel,m
// Hoops
MATCH (p:Person)-[rel:FOLLOW*3]->(m:Movie)

// Optional Match that person is director of that movie
// + name of the actor starts with Tom
MATCH (p:Person)-[rel:DIRECTED]->(m:Movie)
OPTiONAL MATCH (p)-[rel:STARTS_IN]->(m)
RETURN p,rel,m
// title of the movie and distinct list of the actors
MATCH (p:Person)-[rel:ACCTED_IN]->(m:Movie)
WITH m, collect(DISTINCT p.name) as p
RETURN m.title, p

// only movies with five and more actors
MATCH (p:Person)-[rel:ACCTED_IN]->(m:Movie)
WITH m, collect(DISTINCT p.name) as p
WHERE p>5
RETURN m.title, p

// Map of values based on the movie 
MATCH (p:Person)-[rel]->(m:Movie)
RETURN m {.title, .released}

// Unwind the list of movies under one actor whe the number of movies 
// higher than 5
MATCH (p:Person)-[rel:ACCTED_IN]->(m:Movie)
WITH m, collect(DISTINCT p) as pele
WITH m, UNWiND pele as p
RETURN m.title, p.name


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



