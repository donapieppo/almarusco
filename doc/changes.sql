-- alter table organizations add column `next_local_id` int(10) default 1 after `description`;
-- alter table disposals add column `local_id` int(10) after `disposal_type_id`;
-- alter table disposals add KEY `k_local_id` (`local_id`);
-- update permissions set expiry ='2023-01-31' where expiry <= '2023-01-01';

