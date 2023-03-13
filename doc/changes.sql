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
