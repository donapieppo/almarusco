alter table `disposals` add column `delivered_at` date after `approved_at`;
alter table `pickings` add column `delivered_at` date after `created_at`;

/* create table `cer_codes_suppliers` ( */
/*   `cer_code_id` int(10) unsigned NOT NULL, */
/*   `supplier_id` int(10) unsigned NOT NULL, */
/*   PRIMARY KEY (`cer_code_id, supplier_id`), */
/*   KEY `fk_cer_codes_crsupp` (`cer_code_id`), */
/*   KEY `fk_suppliers_crsupp` (`supplier_id`), */ 
/*   CONSTRAINT `fk_cer_codes_crsupp` FOREIGN KEY (`cer_code_id`) REFERENCES `cer_codes` (`id`), */
/*   CONSTRAINT `fk_suppliers_crsupp` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`) */
/* ) CHARSET=utf8mb4;; */  

create table `pickings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) unsigned NOT NULL,
  `supplier_id` int(10) unsigned NOT NULL,
  `date` date,
  `created_at` datetime,
  PRIMARY KEY (`id`),
  KEY `fk_pickings_organizations` (`organization_id`),
  CONSTRAINT `fk_pickings_organizations` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  KEY `fk_pickings_suppliers` (`supplier_id`),
  CONSTRAINT `fk_pickings_suppliers` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`)
) CHARSET=utf8mb4;

alter table `disposals` add column `picking_id` int(10) unsigned DEFAULT NULL after `lab_id`;
alter table `disposals` add KEY `fk_disposals_pickings` (`picking_id`);
alter table `disposals` add CONSTRAINT `fk_disposals_pickings` FOREIGN KEY (`picking_id`) REFERENCES `pickings` (`id`);


/* alter table `permissions` add column `producer_id` int(10) unsigned DEFAULT NULL; */
/* alter table `permissions` add key `fk_permission_producer` (`producer_id`); */
/* alter table `permissions` add constraint `fk_permission_producer` FOREIGN KEY (`producer_id`) REFERENCES `users` (`id`); */

/* create table `labs` ( */
/*   `id` int(10) unsigned NOT NULL AUTO_INCREMENT, */
/*   `organization_id` int(10) DEFAULT NULL, */
/*   `name` varchar(255), */
/*   PRIMARY KEY (`id`), */
/*   KEY `fk_labs_organizations` (`organization_id`), */
/*   CONSTRAINT `fk_labs_organizations` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`) */
/* ) CHARSET=utf8mb4; */

/* alter table `disposals` add column `producer_id`  int(10) unsigned DEFAULT NULL after `user_id`; */
/* alter table `disposals` add KEY `fk_disposals_producers` (`producer_id`); */
/* alter table `disposals` add CONSTRAINT `fk_disposals_producers` FOREIGN KEY (`producer_id`) REFERENCES `users` (`id`); */

/* alter table `disposals` add column `lab_id`  int(10) unsigned DEFAULT NULL after `user_id`; */
/* alter table `disposals` add KEY `fk_disposals_labs` (`lab_id`); */
/* alter table `disposals` add CONSTRAINT `fk_disposals_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`); */

