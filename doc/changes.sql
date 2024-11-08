-- DROP TABLE `disposal_descriptions_pictograms`;
DROP TABLE IF EXISTS `component_details_hazards`;
DROP TABLE IF EXISTS `component_details_hp_codes`;
DROP TABLE IF EXISTS `adrs_component_details`;
DROP TABLE IF EXISTS `component_details`;
DROP TABLE IF EXISTS `disposal_descriptions`;
DROP TABLE IF EXISTS `compliances`;

CREATE TABLE `disposal_descriptions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `name` text,
  `department` text,
  `place` text,
  `chief` varchar(255),
  `lab` text,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_disposal_descriptions_organizations` FOREIGN KEY (organization_id) REFERENCES organizations(id),
  CONSTRAINT `fk_disposal_descriptions_users` FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE `component_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `disposal_description_id` int(10) unsigned NOT NULL,
  `name` text,
  `percentage` int(2) unsigned,
  `un_code_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_component_details_disposal_description` FOREIGN KEY (disposal_description_id) REFERENCES disposal_descriptions(id),
  CONSTRAINT `fk_component_details_un_code` FOREIGN KEY (un_code_id) REFERENCES un_codes(id)
);

CREATE TABLE `component_details_hazards` (
  `component_detail_id` int(10) unsigned NOT NULL, 
  `hazard_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_hazards_component_detail` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_hazards_hazards` FOREIGN KEY (hazard_id) REFERENCES hazards(id)
);

CREATE TABLE `component_details_hp_codes` (
  `component_detail_id` int(10) unsigned NOT NULL, 
   `hp_code_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_hp_codes_component` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_hp_codes_hp_code` FOREIGN KEY (hp_code_id) REFERENCES hp_codes(id)
);

CREATE TABLE `adrs_component_details` (
  `component_detail_id` int(10) unsigned NOT NULL, 
   `adr_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_adrs_component` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_adrs_adr` FOREIGN KEY (adr_id) REFERENCES adrs(id)
);

CREATE TABLE `disposal_descriptions_pictograms` (
  `disposal_description_id` int(10) unsigned DEFAULT NULL,
  `pictogram_id` int(10) unsigned DEFAULT NULL,
  CONSTRAINT `fk_ddp_dt` FOREIGN KEY (`disposal_description_id`) REFERENCES `disposal_types` (`id`),
  CONSTRAINT `fk_ddp_picto` FOREIGN KEY (`pictogram_id`) REFERENCES `pictograms` (`id`)
);

-- 

ALTER TABLE disposals ADD COLUMN `multiple_users` bool default false;

CREATE TABLE `compliances` (
  `id` int(10) unsigned NOT NULL,
  `organization_id` int(10) unsigned DEFAULT NULL,
  `name` text,
  `description` text,
  `year` int(2) unsigned,
  `url` text,
  PRIMARY KEY (`id`)
);

ALTER TABLE `disposal_types` ADD COLUMN `compliance_id` int(10) unsigned after `notes`;
ALTER TABLE `disposal_types` ADD COLUMN `compliance_alert` text;
ALTER TABLE `disposal_types` ADD COLUMN `created_at` TIMESTAMP;
ALTER TABLE `disposal_types` ADD CONSTRAINT `fw_compliances_disposal_types` FOREIGN KEY (`compliance_id`) REFERENCES `compliances` (`id`);

-- Componenti  
-- Frasi H (CLP) 
-- Stima di conc% 
-- HP 
-- ADR (UN) 
-- ADR  
-- classe 
-- ADR 
-- Gruppo imballaggio 

