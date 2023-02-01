-- alter table organizations add column `next_local_id` int(10) default 1 after `description`;
-- alter table disposals add column `local_id` int(10) after `disposal_type_id`;
-- alter table disposals add KEY `k_local_id` (`local_id`);
-- update permissions set expiry ='2023-01-31' where expiry <= '2023-01-01';

alter table disposals alter kgs SET DEFAULT 0;
update disposals set kgs=0 where kgs is null;

alter table disposal_types drop column adr;

delete from picking_documents where id=89;

alter table disposal_types add column `separable` BOOL default 0 NOT NULL after `physical_state`;
alter table disposals add column `units` SMALLINT default 1 AFTER `volume`;
update disposals set `units`=1;

alter table picking_documents add UNIQUE KEY (`picking_id`, `disposal_type_id`);

-- legalizations
-- legal_records 
create table legal_records (
        `id` int(10) unsigned NOT NULL AUTO_INCREMENT, 
        `type` enum('LegalUpload', 'LegalDownload'),
        `organization_id` int(10) unsigned NOT NULL,
        `disposal_type_id` int(10) unsigned DEFAULT NULL,
        `picking_document_id` int(10) unsigned DEFAULT NULL,
        `year` int(1) unsigned NOT NULL,
        `date` date, 
        `number` int(10) unsigned NOT NULL,
        `created_at` date,
        `updated_at` date,
        PRIMARY KEY (`id`),
        KEY `k_number`(`number`),
        FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE, 
        FOREIGN KEY (disposal_type_id) REFERENCES disposal_types(id) ON DELETE CASCADE, 
        FOREIGN KEY (picking_document_id) REFERENCES picking_documents(id) ON DELETE CASCADE, 
        UNIQUE KEY (`organization_id`, `year`, `number`)
);

alter table disposals add column `legal_record_id` int(10) unsigned after `disposal_type_id`;
alter table disposals add FOREIGN KEY (legal_record_id) REFERENCES `legal_records` (`id`);

-- alter table disposals add column `aasm_state` text;

-- alter table pickings add column `legal_record_id` int(10) unsigned after `supplier_id`;
-- alter table pickings add FOREIGN KEY (legal_record_id) REFERENCES `legal_records` (`id`);

