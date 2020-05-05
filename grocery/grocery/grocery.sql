-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 05, 2020 at 09:25 PM
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
  `CQUANTITY` varchar(10) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CART`
--

INSERT INTO `CART` (`EMAIL`, `PRODID`, `CQUANTITY`) VALUES
('slumberjer@gmail.com', '1017', '2'),
('slumberjer@gmail.com', '1004', '3'),
('hahahaha', '1024', '1'),
('jane356@gmail.com', '1003', '1'),
('slumberjer@gmail.com', '1015', '2');

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
('1014', 'Cabbage', '1.70', '200', '1000', 'Vegetable', '2020-03-15 07:51:45.212246'),
('1015', 'Ikan Kembong Temenung', '4.00', '100', '1000', 'Meat', '2020-03-21 15:48:09.109094'),
('1016', 'Siakap', '12.00', '20', '1000', 'Meat', '2020-03-21 15:52:49.094250'),
('1017', 'Chicken Drumstick', '12', '20', '1000', 'Meat', '2020-03-21 15:54:42.180187'),
('1018', 'Aussie Chilled Beef Cube', '20.00', '20', '400', 'Meat', '2020-03-21 15:56:38.039000'),
('1019', 'Mighty White Natural White', '2.90', '20', '550', 'Bread', '2020-03-21 16:15:43.296491'),
('1020', 'Fuji Bakery Banana Cake', '6.00', '20', '600', 'Bread', '2020-03-21 16:05:47.133000'),
('1021', 'Gardenia Delicia Chocolate', '0.90', '40', '50', 'Bread', '2020-03-21 15:07:34.055000'),
('1022', 'Gardenia Twiggies Vanilla', '1.60', '20', '80', 'Bread', '2020-03-21 16:10:51.055000'),
('1023', 'Eva Strawberry Mixed Fruit', '5.6', '20', '450', 'Canned Food', '2020-03-21 16:13:06.000000'),
('1024', 'Qplus Large Farm Fresh Egg', '2.70', '40', '450', 'Meat', '2020-03-21 16:14:23.000000'),
('1025', 'Coca-Cola Coke Zero 1.5L', '3.00', '20', '200', 'Drink', '2020-03-21 16:14:56.000000'),
('1026', '100 Plus Original Isotonic', '3.00', '20', '250', 'Drink', '2020-03-21 16:17:21.000000');

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
('Ahmad Hanis', 'slumberjer@gmail.com', '0194702493', 'dd5fef9c1c1da1394d6d34b248c51be2ad740840', '10', '1', '2020-03-12'),
('hahahaha', 'hahahaha', '12', '2e3c0feeabaeb595f91f6dcc1639939ea012c490', '0', '1', '2020-05-04'),
('jane', 'jane356@gmail.com', '0112345234', '07041c3f30e153a3dc06a5a3293128e3e62d76f8', '0', '1', '2020-05-04');

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
