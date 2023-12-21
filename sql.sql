--------------------------------------------------
-- TH - DEVELOPMENT
-- ALL RIGHTS RESERVED 
--------------------------------------------------


CREATE TABLE IF NOT EXISTS `th_brugtvogn` (
  `model` varchar(50) DEFAULT NULL,
  `nummerplade` varchar(50) NOT NULL DEFAULT '',
  `pris` int(11) DEFAULT NULL,
  PRIMARY KEY (`nummerplade`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
