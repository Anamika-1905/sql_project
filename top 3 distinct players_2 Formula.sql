SELECT DISTINCT p.name, p.score
FROM players p
JOIN matches m ON p.name = m.Winner
ORDER BY p.score DESC
LIMIT 3;