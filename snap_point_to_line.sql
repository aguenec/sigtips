SELECT DISTINCT ON (pt_id)
    pt_id,
    ln_id, 
    ST_line_interpolate_point(
            ln_geom, 
            ST_line_locate_point(ln_geom, pt_geom)
        ) as geom
     
FROM
(
    SELECT 
        ln.geom AS ln_geom,
        pt.geom AS pt_geom, 
        ln.cleabs AS ln_id, 
        pt.pt_collecte_id AS pt_id, 
        ST_Distance(ln.geom, pt.geom) AS d
    FROM 
        qc_collecte.point_collecte pt, 
        ref_bd_topo_qc.troncon_de_route ln 
    WHERE 
        ST_DWithin(pt.geom, ln.geom, 50.0) 
    ORDER BY pt_id, d
) AS subquery;
