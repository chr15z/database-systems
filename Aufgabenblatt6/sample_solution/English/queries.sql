--- Query 1 -- Number of big greenhouses per estate (i.e. size > 30m^2)
CREATE OR REPLACE VIEW NumberOfBigGreenhouses AS
	SELECT Address, count(*)
	FROM Greenhouse
	WHERE Size > 30
	GROUP BY Address;

--- Query 2 -- Transitive closure of neighbouring estates
CREATE OR REPLACE VIEW AllBlockNeighbours AS
WITH RECURSIVE tmp(Estate_Address, Neighbour_Address) as ( 
       SELECT Estate_Address, Neighbour_Address 
	   FROM neighbouring
       UNION
       SELECT tmp.Estate_Address, g.Neighbour_Address 
	   FROM neighbouring g, tmp 
	   WHERE tmp.Neighbour_Address = g.Estate_Address
       ) SELECT * FROM tmp;
SELECT * FROM AllBlockNeighbours;


--- Query 3 -- Number of neighbours between A and B + total size of estates between A and B
CREATE OR REPLACE VIEW NeighbourhoodSize AS
WITH RECURSIVE tmp(Estate_Address, Neighbour_Address, Schritte, GesamtSize) as ( 
       SELECT Estate_Address, Neighbour_Address, 1, gr1.Size + gr2.Size 
	   FROM neighbouring ga, Estate gr1, Estate gr2
	   WHERE ga.Estate_Address = gr1.Address AND ga.Neighbour_Address = gr2.Address
       UNION
       SELECT tmp.Estate_Address, ga.Neighbour_Address, tmp.Schritte + 1, (tmp.GesamtSize + gr.Size)::NUMERIC(10, 2)
	   FROM neighbouring ga, tmp, Estate gr 
	   WHERE tmp.Neighbour_Address = ga.Estate_Address AND ga.Neighbour_Address = gr.Address
       ) SELECT * FROM tmp;
SELECT * FROM NeighbourhoodSize;
