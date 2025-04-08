SELECT DISTINCT 
    `name`,
    Score AS highest_score
FROM 
    players
JOIN 
    matches m ON Id = Winner
ORDER BY 
    Score DESC
LIMIT 3;