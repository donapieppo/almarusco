-- alter table organizations add column `next_local_id` int(10) default 1 after `description`;
-- alter table disposals add column `local_id` int(10) after `disposal_type_id`;
-- alter table disposals add KEY `k_local_id` (`local_id`);
-- update permissions set expiry ='2023-01-31' where expiry <= '2023-01-01';

create table buildings (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `organization_id` int(10) unsigned DEFAULT NULL,
        `name` varchar(255) NOT NULL,
        `address` text,
        `description` text,
        PRIMARY KEY (`id`),
        FOREIGN KEY (organization_id) REFERENCES `organizations` (`id`)
);

alter table labs add column `building_id` int(10) unsigned after `id`;
alter table labs add FOREIGN KEY (building_id) REFERENCES `buildings` (`id`);

# ./bin/rails almarusco:fix_buildings_start 

update buildings set name="U.e.4", address="via Gobetti 85", description="ricerca di CHIM e CHIMIND"  where organization_id=47;
insert into buildings values(0, 47, "U.e.4", "Via Gobetti 85", "Ricerca di CHIM e CHIMIND");
insert into buildings values(0, 47, "U.e.5", "Via Gobetti 87", "Didattica + ricerca computazionale Fabit");
insert into buildings values(0, 47, "U.e.6", "Via Bignardi 15", "Ricerca Fabit");

update buildings set name="ED 225", address="Via Selmi 2", description="" where organization_id=23;
insert into buildings values(0, 23, "ED 441", "Via S. Giacomo 7", "");

create table contracts (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `supplier_id` int(10) unsigned NOT NULL,
  `cer_code_id` int(10) unsigned NOT NULL,
  `price` int(5) unsigned,
  `start_date` date,
  `end_date` date,
  PRIMARY KEY (`id`),
  FOREIGN KEY (supplier_id) REFERENCES `suppliers` (`id`),
  FOREIGN KEY (cer_code_id) REFERENCES `cer_codes` (`id`)
);

INSERT INTO contracts (`supplier_id`, `cer_code_id`)
  SELECT
    `supplier_id`,
    `cer_code_id`
  FROM cer_codes_suppliers;



