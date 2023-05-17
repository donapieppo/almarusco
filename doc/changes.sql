alter table disposal_types add column `hidden` bool not null default 0 after `separable`;

create table containers (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
        `name` varchar(255),
        `liters` int(2),
        `notes` text,
        PRIMARY KEY (`id`)
);

create table containers_disposal_types (
        `container_id` int(10) unsigned NOT NULL,
        `disposal_type_id` int(10) unsigned NOT NULL,
        FOREIGN KEY (container_id) REFERENCES containers (id),
        FOREIGN KEY (disposal_type_id) REFERENCES disposal_types(id)
);

insert into containers values (1, 'tanica', 5, '');
insert into containers values (2, 'tanica', 10, '');
insert into containers values (3, 'tanica', 20, '');
insert into containers values (4, 'fusto', 30, '');
insert into containers values (5, 'polietilene', 30, '');
insert into containers values (6, 'fusto', 40, '');
insert into containers values (7, 'fusto', 60, '');
insert into containers values (8, 'polietilene', 60, '');
insert into containers values (9, 'clinipack', 60, '');
insert into containers values (10, 'tanica', 120, '');
insert into containers values (11, 'big bag', 500, '');

-- alter table organizations add column `next_local_id` int(10) default 1 after `description`;
-- alter table disposals add column `local_id` int(10) after `disposal_type_id`;
-- alter table disposals add KEY `k_local_id` (`local_id`);
-- update permissions set expiry ='2023-01-31' where expiry <= '2023-01-01';

-- select * from disposals where legalized_at is null and delivered_at is not null;
-- select * from disposals where legalized_at is null and delivered_at is not null;
-- select * from disposals where legalized_at is not null and legal_record_id is null order by legalized_at;

-- select * from disposals where legalized_at > delivered_at and legal_record_id is not null;
-- update disposals set legal_record_id = NULL      where legalized_at > delivered_at and legal_record_id is not null;
-- update disposals set legalized_at = delivered_at where legalized_at > delivered_at and legal_record_id is null;
-- update disposals set legalized_at = delivered_at where delivered_at is not null and legalized_at is null;
