-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 31, 2016 at 03:05 PM
-- Server version: 10.1.10-MariaDB
-- PHP Version: 7.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `disjasad`
--

-- --------------------------------------------------------

--
-- Table structure for table `disjas_active_test`
--

CREATE TABLE `disjas_active_test` (
  `id_active_test` int(11) NOT NULL,
  `id_test` varchar(11) NOT NULL,
  `flag` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `disjas_active_test`
--

INSERT INTO `disjas_active_test` (`id_active_test`, `id_test`, `flag`) VALUES
(2, '34', '0'),
(3, '35', '0'),
(4, '36', '0'),
(5, '32', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `disjas_active_test`
--
ALTER TABLE `disjas_active_test`
  ADD PRIMARY KEY (`id_active_test`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `disjas_active_test`
--
ALTER TABLE `disjas_active_test`
  MODIFY `id_active_test` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
