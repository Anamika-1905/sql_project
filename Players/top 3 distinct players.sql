SELECT DISTINCT p.name, p.score
FROM 
    (SELECT name, score FROM players WHERE name IN (
        SELECT Winner FROM matches
    )) AS p
ORDER BY p.score DESC
LIMIT 3;