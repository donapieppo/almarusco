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
