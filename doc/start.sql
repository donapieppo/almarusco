drop database `almarusco`;
create database `almarusco`;

use `almarusco`;

CREATE TABLE `organizations` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `adminmail` varchar(200) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `upn` varchar(150) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `employee_id` int(10) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_dsacaches_on_upn` (`upn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO users VALUES (436108, 'pietro.donatini@unibo.it', NULL, 'Pietro', 'Donatini', NULL, NULL, NULL);

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `pi` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `un_codes` (
  `id` int(10) unsigned NOT NULL PRIMARY KEY,
  `name` text
) ENGINE=InnoDB;
INSERT INTO `un_codes` VALUES (1992, "LIQUIDO INFIAMMABILE, TOSSICO");
INSERT INTO `un_codes` VALUES (2810, "LIQUIDO ORGANICO TOSSICO");
INSERT INTO `un_codes` VALUES (3077, "MATERIA PERICOLOSA DAL PUNTO DI VISTA DELL'AMBIENTE, SOLIDA");
INSERT INTO `un_codes` VALUES (3082, "ALTRI OLII PER MOTORI, INGRANAGGI E LUBRIFICAZIONE");
INSERT INTO `un_codes` VALUES (3264, "LIQUIDO INORGANICO CORROSIVO, ACIDO");
INSERT INTO `un_codes` VALUES (3266, "LIQUIDO INORGANICO CORROSIVO, BASICO");
INSERT INTO `un_codes` VALUES (3287, "LIQUIDO INORGANICO TOSSICO");
INSERT INTO `un_codes` VALUES (3288, "SOLIDO INORGANICO TOSSICO");
INSERT INTO `un_codes` VALUES (3289, "LIQUIDO INORGANICO TOSSICO, CORROSIVO");
INSERT INTO `un_codes` VALUES (3291, "RIFIUTI OSPEDALIERI, NON SPECIFICATI,");
INSERT INTO `un_codes` VALUES (3316, "CONFEZIONI CHIMICHE o CONFEZIONI DI PRONTO SOCCORSO");
INSERT INTO `un_codes` VALUES (3509, "IMBALLAGGI DISMESSI, VUOTI, NON RIPULITI");


CREATE TABLE `cer_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100),
  `description` text,
  `danger` bool,
  INDEX (name)
) ENGINE=InnoDB;

INSERT INTO `cer_codes` VALUES (0, "060106", "Altri acidi", 1);
INSERT INTO `cer_codes` VALUES (0, "060205", "Altre basi", 1);
INSERT INTO `cer_codes` VALUES (0, "060313", "Sali e loro soluzioni contenenti metalli pesanti", 1);
INSERT INTO `cer_codes` VALUES (0, "070103", "Solventi organici alogenati, soluzioni di lavaggio ed acque madri", 1);
INSERT INTO `cer_codes` VALUES (0, "070104", "Altri solventi organici, soluzioni di lavaggio ed acque madri. Non alogenati e solventi di recupero da HPLC", 1);
INSERT INTO `cer_codes` VALUES (0, "070110", "Altri residui di filtrazione e assorbenti esauriti", 1);
INSERT INTO `cer_codes` VALUES (0, "070216", "Rifiuti contenenti siliconi pericolosi", 1);
INSERT INTO `cer_codes` VALUES (0, "150110", "Imballaggi contenenti residui di sostanze pericolose o contaminati da tali sostanze", 1);
INSERT INTO `cer_codes` VALUES (0, "150202", "Assorbenti, materiali filtranti (inclusi filtri dell’olio non specificati altrimenti, stracci e indumenti protettivi)", 1);
INSERT INTO `cer_codes` VALUES (0, "160506", "INFIAMMABILE, TOSSICO (etanolo e cloroformio), N.A.S., 3+6.1, II (D/E), RIFIUTI CONFORMI AL 2.1.3.5.5 Sostanze chimiche di laboratorio contenenti o costituite da sostanze pericolose, comprese le miscele di sostanze chimiche", 1);
INSERT INTO `cer_codes` VALUES (0, "170603", "Altri materiali isolanti contenenti o costituiti da sostanze pericolose; Rotoli alti ca 1 metro di lana di roccia, priva di contaminanti addizionali in quanto era stata utilizzata per piccoli prelievi di campioni da analizzare in laboratorio", 1);

CREATE TABLE `hp_codes` (
  `id` int(10) unsigned NOT NULL PRIMARY KEY,
  `name` varchar(255),
  `description` text,
  INDEX (name)
) ENGINE=InnoDB;

INSERT INTO hp_codes VALUES (1, 'Esplosivo', "Rifiuto che può, per reazione chimica, sviluppare gas a una temperatura, una pressione e una velocità tali da causare danni nell'area circostante. Sono inclusi i rifiuti pirotecnici, i rifiuti di perossidi organici esplosivi e i rifiuti autoreattivi esplosivi.");
INSERT INTO hp_codes VALUES (2, 'Comburente', "Rifiuto liquido infiammabile");
INSERT INTO hp_codes VALUES (3, 'Infiammabile', "");
INSERT INTO hp_codes VALUES (4, 'Irritante — Irritazione cutanea e lesioni oculari', "Rifiuto la cui applicazione può provocare irritazione cutanea o lesioni oculari.");
INSERT INTO hp_codes VALUES (5, 'Tossicità specifica per organi bersaglio (STOT)/ Tossicità in caso di respirazione', "");
INSERT INTO hp_codes VALUES (6, 'Tossicità acuta', "");
INSERT INTO hp_codes VALUES (7, 'Cancerogeno', "");
INSERT INTO hp_codes VALUES (8, 'Corrosivo', "");
INSERT INTO hp_codes VALUES (9, 'Infettivo', "");
INSERT INTO hp_codes VALUES (10, 'Tossico per la riproduzione', "");
INSERT INTO hp_codes VALUES (11, 'Mutageno', "");
INSERT INTO hp_codes VALUES (12, 'Liberazione di gas a tossicità acuta', "");
INSERT INTO hp_codes VALUES (13, 'Sensibilizzante', "");
INSERT INTO hp_codes VALUES (14, 'Ecotossico', "");
INSERT INTO hp_codes VALUES (15, 'Rifiuto che non possiede direttamente una delle caratteristiche di pericolo summenzionate ma può manifestarla successivamente', "");

CREATE TABLE `disposal_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `organization_id` int(11),
  `cer_code_id` int(10) unsigned,
  `un_code_id` int(10) unsigned,
  `adr` bool,
  `physical_state` ENUM('liq', 'sp', 'snp'),
  `notes` text,
  CONSTRAINT `fk_disposal_types_organization` FOREIGN KEY (organization_id) REFERENCES organizations(id),
  CONSTRAINT `fk_disposal_types_cer` FOREIGN KEY (cer_code_id) REFERENCES cer_codes(id),
  CONSTRAINT `fk_disposal_types_un` FOREIGN KEY (un_code_id) REFERENCES un_codes(id)
) ENGINE=InnoDB;

CREATE TABLE `disposal_types_hp_codes` (
  `disposal_type_id` int(10) unsigned,
  `hp_code_id` int(10) unsigned,
  CONSTRAINT `fk_dthc_disposal` FOREIGN KEY (disposal_type_id) REFERENCES disposal_types(id),
  CONSTRAINT `fk_dthc_hp_code` FOREIGN KEY (hp_code_id) REFERENCES hp_codes(id)
) ENGINE=InnoDB;

CREATE TABLE `disposals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` int(10) unsigned,
  `organization_id` int(11),
  `disposal_type_id` int(10) unsigned, 
  `notes` text,
  `kgs` DECIMAL(10,3),
  `liters` DECIMAL(10,3),
  -- `un_code_id` int(10) unsigned,
  -- `cer_code_id` int(10) unsigned,
  -- `physical_state` ENUM('liq', 'sp', 'snp'),
  `created_at` date,
  `approved_at` date,
  CONSTRAINT `fk_disposals_users` FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT `fk_disposals_organizations` FOREIGN KEY (organization_id) REFERENCES organizations(id),
  CONSTRAINT `fk_disposals_disposal_type` FOREIGN KEY (disposal_type_id) REFERENCES disposal_types(id)
  -- CONSTRAINT `fk_disposals_cer` FOREIGN KEY (cer_code_id) REFERENCES cer_codes(id),
  -- CONSTRAINT `fk_disposals_un` FOREIGN KEY (un_code_id) REFERENCES un_codes(id)
) ENGINE=InnoDB;

CREATE TABLE `cer_codes_suppliers` (
  `cer_code_id` int(10) unsigned,
  `supplier_id` int(11),
  CONSTRAINT `fk_ccs_cer_code` FOREIGN KEY (`cer_code_id`) REFERENCES cer_codes(id),
  CONSTRAINT `fk_ccs_supplier` FOREIGN KEY (`supplier_id`) REFERENCES suppliers(id)
) ENGINE=InnoDB;

-- 10L 20L per i liquidi
-- 40L, 60L, 120L per i solidi
CREATE TABLE `volumes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `num` int(10) unsigned,
  `liters` int(10) unsigned, 
  `disposal_id` int(10) unsigned,
  CONSTRAINT `fk_dv_disposal` FOREIGN KEY (`disposal_id`) REFERENCES disposals(id)
) ENGINE=InnoDB;

CREATE TABLE `permissions` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `organization_id` int(10) DEFAULT NULL,
  `network` varchar(20) DEFAULT NULL,
  `authlevel` int(10) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_permission` (`user_id`),
  KEY `fk_organization_permission` (`organization_id`),
  CONSTRAINT `fk_organization_permission` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  CONSTRAINT `fk_user_permission` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

