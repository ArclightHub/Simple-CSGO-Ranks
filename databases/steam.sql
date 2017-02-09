-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 26, 2016 at 11:45 AM
-- Server version: 5.5.47-0ubuntu0.14.04.1-log
-- PHP Version: 5.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `steam`
--

-- --------------------------------------------------------

--
-- Table structure for table `steam`
--

CREATE TABLE IF NOT EXISTS `steam` (
  `steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `rank` INT(11) NULL DEFAULT NULL,
  `age` char(65) DEFAULT NULL,
  PRIMARY KEY (`steamId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `steamname`
--

CREATE TABLE IF NOT EXISTS `steamname` (
  `steamId` char(65) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `name` char(255) DEFAULT NULL,
  PRIMARY KEY (`steamId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
