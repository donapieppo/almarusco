-- ALTER TABLE disposals ADD COLUMN `multiple_users` bool default false;

DROP TABLE `component_details_hazards`;
DROP TABLE `component_details_hp_codes`;
DROP TABLE `adrs_component_details`;
DROP TABLE `component_details`;
DROP TABLE `disposal_descriptions`;
create table `disposal_descriptions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `name` text,
  `lab_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_disposal_descriptions_organizations` FOREIGN KEY (organization_id) REFERENCES organizations(id),
  CONSTRAINT `fk_disposal_descriptions_users` FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT `fk_disposal_descriptions_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`)
);

create table `component_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `disposal_description_id` int(10) unsigned NOT NULL,
  `name` text,
  `percentage` int(2) unsigned,
  `un_code_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_component_details_disposal_description` FOREIGN KEY (disposal_description_id) REFERENCES disposal_descriptions(id),
  CONSTRAINT `fk_component_details_un_code` FOREIGN KEY (un_code_id) REFERENCES un_codes(id)
);

create table `component_details_hazards` (
  `component_detail_id` int(10) unsigned NOT NULL, 
  `hazard_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_hazards_component_detail` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_hazards_hazards` FOREIGN KEY (hazard_id) REFERENCES hazards(id)
);

create table `component_details_hp_codes` (
  `component_detail_id` int(10) unsigned NOT NULL, 
   `hp_code_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_hp_codes_component` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_hp_codes_hp_code` FOREIGN KEY (hp_code_id) REFERENCES hp_codes(id)
);

create table `adrs_component_details` (
  `component_detail_id` int(10) unsigned NOT NULL, 
   `adr_id` int(10) unsigned NOT NULL,
  CONSTRAINT `fk_component_details_adrs_component` FOREIGN KEY (component_detail_id) REFERENCES component_details(id),
  CONSTRAINT `fk_component_details_adrs_adr` FOREIGN KEY (adr_id) REFERENCES adrs(id)
);

-- Componenti  
-- Frasi H (CLP) 
-- Stima di conc% 
-- HP 
-- ADR (UN) 
-- ADR  
-- classe 
-- ADR 
-- Gruppo imballaggio 

