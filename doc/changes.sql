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
insert into buildings values(0, 47, "U.e.4", "via Gobetti 85", "Ricerca di CHIM e CHIMIND");
insert into buildings values(0, 47, "U.e.5", "via Gobetti 87", "Didattica + ricerca computazionale Fabit");
insert into buildings values(0, 47, "U.e.6", "via Bignardi 15", "Ricerca Fabit");

update buildings set name="ED 215", address="via dei matti 1", description="" where organization_id=23;
insert into buildings values(0, 23, "ED 225", "via dei matti 2", "");
insert into buildings values(0, 23, "ED 301", "via dei matti 3", "");
insert into buildings values(0, 23, "ED 441", "via dei matti 4", "");


