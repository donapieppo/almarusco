alter table `permissions` add column `producer_id` int(10) unsigned DEFAULT NULL;
alter table `permissions` add key `fk_permission_producer` (`producer_id`);
alter table `permissions` add constraint `fk_permission_producer` FOREIGN KEY (`producer_id`) REFERENCES `users` (`id`);

create table `labs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `organization_id` int(10) DEFAULT NULL,
  `name` varchar(255),
  PRIMARY KEY (`id`),
  KEY `fk_labs_organizations` (`organization_id`),
  CONSTRAINT `fk_labs_organizations` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`)
) CHARSET=utf8mb4;

alter table `disposals` add column `producer_id`  int(10) unsigned DEFAULT NULL after `user_id`;
alter table `disposals` add KEY `fk_disposals_producers` (`producer_id`);
alter table `disposals` add CONSTRAINT `fk_disposals_producers` FOREIGN KEY (`producer_id`) REFERENCES `users` (`id`);

alter table `disposals` add column `lab_id`  int(10) unsigned DEFAULT NULL after `user_id`;
alter table `disposals` add KEY `fk_disposals_labs` (`lab_id`);
alter table `disposals` add CONSTRAINT `fk_disposals_labs` FOREIGN KEY (`lab_id`) REFERENCES `labs` (`id`);

