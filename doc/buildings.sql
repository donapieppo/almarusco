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
