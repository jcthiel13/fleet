CREATE TABLE `fleet` (
  `id` int(11) NOT NULL,
  `vehnum` varchar(11) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT '''avail''',
  `plate` varchar(255) DEFAULT NULL,
  `mileage` text DEFAULT '1',
  `hash` text NOT NULL,
  `metadata` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `dept` varchar(255) DEFAULT NULL,
  `damage` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;