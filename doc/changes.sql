alter table add column `volume` int(2) after `kgs`;
alter table `disposals` drop column `liters`;

drop table `volumes`;

-- no, non serve?
-- il disposal_tppe resta per tutto il processo.
create table `deposits` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) DEFAULT NULL,
  `disposal_type_id` int(10) unsigned, 
  PRIMARY KEY (`id`),
  KEY `fk_deposits_organizations` (`organization_id`),
  CONSTRAINT `fk_deposits_organizations` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  KEY `fk_deposits_types` (`disposal_type_id`),
  CONSTRAINT `fk_deposits_types` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`)
) CHARSET=utf8mb4;

-- si toglie quando si libera tutto il deposito e allora i 
-- disposals hanno completed_at
-- il problema e' che nel deposito non di differenziano quali
-- disposal si danno via.
create table `desposits_disposals` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `deposit_id` int(10) unsigned,
  `disposal_id` int(10) unsigned
) CHARSET=utf8mb4;

-- OR

-- tutti dati via, esaurito deposito
alter table `disposals` add column `completed_at` date unsigned after `approved_at`;
alter table `disposals` add column `deposit_id` int(10) unsigned after `liters`;
alter table `disposals` add KEY `fk_disposals_deposits` (`deposit_id`);
alter table `disposals` add CONSTRAINT `fk_disposals_deposits` FOREIGN KEY (`deposit_id`) REFERENCES `deposits` (`id`);

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





