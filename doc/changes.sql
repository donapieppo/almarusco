alter table disposal_types add column `separable` BOOL default 0 NOT NULL after `physical_state`;
alter table disposals add column `units` SMALLINT after `volume`;
update disposals set `units`=1;

alter table disposals add column `register_number` INT after `disposal_type_id`;

/* alter table disposals add column `legalized_at` date DEFAULT NULL after approved_at; */
/* update disposals set legalized_at = delivered_at where delivered_at is not null; */

/* CREATE TABLE `picking_documents` ( */
/*   `id` int(10) unsigned NOT NULL AUTO_INCREMENT, */
/*   `picking_id` int(10) unsigned NOT NULL, */
/*   `disposal_type_id` int(10) unsigned NOT NULL, */
/*   `serial_number` varchar(255), */
/*   `register_number` int(2), */
/*   `kgs` decimal(10,3), */
/*   `volume` decimal(10,3), */
/*   PRIMARY KEY (`id`), */
/*   KEY `fk_picking_document_disposal_type` (`disposal_type_id`), */
/*   KEY `fk_picking_document_picking` (`picking_id`), */
/*   CONSTRAINT `fk_picking_document_disposal_type` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`), */
/*   CONSTRAINT `fk_picking_document_picking` FOREIGN KEY (`picking_id`) REFERENCES `pickings` (`id`) */
/* ); */

