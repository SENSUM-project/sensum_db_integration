------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------
-- Name: SENSUM multi-resolution database support for Remote Rapid Visual Screening (RRVS) - FLOOD indicators extension
-- Version: 0.2
-- Date: 26.11.14
-- Author: M. Wieland
-- DBMS: PostgreSQL9.2 / PostGIS2.0
-- SENSUM data model: tested on version 0.9
-- SENSUM RRVS support: tested on version 0.3.2
-- Description: Extends the RRVS SENSUM data model with FLOOD related indicators
--		1. Fills the taxonomy tables with attribute types and values, and according qualifier types and values
-- 		   Implemented attributes: FLOOD
-- 		   Implemented resolutions: Resolution 1 (per-building)
--		2. Adjusts the editable view for resolution 1 from the RRVS SENSUM data model to the FLOOD specifications
--		   Attributes in use: GEM Taxonomy, EMCA building types, Vulnerability
--		   Qualifiers in use: Belief, Validtime, Source
--		3. Adjusts the views for data and metadata exchange to the FLOOD specifications
------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------
---------- FILL TAXONOMY TABLES --------------
----------------------------------------------
--Load taxonomy values to taxonomy tables
INSERT INTO taxonomy.dic_taxonomy( gid, code, description, extended_description, version_date ) VALUES ( 5, 'FLOOD', 'Flood indicators', null, '2014-02-25' ); 

--Load FLOOD Taxonomy attribute types to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 28, 'BACC', 'Building access general', null, 'FLOOD', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 29, 'BACC_GF', 'Building access ground floor', null, 'FLOOD', 2, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 30, 'BACC_BK', 'Building access backyard', null, 'FLOOD', 3, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 31, 'BACC_BSL', 'Building access below street level', null, 'FLOOD', 4, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 32, 'WNDWS', 'Window type', null, 'FLOOD', 1, null ); 
INSERT INTO taxonomy.dic_attribute_type( gid, code, description, extended_description, taxonomy_code, attribute_level, attribute_order ) VALUES ( 33, 'CONST_QUAL', 'Construction quality', null, 'FLOOD', 1, null ); 

--Load FLOOD Taxonomy attribute type values to the taxonomy tables
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 386, 'BACC', 'SD', 'SD - single door', null ); 
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 387, 'BACC', 'DD', 'DD - double door', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 388, 'BACC', 'RD', 'RD - revolving door', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 389, 'BACC', 'AD', 'AD - automatic door', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 390, 'BACC', 'BA99', 'BA99 - access unknown', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 391, 'BACC_GF', 'HP', 'HP - hochparterre, accessible by steps', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 392, 'BACC_GF', 'STL', 'STL - street level', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 393, 'BACC_GF', 'BACC_GF99', 'GF99 - ground floor access unknown', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 394, 'BACC_BK', 'OD', 'OD - open doorway', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 395, 'BACC_BK', 'OC', 'OC - open car entrance', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 396, 'BACC_BK', 'CC', 'CC - closed car entrance', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 397, 'BACC_BK', 'BACC_BK99', 'BK99 - backyard access unknown', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 398, 'BACC_BSL', 'BW', 'BW - basement window', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 399, 'BACC_BSL', 'SW', 'SW - windows (souterrain)', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 400, 'BACC_BSL', 'CD', 'CD - cellar door', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 401, 'BACC_BSL', 'SDE', 'SDE - stair descent and entrance', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 402, 'BACC_BSL', 'BACC_BSL99', 'BSL99 - access below street level unknown', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 403, 'WNDWS', 'DW', 'DW - double windows', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 404, 'WNDWS', 'IG', 'IG - insulating glazing', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 405, 'WNDWS', 'MF', 'MF - light metal frame', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 406, 'WNDWS', 'WL', 'WL - wooden lattice windows', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 407, 'WNDWS', 'SP', 'SP - simple window pane', null );
INSERT INTO taxonomy.dic_attribute_value( gid, attribute_type_code, attribute_value, description, extended_description ) VALUES ( 408, 'WNDWS', 'WN99', 'WN99 - unknown windows type', null );

--Load hazard types to the taxonomy tables
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 28, 'FL', 'FL - Flood', null, 'BACC' );
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 29, 'FL', 'FL - Flood', null, 'BACC_GF' );
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 30, 'FL', 'FL - Flood', null, 'BACC_BK' );
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 31, 'FL', 'FL - Flood', null, 'BACC_BSL' );
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 32, 'FL', 'FL - Flood', null, 'WNDWS' );
INSERT INTO taxonomy.dic_hazard( gid, code, description, extended_description, attribute_type_code ) VALUES ( 33, 'FL', 'FL - Flood', null, 'CONST_QUAL' );


----------------------------------------------------------------
---------- ADJUST EDITABLE VIEWS FOR RESOLUTION 1 --------------
----------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS tablefunc;

--------------------------------------
-- resolution 1 view (per-building) --
--------------------------------------
DROP VIEW IF EXISTS object_res1.ve_resolution1;
CREATE OR REPLACE VIEW object_res1.ve_resolution1 AS
  SELECT
   a.*,
   b.*,
   f.vuln_1,
   f.vuln_2,
   c.height_1,
   c.height_2,
   d.*,
   e.yr_built_vt,
   e.yr_built_vt1,
   g.*
  FROM object_res1.main 
AS a
JOIN
  --get attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, attribute_value FROM object_res1.main_detail order by object_id', 'select code from taxonomy.dic_attribute_type order by gid') 
	AS ct(object_id integer, 
	      mat_type varchar, 
	      mat_tech varchar,
	      mat_prop varchar,
	      llrs varchar,
	      llrs_duct varchar,
	      height varchar,
	      yr_built varchar,
	      occupy varchar,
	      occupy_dt varchar,
	      "position" varchar,
	      plan_shape varchar,
	      str_irreg varchar,
	      str_irreg_dt varchar,
	      str_irreg_type varchar,
	      nonstrcexw varchar,
	      roof_shape varchar,
	      roofcovmat varchar,
	      roofsysmat varchar,
	      roofsystyp varchar,
	      roof_conn varchar,
	      floor_mat varchar,
	      floor_type varchar,
	      floor_conn varchar,
	      foundn_sys varchar,
	      build_type varchar,
	      build_subtype varchar,
	      vuln varchar,
	      bacc varchar,
	      bacc_gf varchar,
	      bacc_bk varchar,
	      bacc_bsl varchar,
	      wndws varchar,
	      const_qual varchar))
AS b ON (a.gid = b.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get height values
  (SELECT object_id, attribute_numeric_1 as height_1, attribute_numeric_2 as height_2 FROM object_res1.main_detail WHERE attribute_type_code = 'HEIGHT') 
AS c ON (a.gid = c.object_id)
JOIN
  --get belief values for the attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, qualifier_numeric_1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN (SELECT * FROM object_res1.main_detail_qualifier WHERE qualifier_type_code=''BELIEF'') as b
				ON (a.gid = b.detail_id)) sub ORDER BY object_id', 
	'SELECT code from taxonomy.dic_attribute_type order by gid') 
	AS a (object_id1 integer, 
	      mat_type_bp integer, 
	      mat_tech_bp integer,
	      mat_prop_bp integer,
	      llrs_bp integer,
	      llrs_duct_bp integer,
	      height_bp integer,
	      yr_built_bp integer,
	      occupy_bp integer,
	      occupy_dt_bp integer,
	      position_bp integer,
	      plan_shape_bp integer,
	      str_irreg_bp integer,
	      str_irreg_dt_bp integer,
	      str_irreg_type_bp integer,
	      nonstrcexw_bp integer,
	      roof_shape_bp integer,
	      roofcovmat_bp integer,
	      roofsysmat_bp integer,
	      roofsystyp_bp integer,
	      roof_conn_bp integer,
	      floor_mat_bp integer,
	      floor_type_bp integer,
	      floor_conn_bp integer,
	      foundn_sys_bp integer,
	      build_type_bp integer,
	      build_subtype_bp integer,
	      vuln_bp integer,
	      bacc_bp integer,
	      bacc_gf_bp integer,
	      bacc_bk_bp integer,
	      bacc_bsl_bp integer,
	      wndws_bp integer,
	      const_qual_bp integer))
AS d ON (a.gid = d.object_id1)
LEFT OUTER JOIN --do a left outer join because of the where statement in the select crosstab()
  --get valid time values (yr_built_1, yr_built_2)
  (SELECT object_id, qualifier_value as yr_built_vt, qualifier_timestamp_1 as yr_built_vt1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN object_res1.main_detail_qualifier as b
				ON (a.gid = b.detail_id)) sub WHERE attribute_type_code = 'YR_BUILT' AND qualifier_type_code = 'VALIDTIME' ORDER BY object_id)  
AS e ON (a.gid = e.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get vulnerability values
  (SELECT object_id, attribute_numeric_1 as vuln_1, attribute_numeric_2 as vuln_2 FROM object_res1.main_detail WHERE attribute_type_code = 'VULN') 
AS f ON (a.gid = f.object_id)
JOIN
  --get source values for the attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, qualifier_value FROM (SELECT * FROM object_res1.main_detail as a
				JOIN (SELECT * FROM object_res1.main_detail_qualifier WHERE qualifier_type_code=''SOURCE'') as b
				ON (a.gid = b.detail_id)) sub ORDER BY object_id', 
	'SELECT code from taxonomy.dic_attribute_type order by gid') 
	AS ct (object_id2 integer,
	      mat_type_src varchar, 
	      mat_tech_src varchar,
	      mat_prop_src varchar,
	      llrs_src varchar,
	      llrs_duct_src varchar,
	      height_src varchar,
	      yr_built_src varchar,
	      occupy_src varchar,
	      occupy_dt_src varchar,
	      position_src varchar,
	      plan_shape_src varchar,
	      str_irreg_src varchar,
	      str_irreg_dt_src varchar,
	      str_irreg_type_src varchar,
	      nonstrcexw_src varchar,
	      roof_shape_src varchar,
	      roofcovmat_src varchar,
	      roofsysmat_src varchar,
	      roofsystyp_src varchar,
	      roof_conn_src varchar,
	      floor_mat_src varchar,
	      floor_type_src varchar,
	      floor_conn_src varchar,
	      foundn_sys_src varchar,
	      build_type_src varchar,
	      build_subtype_src varchar,
	      vuln_src varchar,
	      bacc_src varchar,
	      bacc_gf_src varchar,
	      bacc_bk_src varchar,
	      bacc_bsl_src varchar,
	      wndws_src varchar,
	      const_qual_src varchar))
AS g ON (a.gid = g.object_id2)
ORDER BY gid ASC;

--set default attribute values
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_TYPE SET DEFAULT 'MAT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_TECH SET DEFAULT 'MATT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN MAT_PROP SET DEFAULT 'MATP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN LLRS SET DEFAULT 'L99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN LLRS_DUCT SET DEFAULT 'DU99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN HEIGHT SET DEFAULT 'H99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN YR_BUILT SET DEFAULT 'Y99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN OCCUPY SET DEFAULT 'OC99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN OCCUPY_DT SET DEFAULT 'OCCDT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN POSITION SET DEFAULT 'BP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN PLAN_SHAPE SET DEFAULT 'PLF99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG SET DEFAULT 'IR99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG_DT SET DEFAULT 'IRP99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN STR_IRREG_TYPE SET DEFAULT 'IRT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN NONSTRCEXW SET DEFAULT 'EW99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOF_SHAPE SET DEFAULT 'R99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFCOVMAT SET DEFAULT 'RMT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFSYSMAT SET DEFAULT 'RSM99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOFSYSTYP SET DEFAULT 'RST99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN ROOF_CONN SET DEFAULT 'RCN99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_MAT SET DEFAULT 'F99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_TYPE SET DEFAULT 'FT99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FLOOR_CONN SET DEFAULT 'FWC99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN FOUNDN_SYS SET DEFAULT 'FOS99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN BACC SET DEFAULT 'BA99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN BACC_GF SET DEFAULT 'BACC_GF99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN BACC_BK SET DEFAULT 'BACC_BK99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN BACC_BSL SET DEFAULT 'BACC_BSL99'::character varying;
ALTER VIEW object_res1.ve_resolution1 ALTER COLUMN WNDWS SET DEFAULT 'WN99'::character varying;

------------------------------------
-- make resolution1 view editable --
------------------------------------
CREATE OR REPLACE FUNCTION object_res1.edit_resolution_view()
RETURNS TRIGGER AS 
$BODY$
BEGIN
      IF TG_OP = 'INSERT' THEN
       INSERT INTO object_res1.main (gid, survey_gid, source, accuracy, description, res2_id, res3_id, the_geom) VALUES (DEFAULT, NEW.survey_gid, NEW.source, NEW.accuracy, NEW.description, NEW.res2_id, NEW.res3_id, NEW.the_geom);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_TYPE', NEW.mat_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_TECH', NEW.mat_tech);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'MAT_PROP', NEW.mat_prop);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'LLRS', NEW.llrs);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'LLRS_DUCT', NEW.llrs_duct);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM object_res1.main), 'HEIGHT', NEW.height, NEW.height_1, NEW.height_2);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'YR_BUILT', NEW.yr_built);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'OCCUPY', NEW.occupy);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'OCCUPY_DT', NEW.occupy_dt);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'POSITION', NEW."position");
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'PLAN_SHAPE', NEW.plan_shape);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG', NEW.str_irreg);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG_DT', NEW.str_irreg_dt);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'STR_IRREG_TYPE', NEW.str_irreg_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'NONSTRCEXW', NEW.nonstrcexw);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOF_SHAPE', NEW.roof_shape);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFCOVMAT', NEW.roofcovmat);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFSYSMAT', NEW.roofsysmat);	 
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOFSYSTYP', NEW.roofsystyp);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'ROOF_CONN', NEW.roof_conn);    
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_MAT', NEW.floor_mat);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_TYPE', NEW.floor_type);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FLOOR_CONN', NEW.floor_conn);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'FOUNDN_SYS', NEW.foundn_sys);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BUILD_TYPE', NEW.build_type);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BUILD_SUBTYPE', NEW.build_subtype);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value, attribute_numeric_1, attribute_numeric_2) VALUES ((SELECT max(gid) FROM object_res1.main), 'VULN', NEW.vuln, NEW.vuln_1, NEW.vuln_2);       
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BACC', NEW.bacc); 
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BACC_GF', NEW.bacc_gf);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BACC_BK', NEW.bacc_bk);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'BACC_BSL', NEW.bacc_bsl);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'WNDWS', NEW.wndws);
       INSERT INTO object_res1.main_detail (object_id, attribute_type_code, attribute_value) VALUES ((SELECT max(gid) FROM object_res1.main), 'CONST_QUAL', NEW.const_qual); 
 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TYPE'), 'BELIEF', 'BP', NEW.mat_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TECH'), 'BELIEF', 'BP', NEW.mat_tech_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_PROP'), 'BELIEF', 'BP', NEW.mat_prop_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS'), 'BELIEF', 'BP', NEW.llrs_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS_DUCT'), 'BELIEF', 'BP', NEW.llrs_duct_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='HEIGHT'), 'BELIEF', 'BP', NEW.height_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'BELIEF', 'BP', NEW.yr_built_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY'), 'BELIEF', 'BP', NEW.occupy_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY_DT'), 'BELIEF', 'BP', NEW.occupy_dt_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='POSITION'), 'BELIEF', 'BP', NEW.position_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='PLAN_SHAPE'), 'BELIEF', 'BP', NEW.plan_shape_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG'), 'BELIEF', 'BP', NEW.str_irreg_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_DT'), 'BELIEF', 'BP', NEW.str_irreg_dt_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_TYPE'), 'BELIEF', 'BP', NEW.str_irreg_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='NONSTRCEXW'), 'BELIEF', 'BP', NEW.nonstrcexw_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_SHAPE'), 'BELIEF', 'BP', NEW.roof_shape_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFCOVMAT'), 'BELIEF', 'BP', NEW.roofcovmat_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSMAT'), 'BELIEF', 'BP', NEW.roofsysmat_bp);	 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSTYP'), 'BELIEF', 'BP', NEW.roofsystyp_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_CONN'), 'BELIEF', 'BP', NEW.roof_conn_bp);    
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_MAT'), 'BELIEF', 'BP', NEW.floor_mat_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_TYPE'), 'BELIEF', 'BP', NEW.floor_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_CONN'), 'BELIEF', 'BP', NEW.floor_conn_bp);       
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FOUNDN_SYS'), 'BELIEF', 'BP', NEW.foundn_sys_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_TYPE'), 'BELIEF', 'BP', NEW.build_type_bp);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_SUBTYPE'), 'BELIEF', 'BP', NEW.build_subtype_bp);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='VULN'), 'BELIEF', 'BP', NEW.vuln_bp);      
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_timestamp_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'VALIDTIME', NEW.yr_built_vt, NEW.yr_built_vt1);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC'), 'BELIEF', 'BP', NEW.bacc_bp);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_GF'), 'BELIEF', 'BP', NEW.bacc_gf_bp); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_BK'), 'BELIEF', 'BP', NEW.bacc_bk_bp); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_BSL'), 'BELIEF', 'BP', NEW.bacc_bsl_bp); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='WNDWS'), 'BELIEF', 'BP', NEW.wndws_bp); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value, qualifier_numeric_1) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='CONST_QUAL'), 'BELIEF', 'BP', NEW.const_qual_bp); 
   
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TYPE'), 'SOURCE', NEW.mat_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_TECH'), 'SOURCE', NEW.mat_tech_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='MAT_PROP'), 'SOURCE', NEW.mat_prop_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS'), 'SOURCE', NEW.llrs_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='LLRS_DUCT'), 'SOURCE', NEW.llrs_duct_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='HEIGHT'), 'SOURCE', NEW.height_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='YR_BUILT'), 'SOURCE', NEW.yr_built_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY'), 'SOURCE', NEW.occupy_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='OCCUPY_DT'), 'SOURCE', NEW.occupy_dt_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='POSITION'), 'SOURCE', NEW.position_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='PLAN_SHAPE'), 'SOURCE', NEW.plan_shape_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG'), 'SOURCE', NEW.str_irreg_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_DT'), 'SOURCE', NEW.str_irreg_dt_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='STR_IRREG_TYPE'), 'SOURCE', NEW.str_irreg_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='NONSTRCEXW'), 'SOURCE', NEW.nonstrcexw_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_SHAPE'), 'SOURCE', NEW.roof_shape_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFCOVMAT'), 'SOURCE', NEW.roofcovmat_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSMAT'), 'SOURCE', NEW.roofsysmat_src);	 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOFSYSTYP'), 'SOURCE', NEW.roofsystyp_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='ROOF_CONN'), 'SOURCE', NEW.roof_conn_src);    
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_MAT'), 'SOURCE', NEW.floor_mat_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_TYPE'), 'SOURCE', NEW.floor_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FLOOR_CONN'), 'SOURCE', NEW.floor_conn_src);       
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='FOUNDN_SYS'), 'SOURCE', NEW.foundn_sys_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_TYPE'), 'SOURCE', NEW.build_type_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BUILD_SUBTYPE'), 'SOURCE', NEW.build_subtype_src);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='VULN'), 'SOURCE', NEW.vuln_src);
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC'), 'SOURCE', NEW.bacc_src);  
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_GF'), 'SOURCE', NEW.bacc_gf_src); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_BK'), 'SOURCE', NEW.bacc_bk_src); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='BACC_BSL'), 'SOURCE', NEW.bacc_bsl_src); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='WNDWS'), 'SOURCE', NEW.wndws_src); 
       INSERT INTO object_res1.main_detail_qualifier (detail_id, qualifier_type_code, qualifier_value) VALUES ((SELECT max(gid) FROM object_res1.main_detail WHERE attribute_type_code='CONST_QUAL'), 'SOURCE', NEW.const_qual_src); 
   
       RETURN NEW;

      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE object_res1.main SET survey_gid=NEW.survey_gid, source=NEW.source, accuracy=NEW.accuracy, description=NEW.description, res2_id=NEW.res2_id, res3_id=NEW.res3_id, the_geom=NEW.the_geom 
        WHERE gid=OLD.gid;
       --TODO: UPDATE ONLY IF DETAIL IS AVAILABLE, ELSE INSERT THE DETAIL
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_type WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_tech WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH';
       UPDATE object_res1.main_detail SET attribute_value=NEW.mat_prop WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP';
       UPDATE object_res1.main_detail SET attribute_value=NEW.llrs WHERE object_id=OLD.gid AND attribute_type_code='LLRS';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.llrs_duct WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.height WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.yr_built WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.occupy WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY';
       UPDATE object_res1.main_detail SET attribute_value=NEW.occupy_dt WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT';
       UPDATE object_res1.main_detail SET attribute_value=NEW."position" WHERE object_id=OLD.gid AND attribute_type_code='POSITION';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.plan_shape WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg_dt WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.str_irreg_type WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.nonstrcexw WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roof_shape WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE';	
       UPDATE object_res1.main_detail SET attribute_value=NEW.roofcovmat WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roofsystyp WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP';
       UPDATE object_res1.main_detail SET attribute_value=NEW.roof_conn WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_mat WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_type WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.floor_conn WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN';
       UPDATE object_res1.main_detail SET attribute_value=NEW.foundn_sys WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS';
       UPDATE object_res1.main_detail SET attribute_value=NEW.build_type WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.build_subtype WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE';
       UPDATE object_res1.main_detail SET attribute_value=NEW.vuln WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_1=NEW.vuln_1 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_2=NEW.vuln_2 WHERE object_id=OLD.gid AND attribute_type_code='VULN';
       UPDATE object_res1.main_detail SET attribute_numeric_1=NEW.height_1 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE object_res1.main_detail SET attribute_numeric_2=NEW.height_2 WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT';
       UPDATE object_res1.main_detail SET attribute_value=NEW.bacc WHERE object_id=OLD.gid AND attribute_type_code='BACC';
       UPDATE object_res1.main_detail SET attribute_value=NEW.bacc_gf WHERE object_id=OLD.gid AND attribute_type_code='BACC_GF';
       UPDATE object_res1.main_detail SET attribute_value=NEW.bacc_bk WHERE object_id=OLD.gid AND attribute_type_code='BACC_BK';
       UPDATE object_res1.main_detail SET attribute_value=NEW.bacc_bsl WHERE object_id=OLD.gid AND attribute_type_code='BACC_BSL';
       UPDATE object_res1.main_detail SET attribute_value=NEW.wndws WHERE object_id=OLD.gid AND attribute_type_code='WNDWS';
       UPDATE object_res1.main_detail SET attribute_value=NEW.const_qual WHERE object_id=OLD.gid AND attribute_type_code='CONST_QUAL';

       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_tech_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.mat_prop_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.llrs_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.llrs_duct_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.height_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.yr_built_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.occupy_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.occupy_dt_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.position_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.plan_shape_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_dt_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.str_irreg_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.nonstrcexw_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roof_shape_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofcovmat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofsysmat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roofsystyp_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.roof_conn_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_mat_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.floor_conn_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.foundn_sys_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.build_type_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.build_subtype_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.vuln_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.yr_built_vt WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME';
       UPDATE object_res1.main_detail_qualifier SET qualifier_timestamp_1=NEW.yr_built_vt1 WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='VALIDTIME'; 
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.bacc_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.bacc_gf_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_GF') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.bacc_bk_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_BK') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.bacc_bsl_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_BSL') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.wndws_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='WNDWS') AND qualifier_type_code='BELIEF';
       UPDATE object_res1.main_detail_qualifier SET qualifier_numeric_1=NEW.const_qual_bp WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='CONST_QUAL') AND qualifier_type_code='BELIEF';

       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_tech_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_TECH') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.mat_prop_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='MAT_PROP') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.llrs_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.llrs_duct_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='LLRS_DUCT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.height_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='HEIGHT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.yr_built_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='YR_BUILT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.occupy_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.occupy_dt_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='OCCUPY_DT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.position_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='POSITION') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.plan_shape_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='PLAN_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_dt_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_DT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.str_irreg_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='STR_IRREG_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.nonstrcexw_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='NONSTRCEXW') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roof_shape_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_SHAPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofcovmat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFCOVMAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofsysmat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSMAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roofsystyp_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOFSYSTYP') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.roof_conn_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='ROOF_CONN') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_mat_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_MAT') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.floor_conn_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FLOOR_CONN') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.foundn_sys_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='FOUNDN_SYS') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.build_type_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_TYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.build_subtype_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BUILD_SUBTYPE') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.vuln_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='VULN') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.bacc_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.bacc_gf_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_GF') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.bacc_bk_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_BK') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.bacc_bsl_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='BACC_BSL') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.wndws_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='WNDWS') AND qualifier_type_code='SOURCE';
       UPDATE object_res1.main_detail_qualifier SET qualifier_value=NEW.const_qual_src WHERE detail_id=(SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid AND attribute_type_code='CONST_QUAL') AND qualifier_type_code='SOURCE';

       RETURN NEW;

      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM object_res1.main_detail_qualifier WHERE detail_id IN (SELECT gid FROM object_res1.main_detail WHERE object_id=OLD.gid);
       DELETE FROM object_res1.main_detail WHERE object_id=OLD.gid;
       DELETE FROM object_res1.main WHERE gid=OLD.gid;
       --workaround to include row information after delete (because it is not possible to define a AFTER FOR EACH ROW trigger on a view)
       IF EXISTS (SELECT event_object_schema, trigger_name FROM information_schema.triggers WHERE event_object_schema = 'object_res1' AND trigger_name = 'zhistory_trigger_row') THEN
	       INSERT INTO history.logged_actions VALUES(
	        NEXTVAL('history.logged_actions_gid_seq'),    -- gid
		TG_TABLE_SCHEMA::text,                        -- schema_name
		TG_TABLE_NAME::text,                          -- table_name
		TG_RELID,                                     -- relation OID for much quicker searches
		txid_current(),                               -- transaction_id
		session_user::text,                           -- transaction_user
		current_timestamp,                            -- transaction_time
		NULL,                              	      -- top-level query or queries (if multistatement) from client
		'D',					      -- transaction_type
		hstore(OLD.*), NULL, NULL);                   -- old_record, new_record, changed_fields
	END IF;
       RETURN NULL;
      END IF;
      RETURN NEW;
END;
$BODY$ 
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION object_res1.edit_resolution_view() IS $body$
This function makes the resolution 1 view (adjusted for the rrvs) editable and forwards the edits to the underlying tables.
$body$;

DROP TRIGGER IF EXISTS res1_trigger ON object_res1.ve_resolution1;
CREATE TRIGGER res1_trigger
    INSTEAD OF INSERT OR UPDATE OR DELETE ON object_res1.ve_resolution1 
      FOR EACH ROW 
      EXECUTE PROCEDURE object_res1.edit_resolution_view();


-------------------------------------------
-- resolution 1 view data (per-building) --
-------------------------------------------
DROP VIEW IF EXISTS object_res1.v_resolution1_data;
CREATE OR REPLACE VIEW object_res1.v_resolution1_data AS
  SELECT
   a.*,
   b.*,
   e.vuln_1,
   e.vuln_2,
   c.height_1,
   c.height_2,
   d.yr_built_vt,
   d.yr_built_vt1
  FROM object_res1.main 
AS a
JOIN
  --get attribute values
  (SELECT * FROM crosstab(
	'SELECT object_id, attribute_type_code, attribute_value FROM object_res1.main_detail order by object_id', 'select code from taxonomy.dic_attribute_type order by gid') 
	AS ct(object_id integer, 
	      mat_type varchar, 
	      mat_tech varchar,
	      mat_prop varchar,
	      llrs varchar,
	      llrs_duct varchar,
	      height varchar,
	      yr_built varchar,
	      occupy varchar,
	      occupy_dt varchar,
	      "position" varchar,
	      plan_shape varchar,
	      str_irreg varchar,
	      str_irreg_dt varchar,
	      str_irreg_type varchar,
	      nonstrcexw varchar,
	      roof_shape varchar,
	      roofcovmat varchar,
	      roofsysmat varchar,
	      roofsystyp varchar,
	      roof_conn varchar,
	      floor_mat varchar,
	      floor_type varchar,
	      floor_conn varchar,
	      foundn_sys varchar,
	      build_type varchar,
	      build_subtype varchar,
	      vuln varchar,
	      bacc varchar,
	      bacc_gf varchar,
	      bacc_bk varchar,
	      bacc_bsl varchar,
	      wndws varchar,
	      const_qual varchar))
AS b ON (a.gid = b.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get height values
  (SELECT object_id, attribute_numeric_1 as height_1, attribute_numeric_2 as height_2 FROM object_res1.main_detail WHERE attribute_type_code = 'HEIGHT') 
AS c ON (a.gid = c.object_id)
LEFT OUTER JOIN --do a left outer join because of the where statement in the select crosstab()
  --get valid time values (yr_built_1, yr_built_2)
  (SELECT object_id, qualifier_value as yr_built_vt, qualifier_timestamp_1 as yr_built_vt1 FROM (SELECT * FROM object_res1.main_detail as a
				JOIN object_res1.main_detail_qualifier as b
				ON (a.gid = b.detail_id)) sub WHERE attribute_type_code = 'YR_BUILT' AND qualifier_type_code = 'VALIDTIME' ORDER BY object_id)  
AS d ON (a.gid = d.object_id)
LEFT OUTER JOIN  --do a left outer join because of the where statement in the select 
  --get vulnerability values
  (SELECT object_id, attribute_numeric_1 as vuln_1, attribute_numeric_2 as vuln_2 FROM object_res1.main_detail WHERE attribute_type_code = 'VULN') 
AS e ON (a.gid = e.object_id)
ORDER BY gid ASC;


-------------------------------------------------------
-- resolution 1 view metadata summary (per-building) --
-------------------------------------------------------
DROP VIEW IF EXISTS object_res1.v_resolution1_metadata;
CREATE OR REPLACE VIEW object_res1.v_resolution1_metadata AS
	SELECT 'THE_GEOM' as attribute_type, 
	       'Object geometry' as description, 
	       array(SELECT distinct(source) FROM object_res1.main) as source, 
	       'BP' as belief_type,
	       avg(accuracy) as avg_belief 
	       FROM object_res1.main
	UNION
	SELECT b.attribute_type_code as attribute_type,
	       c.description as description,
	       array(SELECT distinct(qualifier_value) FROM object_res1.main_detail_qualifier WHERE qualifier_type_code='SOURCE') as source,
	       (SELECT distinct(qualifier_value) FROM object_res1.main_detail_qualifier WHERE qualifier_type_code='BELIEF') as belief_type,
	       avg(qualifier_numeric_1) AS avg_belief
		FROM object_res1.main_detail_qualifier a
	JOIN object_res1.main_detail b ON (a.detail_id = b.gid)
	JOIN taxonomy.dic_attribute_type c ON (b.attribute_type_code = c.code)
		GROUP BY attribute_type, description, belief_type, source ORDER BY attribute_type;
