alter table pickings add column `address` TEXT after `date`;
alter table pickings add column `contact` TEXT after `address`;

alter table disposals add column `legalized_at` date DEFAULT NULL after approved_at;
update disposals set legalized_at = delivered_at where delivered_at is not null;



alter table `permissions` add column `expiry` date after `producer_id`; 
update permissions set expiry = '2023-01-01' where producer_id is not null ;

CREATE TABLE `picking_documents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `picking_id` int(10) unsigned NOT NULL,
  `disposal_type_id` int(10) unsigned NOT NULL,
  `serial_number` varchar(255),
  `register_number` int(2),
  `kgs` decimal(10,3),
  `volume` decimal(10,3),
  PRIMARY KEY (`id`),
  KEY `fk_picking_document_disposal_type` (`disposal_type_id`),
  KEY `fk_picking_document_picking` (`picking_id`),
  CONSTRAINT `fk_picking_document_disposal_type` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`),
  CONSTRAINT `fk_picking_document_picking` FOREIGN KEY (`picking_id`) REFERENCES `pickings` (`id`)
);

CREATE TABLE `adrs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) CHARSET=utf8mb4;

CREATE TABLE `adrs_disposal_types` (
  `adr_id` int(10) unsigned DEFAULT NULL,
  `disposal_type_id` int(10) unsigned DEFAULT NULL,
  KEY `fk_adrdt_adr` (`adr_id`),
  KEY `fk_adrdt_dt` (`disposal_type_id`),
  CONSTRAINT `fk_adrdt_adr` FOREIGN KEY (`adr_id`) REFERENCES `adrs` (`id`),
  CONSTRAINT `fk_adrdt_dt` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `pictograms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `filename` varchar(255),
  PRIMARY KEY (`id`)
) CHARSET=utf8mb4;

INSERT INTO `pictograms` VALUES (10, '1',   'adrs/adr_1.svg');
INSERT INTO `pictograms` VALUES (20, '2.1', 'adrs/adr_2.1.svg');
INSERT INTO `pictograms` VALUES (30, '2.2', 'adrs/adr_2.2.svg');
INSERT INTO `pictograms` VALUES (40, '2.3', 'adrs/adr_2.3.svg');
INSERT INTO `pictograms` VALUES (50, '3',   'adrs/adr_3.svg');
INSERT INTO `pictograms` VALUES (60, '4.1', 'adrs/adr_4.1.svg');
INSERT INTO `pictograms` VALUES (70, '4.2', 'adrs/adr_4.2.svg');
INSERT INTO `pictograms` VALUES (80, '4.3', 'adrs/adr_4.3.svg');
INSERT INTO `pictograms` VALUES (90, '5.1', 'adrs/adr_5.1.svg');
INSERT INTO `pictograms` VALUES (100, '5.2', 'adrs/adr_5.2.svg');
INSERT INTO `pictograms` VALUES (110, '6.1', 'adrs/adr_6.1.svg');
INSERT INTO `pictograms` VALUES (120, '6.2', 'adrs/adr_6.2.svg');
INSERT INTO `pictograms` VALUES (130, '7b', 'adrs/adr_7b.svg');
INSERT INTO `pictograms` VALUES (140, '8',  'adrs/adr_8.svg');
INSERT INTO `pictograms` VALUES (150, '9',  'adrs/adr_9.svg');
INSERT INTO `pictograms` VALUES (160, '9a', 'adrs/adr_9a.svg');

INSERT INTO `pictograms` VALUES (200, 'ghs01', 'ghs/ghs01.png');
INSERT INTO `pictograms` VALUES (210, 'ghs01', 'ghs/ghs02.png');
INSERT INTO `pictograms` VALUES (220, 'ghs01', 'ghs/ghs03.png');
INSERT INTO `pictograms` VALUES (230, 'ghs01', 'ghs/ghs04.png');
INSERT INTO `pictograms` VALUES (240, 'ghs01', 'ghs/ghs05.png');
INSERT INTO `pictograms` VALUES (250, 'ghs01', 'ghs/ghs06.png');
INSERT INTO `pictograms` VALUES (260, 'ghs01', 'ghs/ghs07.png');
INSERT INTO `pictograms` VALUES (270, 'ghs01', 'ghs/ghs08.png');
INSERT INTO `pictograms` VALUES (280, 'ghs01', 'ghs/ghs09.png');


CREATE TABLE `disposal_types_pictograms` (
  `disposal_type_id` int(10) unsigned DEFAULT NULL,
  `pictogram_id` int(10) unsigned DEFAULT NULL,
  -- KEY `fk_dtp_dt` (`disposal_type_id`),
  -- KEY `fk_dtp_picto` (`pictogram_id`),
  CONSTRAINT `fk_dtp_dt` FOREIGN KEY (`disposal_type_id`) REFERENCES `disposal_types` (`id`),
  CONSTRAINT `fk_dtp_picto` FOREIGN KEY (`pictogram_id`) REFERENCES `pictograms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

