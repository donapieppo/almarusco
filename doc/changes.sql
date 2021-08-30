alter table `disposals` add column `volume` int(2) after `kgs`;
alter table `disposals` drop column `liters`;

drop table `volumes`;

-- tutti dati via, esaurito deposito
alter table `disposals` add column `completed_at` date unsigned after `approved_at`;

create table `withdraws` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `disposal_type_id` int(10) unsigned, 
  `withdraw_date` date,
  `kgs` decimal(10,3) DEFAULT NULL,
  `kgs_confirmed` decimal(10,3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_withdraws_organizations` (`organization_id`),
  CONSTRAINT `fk_withdraws_organizations` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  KEY `fk_withdraws_suppliers` (`supplier_id`),
  CONSTRAINT `fk_withdraws_suppliers` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  KEY `fk_withdraws_types` (`disposal_type_id`),
  CONSTRAINT `fk_withdraws_types` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`)
) CHARSET=utf8mb4;





