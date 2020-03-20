-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 20, 2020 at 11:50 PM
-- Server version: 10.3.22-MariaDB-cll-lve
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `slumber6_grocery`
--

-- --------------------------------------------------------

--
-- Table structure for table `CART`
--

CREATE TABLE `CART` (
  `EMAIL` varchar(50) NOT NULL,
  `PRODID` varchar(20) NOT NULL,
  `PRICE` varchar(10) NOT NULL,
  `QUANTITY` varchar(10) NOT NULL,
  `PRODNAME` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CART`
--

INSERT INTO `CART` (`EMAIL`, `PRODID`, `PRICE`, `QUANTITY`, `PRODNAME`) VALUES
('slumberjer@gmail.com', '1001', '51.6', '4', 'Nescafe Blend & Brew Original 3 in 1'),
('slumberjer@gmail.com', '1003', '80.5', '7', 'Ah Huat White Coffee'),
('slumberjer@gmail.com', '1005', '39.8', '2', 'Power Root Alicafe 5 in 1 Tongkat Ali & Ginseng Premix Coffee '),
('slumberjer@gmail.com', '1006', '9.8', '2', 'Penguin Lychees');

-- --------------------------------------------------------

--
-- Table structure for table `PRODUCT`
--

CREATE TABLE `PRODUCT` (
  `ID` varchar(10) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `PRICE` varchar(10) NOT NULL,
  `QUANTITY` varchar(10) NOT NULL,
  `WEIGHT` varchar(10) NOT NULL,
  `TYPE` varchar(20) NOT NULL,
  `DATE` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `PRODUCT`
--

INSERT INTO `PRODUCT` (`ID`, `NAME`, `PRICE`, `QUANTITY`, `WEIGHT`, `TYPE`, `DATE`) VALUES
('1001', 'Nescafe Blend & Brew Original 3 in 1', '12.90', '50', '450', 'Drink', '2020-03-15 07:51:45.212246'),
('1002', 'Hang Tuah Kopi-O 2', '8.80', '40', '500', 'Drink', '2020-03-15 07:51:45.212246'),
('1003', 'Ah Huat White Coffee', '11.50', '50', '450', 'Drink', '2020-03-15 07:51:45.212246'),
('1004', 'PappaRich 3 in 1 White Coffee Original', '13.40', '50', '360', 'Drink', '2020-03-15 07:51:45.212246'),
('1005', 'Power Root Alicafe 5 in 1 Tongkat Ali & Ginseng Premix Coffee ', '19.90', '50', '600', 'Drink', '2020-03-15 07:51:45.212246'),
('1006', 'Penguin Lychees', '4.90', '50', '570', 'Canned Food', '2020-03-15 07:51:45.212246'),
('1007', 'Hosen Mandarin Oranges in Syrup', '3.60', '40', '312', 'Canned Food', '2020-03-15 07:51:45.212246'),
('1008', 'Campbell\'s Cream of Mushroom', '5.40', '30', '420', 'Canned Food', '2020-03-15 07:51:45.212246'),
('1009', 'Tesco Italian Chopped Tomatoes in Rich Tomato', '3.70', '50', '400', 'Canned Food', '2020-03-15 07:51:45.212246'),
('1010', 'Adabi Sweet Kernel Corn', '3.00', '30', '425', 'Canned Food', '2020-03-15 07:51:45.212246'),
('1011', 'Grade 1 Carrots', '1.30', '100', '1000', 'Vegetable', '2020-03-15 07:51:45.212246'),
('1012', 'Large Onion', '6.50', '100', '1000', 'Vegetable', '2020-03-15 07:51:45.212246'),
('1013', 'Potatoes', '2.60', '100', '1000', 'Vegetable', '2020-03-15 07:51:45.212246'),
('1014', 'Cabbage', '1.70', '200', '1000', 'Vegetable', '2020-03-15 07:51:45.212246');

-- --------------------------------------------------------

--
-- Table structure for table `USER`
--

CREATE TABLE `USER` (
  `NAME` varchar(50) NOT NULL,
  `EMAIL` varchar(50) NOT NULL,
  `PHONE` varchar(12) NOT NULL,
  `PASSWORD` varchar(60) NOT NULL,
  `CREDIT` varchar(5) NOT NULL,
  `VERIFY` varchar(1) NOT NULL,
  `DATEREG` date NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `USER`
--

INSERT INTO `USER` (`NAME`, `EMAIL`, `PHONE`, `PASSWORD`, `CREDIT`, `VERIFY`, `DATEREG`) VALUES
('test', 'test@gmail.com', '0123456789', 'e0458fa47f4bb956174fda2b4f1d377e87ceb94f', '0', '1', '2020-03-12'),
('', '', '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '0', '1', '2020-03-12'),
('erf', 'ef', '2345', '81fe8bfe87576c3ecb22426f8e57847382917acf', '0', '1', '2020-03-13'),
('Grocery Max', 'max@gmali.com', '012345610', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0', '1', '2020-03-13'),
('g', 'fgfghgh', '2445345', 'f292f45093a9af6635a5992bae7680d4c18fbd53', '0', '1', '2020-03-14'),
('gan', 'qw', '12345', '8cb2237d0679ca88db6464eac60da96345513964', '0', '1', '2020-03-14'),
('Aiden', 'aidenleong98@gmail.com', '0169324212', '8a27c1095b70092fe84b679300fd54a205f80dec', '0', '1', '2020-03-15'),
('Shukur	', 'mohdshukur98f@icloud.com	', '0125090254', 'b4e6259fb9767b468f00b56e2246e106bf5d6ef9', '0', '1', '2020-03-15');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `PRODUCT`
--
ALTER TABLE `PRODUCT`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `USER`
--
ALTER TABLE `USER`
  ADD PRIMARY KEY (`EMAIL`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
