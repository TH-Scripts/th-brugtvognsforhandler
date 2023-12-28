--
-- TH - DEVELOPMENT
-- ALL RIGHTS RESERVED 
--


CREATE TABLE IF NOT EXISTS `th_brugtvogn_lager` (
  `model` varchar(50) DEFAULT NULL,
  `nummerplade` varchar(50) NOT NULL DEFAULT '',
  `pris` int(11) DEFAULT NULL,
  `displayed` int(11) DEFAULT '0',
  PRIMARY KEY (`nummerplade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;



--
-- Job SQL - ignorer hvis du allerede har et job inde
--

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_brugtvogn', 'Brugtvogn', 1)
;


INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_brugtvogn', 'Brugtvogn', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_brugtvogn', 'Brugtvogn', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('brugtvogn', 'Brugtvognsforhandler')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('brugtvogn',0,'elev ','Elev ',0,'{}','{}'),
	('brugtvogn',1,'medarbejder','Medarbejder',0,'{}','{}'),
	('brugtvogn',2,'boss','Chef',0,'{}','{}')
;