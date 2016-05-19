-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2016 at 09:28 AM
-- Server version: 5.5.49-0ubuntu0.14.04.1-log
-- PHP Version: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `test`
--

-- --------------------------------------------------------

--
-- Table structure for table `steamcommunity`
--

CREATE TABLE IF NOT EXISTS `steamcommunity` (
  `steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `Steam2` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `Steam3` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `SteamID64` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `age` char(65) DEFAULT NULL,
  PRIMARY KEY (`steamId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
