-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 11, 2025 at 04:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `e-commerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `line1` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `line1`, `city`, `country`, `user_id`, `created_at`, `updated_at`) VALUES
(2, '1234', 'Phnom Penhs', 'Cambodia', 8, '2025-07-09 17:22:40', '2025-07-09 17:22:40');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `stock_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `stock_id`, `created_at`, `updated_at`) VALUES
(5, 'Materials', 1, '2025-07-08 05:17:26', '2025-07-09 06:35:02');

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(255) NOT NULL,
  `discount_percentage` decimal(8,2) NOT NULL,
  `stock_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventories`
--

CREATE TABLE `inventories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `stock_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventories`
--

INSERT INTO `inventories` (`id`, `quantity`, `stock_id`, `product_id`, `created_at`, `updated_at`) VALUES
(8, 50, 1, 16, '2025-07-08 05:22:13', '2025-07-08 05:22:13'),
(10, 30, 1, 19, '2025-07-10 06:42:56', '2025-07-10 06:42:56');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2025_07_02_015647_create_notifications_table', 1),
(6, '2025_07_02_015700_create_stocks_table', 1),
(7, '2025_07_02_015714_create_categories_table', 1),
(8, '2025_07_02_015748_create_products_table', 1),
(9, '2025_07_02_015810_create_discounts_table', 1),
(10, '2025_07_02_015844_create_addresses_table', 1),
(11, '2025_07_02_015857_create_orders_table', 1),
(12, '2025_07_02_015914_create_order__items_table', 1),
(13, '2025_07_02_015932_create_priviews_table', 1),
(14, '2025_07_02_015952_create_suppliers_table', 1),
(15, '2025_07_02_020007_create_payments_table', 1),
(16, '2025_07_02_020025_create_inventories_table', 1),
(17, '2025_07_02_030000_add_role_to_users_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `address_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `total`, `user_id`, `address_id`, `created_at`, `updated_at`) VALUES
(3, 0.00, 8, 2, '2025-07-09 17:23:04', '2025-07-09 17:23:04'),
(10, 0.00, 8, 2, '2025-07-10 16:59:45', '2025-07-10 16:59:45'),
(11, 0.00, 8, 2, '2025-07-10 17:00:17', '2025-07-10 17:00:17'),
(12, 0.00, 8, 2, '2025-07-10 17:04:12', '2025-07-10 17:04:12'),
(13, 0.00, 8, 2, '2025-07-10 17:06:09', '2025-07-10 17:06:09'),
(14, 0.00, 8, 2, '2025-07-10 17:08:56', '2025-07-10 17:08:56'),
(15, 0.00, 8, 2, '2025-07-10 17:11:58', '2025-07-10 17:11:58'),
(16, 0.00, 8, 2, '2025-07-10 17:21:53', '2025-07-10 17:21:53'),
(17, 0.00, 8, 2, '2025-07-10 17:24:08', '2025-07-10 17:24:08'),
(18, 0.00, 8, 2, '2025-07-10 17:24:57', '2025-07-10 17:24:57'),
(19, 0.00, 8, 2, '2025-07-10 17:25:43', '2025-07-10 17:25:43'),
(20, 0.00, 8, 2, '2025-07-10 17:26:39', '2025-07-10 17:26:39'),
(21, 0.00, 8, 2, '2025-07-10 17:27:37', '2025-07-10 17:27:37'),
(22, 0.00, 8, 2, '2025-07-10 17:30:39', '2025-07-10 17:30:39'),
(23, 500.00, 8, 2, '2025-07-10 17:31:10', '2025-07-10 17:31:11'),
(24, 500.00, 8, 2, '2025-07-10 17:31:13', '2025-07-10 17:31:14'),
(25, 0.00, 8, 2, '2025-07-10 17:32:03', '2025-07-10 17:32:03'),
(26, 0.00, 8, 2, '2025-07-10 17:32:10', '2025-07-10 17:32:10'),
(27, 0.00, 8, 2, '2025-07-10 17:34:39', '2025-07-10 17:34:39'),
(28, 0.00, 8, 2, '2025-07-10 17:35:24', '2025-07-10 17:35:24'),
(29, 0.00, 8, 2, '2025-07-10 17:35:49', '2025-07-10 17:35:49');

-- --------------------------------------------------------

--
-- Table structure for table `order__items`
--

CREATE TABLE `order__items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order__items`
--

INSERT INTO `order__items` (`id`, `quantity`, `price`, `total`, `order_id`, `product_id`, `created_at`, `updated_at`) VALUES
(7, 10, 10.00, 100.00, 3, 19, '2025-07-09 17:23:37', '2025-07-09 17:23:37'),
(8, 1, 500.00, 500.00, 21, 16, '2025-07-10 17:27:38', '2025-07-10 17:27:38'),
(9, 1, 500.00, 500.00, 22, 16, '2025-07-10 17:30:39', '2025-07-10 17:30:39'),
(10, 1, 500.00, 500.00, 23, 16, '2025-07-10 17:31:11', '2025-07-10 17:31:11'),
(11, 1, 500.00, 500.00, 24, 16, '2025-07-10 17:31:14', '2025-07-10 17:31:14'),
(12, 1, 500.00, 500.00, 27, 16, '2025-07-10 17:34:40', '2025-07-10 17:34:40'),
(13, 1, 5.00, 5.00, 28, 16, '2025-07-10 17:35:24', '2025-07-10 17:35:24'),
(14, 2, 5.00, 10.00, 29, 16, '2025-07-10 17:35:49', '2025-07-10 17:35:49');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `amount`, `order_id`, `created_at`, `updated_at`) VALUES
(6, 100.00, 3, '2025-07-09 17:23:52', '2025-07-09 17:23:52');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 2, 'auth_token', 'b64a2e97be809e4c8b722a465e1a2b98e13736d0eeced6748b5022661d45ce9b', '[\"*\"]', NULL, NULL, '2025-07-08 04:53:25', '2025-07-08 04:53:25'),
(2, 'App\\Models\\User', 2, 'auth_token', '1e7de4380f68e8506219d9bb9da75ca79fe671860241ee37a1d48ddb0776a300', '[\"*\"]', NULL, NULL, '2025-07-08 04:54:16', '2025-07-08 04:54:16'),
(3, 'App\\Models\\User', 2, 'auth_token', '2981a12aece1fb8a6b64e9a9b61bf36854c35f4720b4bfbecf5f886c295438d9', '[\"*\"]', NULL, NULL, '2025-07-08 04:56:42', '2025-07-08 04:56:42'),
(4, 'App\\Models\\User', 2, 'auth_token', '5ee2d5ea46833e4f9a86d42f955e4e6a03a798ba2dece13150dbc81ddf921d56', '[\"*\"]', NULL, NULL, '2025-07-08 05:05:28', '2025-07-08 05:05:28'),
(5, 'App\\Models\\User', 3, 'auth_token', '62b2fe57033d6faa96c3302bc16ea48483ed87cd09ed79521f8759d1831356ef', '[\"*\"]', NULL, NULL, '2025-07-09 05:23:05', '2025-07-09 05:23:05'),
(6, 'App\\Models\\User', 3, 'auth_token', '323efd355d9dc2fe54c030a941732feee262af18f1edd572d056444a670c3848', '[\"*\"]', NULL, NULL, '2025-07-09 05:24:34', '2025-07-09 05:24:34'),
(7, 'App\\Models\\User', 3, 'auth_token', '725963946acdcbdd006208b73d9cd35cac4cad9932cf27e2b48870f21d408616', '[\"*\"]', NULL, NULL, '2025-07-09 05:25:10', '2025-07-09 05:25:10'),
(8, 'App\\Models\\User', 3, 'auth_token', '82af684b45cc99d3445e7be58bc34dcb7799eb6aa457bd7d8673c61bb02a3f9c', '[\"*\"]', NULL, NULL, '2025-07-09 05:31:04', '2025-07-09 05:31:04'),
(9, 'App\\Models\\User', 3, 'auth_token', 'd15aad50483f360319338705d75045a1cec0ee7fa467a2eb88c0f470e804244f', '[\"*\"]', NULL, NULL, '2025-07-09 06:02:02', '2025-07-09 06:02:02'),
(10, 'App\\Models\\User', 4, 'auth_token', 'fd10465f8c652c2b08f67568498b530ddacb04b4a30ef60c16aa0247a6af22d1', '[\"*\"]', NULL, NULL, '2025-07-09 06:07:26', '2025-07-09 06:07:26'),
(11, 'App\\Models\\User', 3, 'auth_token', '5aa186f7ff247530d0a547b6e052c7e68ef3b1ef9d6ff348eede4e03735b99f0', '[\"*\"]', NULL, NULL, '2025-07-09 06:08:19', '2025-07-09 06:08:19'),
(12, 'App\\Models\\User', 3, 'auth_token', '85b6efc4a4aae53a4c3712a02b15498c21392ebbc6c74d851a2747ce0b66b165', '[\"*\"]', NULL, NULL, '2025-07-09 06:13:12', '2025-07-09 06:13:12'),
(13, 'App\\Models\\User', 3, 'auth_token', '9177cc95e3110cb8db589f8467a6315b64ec16ef312ff4536f2fe48711d68fdf', '[\"*\"]', NULL, NULL, '2025-07-09 06:32:56', '2025-07-09 06:32:56'),
(14, 'App\\Models\\User', 5, 'auth_token', 'afcab7cdba99b46ed01b66b9cc3efcfccb432b619b2d9781cf980d791653eb68', '[\"*\"]', NULL, NULL, '2025-07-09 06:41:50', '2025-07-09 06:41:50'),
(15, 'App\\Models\\User', 3, 'auth_token', '864c79329fa4f0bfb9535e3dce8319570b7019c5b43c493a098a04aaaea1f188', '[\"*\"]', NULL, NULL, '2025-07-09 06:43:47', '2025-07-09 06:43:47'),
(16, 'App\\Models\\User', 6, 'auth_token', 'd259bcda86e44fef34b1c85859b3ca17856b76db055655719ba0eb86fda37467', '[\"*\"]', NULL, NULL, '2025-07-09 06:49:10', '2025-07-09 06:49:10'),
(17, 'App\\Models\\User', 3, 'auth_token', '3a3839a12de1f7722de90eec729bbbe1912b3fcc9ef21385519b593c6612694e', '[\"*\"]', NULL, NULL, '2025-07-09 06:49:31', '2025-07-09 06:49:31'),
(18, 'App\\Models\\User', 7, 'auth_token', 'e2c00aaf44f500ec48f48f9c58b2cdc5416b6c4bd2531ef6d1b5c8c1c7ac6bfa', '[\"*\"]', NULL, NULL, '2025-07-09 06:50:34', '2025-07-09 06:50:34'),
(19, 'App\\Models\\User', 3, 'auth_token', '33f82a149c00785ab921b31ede863dc5b12f8dbbecba7dcef4364134da005598', '[\"*\"]', NULL, NULL, '2025-07-09 17:03:51', '2025-07-09 17:03:51'),
(20, 'App\\Models\\User', 8, 'auth_token', '1a2f19bb12746b787fa369c244fa18a993b217daa6599274dc3f7025218be371', '[\"*\"]', NULL, NULL, '2025-07-09 17:14:02', '2025-07-09 17:14:02'),
(21, 'App\\Models\\User', 8, 'auth_token', 'ff9d9a9662f506c2a6a9171dde67ab2fe15d2080114f1fa0e95f2283277f5d51', '[\"*\"]', NULL, NULL, '2025-07-09 17:14:59', '2025-07-09 17:14:59'),
(22, 'App\\Models\\User', 3, 'auth_token', '8f7afa49d9aae0d0b48fb655968f7d10b3cfffef57eab19d3e369f0476ed1c7f', '[\"*\"]', NULL, NULL, '2025-07-09 17:17:39', '2025-07-09 17:17:39'),
(23, 'App\\Models\\User', 8, 'auth_token', '5c97ff8e49a1948bbe1369d1dc1f484685e9841e7e7899f1dfdcaabcf0a65ef9', '[\"*\"]', NULL, NULL, '2025-07-09 17:19:39', '2025-07-09 17:19:39'),
(24, 'App\\Models\\User', 3, 'auth_token', '05fbf4ada6dd0e3ed1d18e27bd8a29788d07c01a01c5c612087e21dbd10b3980', '[\"*\"]', NULL, NULL, '2025-07-09 17:24:58', '2025-07-09 17:24:58'),
(25, 'App\\Models\\User', 8, 'auth_token', 'c7ce6aa29074872a2b922aee27bdca7fd7f9ff945e0f4edb5a0e26d99bfa7a5b', '[\"*\"]', NULL, NULL, '2025-07-09 19:39:30', '2025-07-09 19:39:30'),
(26, 'App\\Models\\User', 3, 'auth_token', '41d530b7fc465256e3d25646dc87d955c7288db0d4d816b6828d37131b3f94e9', '[\"*\"]', NULL, NULL, '2025-07-09 19:46:29', '2025-07-09 19:46:29'),
(27, 'App\\Models\\User', 8, 'auth_token', 'c30417f1e677b2f0cd43d597e2312c3d2857f72feb6ed026403bc384acdcee77', '[\"*\"]', NULL, NULL, '2025-07-09 19:52:32', '2025-07-09 19:52:32'),
(28, 'App\\Models\\User', 8, 'auth_token', '8c93ec6de1644d7377d8385d81e9e052e6812fe59c05708f35521827fbcb04d5', '[\"*\"]', NULL, NULL, '2025-07-09 20:11:35', '2025-07-09 20:11:35'),
(29, 'App\\Models\\User', 8, 'auth_token', 'd08f605aa84a4bf0b3575fbdbd5c4783586a4252cc2daa016d7f41976f5e568b', '[\"*\"]', NULL, NULL, '2025-07-09 20:18:41', '2025-07-09 20:18:41'),
(30, 'App\\Models\\User', 8, 'auth_token', '38f84159f6a268977ded75b6967c992bdb8fd9d41fd323ff8ed52402ac8c8578', '[\"*\"]', NULL, NULL, '2025-07-09 20:19:22', '2025-07-09 20:19:22'),
(31, 'App\\Models\\User', 8, 'auth_token', '9ba837384b7a5793fe08b8846985adf8741516b11b66c88b4eeca2f0f9e44750', '[\"*\"]', NULL, NULL, '2025-07-09 20:19:42', '2025-07-09 20:19:42'),
(32, 'App\\Models\\User', 3, 'auth_token', '7bb016b794ff5d2e13733c1dbd7690fb1f36086ebc6e5e149ab2cc21c5153a88', '[\"*\"]', NULL, NULL, '2025-07-09 20:29:10', '2025-07-09 20:29:10'),
(33, 'App\\Models\\User', 8, 'auth_token', '628a8f04042a119cf2848887906b6013d20048dc070b549cb555b4c7cfc56b4d', '[\"*\"]', NULL, NULL, '2025-07-09 20:29:24', '2025-07-09 20:29:24'),
(34, 'App\\Models\\User', 3, 'auth_token', '1b9731b52950396a8ad72d640763a534f6f61c5a8d060e8a5b3ef96e6a3be4c4', '[\"*\"]', NULL, NULL, '2025-07-09 20:34:54', '2025-07-09 20:34:54'),
(35, 'App\\Models\\User', 8, 'auth_token', '9823727a485061bcac73f8172d76933c63aa3338a55d753cd6341de6726b83ee', '[\"*\"]', NULL, NULL, '2025-07-09 21:02:59', '2025-07-09 21:02:59'),
(36, 'App\\Models\\User', 3, 'auth_token', '0692a37317ca66d90747126d6fc6958e0bbdfd57b670a65d55485a1e847d236f', '[\"*\"]', NULL, NULL, '2025-07-09 21:03:27', '2025-07-09 21:03:27'),
(37, 'App\\Models\\User', 3, 'auth_token', '9cdd6405a4d09a06dc14c7843ed7151083bd8648c0a9ddb0075b16b0da26ad1d', '[\"*\"]', NULL, NULL, '2025-07-09 21:04:55', '2025-07-09 21:04:55'),
(38, 'App\\Models\\User', 8, 'auth_token', '1116f02970e5d400da59c93f335b3aa9ec657254c0572b35d7436fdf0cf91996', '[\"*\"]', NULL, NULL, '2025-07-09 21:09:21', '2025-07-09 21:09:21'),
(39, 'App\\Models\\User', 3, 'auth_token', '9a0772a4959735321bfdfaaa268db24c8ccb87c8c17aace34976d5e19c0295b1', '[\"*\"]', NULL, NULL, '2025-07-09 21:12:51', '2025-07-09 21:12:51'),
(40, 'App\\Models\\User', 8, 'auth_token', 'e45bf884c351369f96c23eb81ad1be692a3705a3b0d7985be4cf996b895a171e', '[\"*\"]', NULL, NULL, '2025-07-09 21:21:53', '2025-07-09 21:21:53'),
(41, 'App\\Models\\User', 8, 'auth_token', 'd6f97f572a37dba4c89dc6a1de62f573598190c1959a973cb387467760b3dfb2', '[\"*\"]', NULL, NULL, '2025-07-09 21:43:21', '2025-07-09 21:43:21'),
(42, 'App\\Models\\User', 3, 'auth_token', '6a3753196229750e8724d029f6611335060ddf5d0a9b80e07d977ecd7843ecdd', '[\"*\"]', NULL, NULL, '2025-07-09 21:56:08', '2025-07-09 21:56:08'),
(43, 'App\\Models\\User', 8, 'auth_token', 'd80ab7028120d3a7c7f86ae7f9c3c632204a6c796e3838b5e7d4915864592109', '[\"*\"]', NULL, NULL, '2025-07-09 21:56:54', '2025-07-09 21:56:54'),
(44, 'App\\Models\\User', 3, 'auth_token', '79a85643089194e2b24ec1dc70f1e9349326894ce78eef01a702df5e46e2b696', '[\"*\"]', NULL, NULL, '2025-07-09 22:18:25', '2025-07-09 22:18:25'),
(45, 'App\\Models\\User', 8, 'auth_token', 'a6d9cb721b111b22a5daca29d66b38dfb1455f77f256cfc38b8ac91a3a3718cd', '[\"*\"]', NULL, NULL, '2025-07-09 22:31:26', '2025-07-09 22:31:26'),
(46, 'App\\Models\\User', 3, 'auth_token', '9b8d409e14e768b2558ea218598051ac31ea76286c4b6058e2ec0145b9bd4bce', '[\"*\"]', NULL, NULL, '2025-07-09 22:32:28', '2025-07-09 22:32:28'),
(47, 'App\\Models\\User', 8, 'auth_token', 'ea616f1b74dbb5364aab922409f6d61662af5228c4ad0d28b41ba186c7ad65dc', '[\"*\"]', NULL, NULL, '2025-07-09 22:33:01', '2025-07-09 22:33:01'),
(48, 'App\\Models\\User', 3, 'auth_token', 'b7b111e6fe2944e61606d955eda4afc5cea7e8dfe58a7b5cc7ebd78c271b2ccf', '[\"*\"]', NULL, NULL, '2025-07-09 22:39:38', '2025-07-09 22:39:38'),
(49, 'App\\Models\\User', 8, 'auth_token', 'febbf89465f56ea7e130a8aea46dd38d012477b4f25f3ec1c396eabe184802e0', '[\"*\"]', NULL, NULL, '2025-07-09 22:40:05', '2025-07-09 22:40:05'),
(50, 'App\\Models\\User', 3, 'auth_token', 'c9573a20a43e4d45801c0088a348ea8f5ab21cb1e59f49972b2eec449af8c17d', '[\"*\"]', NULL, NULL, '2025-07-09 22:40:35', '2025-07-09 22:40:35'),
(51, 'App\\Models\\User', 3, 'auth_token', 'b335453bb786dc21fdb8d8b3a97f2546ec7001f9405bd9b2e9f73c983c1302d4', '[\"*\"]', NULL, NULL, '2025-07-09 22:44:45', '2025-07-09 22:44:45'),
(52, 'App\\Models\\User', 3, 'auth_token', 'c5850bfc197610df391d31ac94e921032323c08a7fed8488dad300d47652460e', '[\"*\"]', NULL, NULL, '2025-07-09 22:48:34', '2025-07-09 22:48:34'),
(53, 'App\\Models\\User', 8, 'auth_token', '252d641bcb609c10ceff8655ee9a722bef1b73d0919d8bc09dea35b4da11f806', '[\"*\"]', NULL, NULL, '2025-07-09 22:49:27', '2025-07-09 22:49:27'),
(54, 'App\\Models\\User', 8, 'auth_token', '51832489a2284b43ac579e7b28957f09813e04c3b4b7c220848f812e1e7fadd2', '[\"*\"]', NULL, NULL, '2025-07-10 06:06:08', '2025-07-10 06:06:08'),
(55, 'App\\Models\\User', 3, 'auth_token', '3999b0059533e72f1d852877459eb9e09991edc0facac21554c93279b4a0491f', '[\"*\"]', NULL, NULL, '2025-07-10 06:06:58', '2025-07-10 06:06:58'),
(56, 'App\\Models\\User', 8, 'auth_token', '0c995fc6598fa12de3bc6dc62cdeba679f89ce66c30d2c953e034b6138182916', '[\"*\"]', NULL, NULL, '2025-07-10 06:09:01', '2025-07-10 06:09:01'),
(57, 'App\\Models\\User', 8, 'auth_token', '91a60319d007300503f046f632f73bbdfb8156632a955a725d1d676f3065ace6', '[\"*\"]', NULL, NULL, '2025-07-10 06:11:29', '2025-07-10 06:11:29'),
(58, 'App\\Models\\User', 3, 'auth_token', 'e1f76558a5ecae58575d2e142fbc41adbe7e9dedc1dc26381812ff2f7b20f2f0', '[\"*\"]', NULL, NULL, '2025-07-10 06:12:37', '2025-07-10 06:12:37'),
(59, 'App\\Models\\User', 8, 'auth_token', '1f5e3c1447db89f75d4c40b31fefd0714ad9d44f749c95fa95fe1ec6b3dc7ff9', '[\"*\"]', NULL, NULL, '2025-07-10 06:14:55', '2025-07-10 06:14:55'),
(60, 'App\\Models\\User', 3, 'auth_token', 'fab68190585da160644c4fd3651c5d3bfd4020798610be770d8b5d4245861fc9', '[\"*\"]', NULL, NULL, '2025-07-10 06:15:47', '2025-07-10 06:15:47'),
(61, 'App\\Models\\User', 8, 'auth_token', '2305af74b5ecab2630bf8b4e4112f6e565a8ce429470dd1309b676a09da8df4f', '[\"*\"]', NULL, NULL, '2025-07-10 06:25:37', '2025-07-10 06:25:37'),
(62, 'App\\Models\\User', 3, 'auth_token', '03752b000e52f3ac16507db26f640214d923c409b7c258656bef0c2b3492118b', '[\"*\"]', NULL, NULL, '2025-07-10 06:28:33', '2025-07-10 06:28:33'),
(63, 'App\\Models\\User', 8, 'auth_token', '408631c95db99750c9314a1a717975a2a0f4f96d2920d9a47d98369fc785efdd', '[\"*\"]', NULL, NULL, '2025-07-10 06:29:45', '2025-07-10 06:29:45'),
(64, 'App\\Models\\User', 3, 'auth_token', 'ece3b0f9f3522080f6515644ffc4dbad92d4fc3281a960e92c4e288998506a5a', '[\"*\"]', NULL, NULL, '2025-07-10 06:30:23', '2025-07-10 06:30:23'),
(65, 'App\\Models\\User', 8, 'auth_token', 'b007035cfaf241c4c7b640b59568fbfe8242f89bd665eee400153a99c4351cee', '[\"*\"]', NULL, NULL, '2025-07-10 06:33:50', '2025-07-10 06:33:50'),
(66, 'App\\Models\\User', 3, 'auth_token', 'c098ca228066655fb75b813f9e16a6b33ac5365b0e33d5b378eacfec5b28be91', '[\"*\"]', NULL, NULL, '2025-07-10 06:45:32', '2025-07-10 06:45:32'),
(67, 'App\\Models\\User', 8, 'auth_token', 'c62e1309205d35df7ac349dca11393268d3a589300440a0e4bc3faef5f60683d', '[\"*\"]', NULL, NULL, '2025-07-10 06:46:29', '2025-07-10 06:46:29'),
(68, 'App\\Models\\User', 3, 'auth_token', '8f288100b7a2f6315ad0a59ee26dc71153931eadfcfe14ccbb09ce37cfd85614', '[\"*\"]', NULL, NULL, '2025-07-10 06:54:17', '2025-07-10 06:54:17'),
(69, 'App\\Models\\User', 8, 'auth_token', '5984459ad294bf65b33faafee3a69d0b16d85821fd7e7609a9b5faedb2d2a3b8', '[\"*\"]', NULL, NULL, '2025-07-10 16:50:40', '2025-07-10 16:50:40'),
(70, 'App\\Models\\User', 3, 'auth_token', '189f4cafcb6d515a95bde4884a0ef701c156bb12ad486cac5f6b414d2a00d8a4', '[\"*\"]', NULL, NULL, '2025-07-10 16:51:31', '2025-07-10 16:51:31'),
(71, 'App\\Models\\User', 8, 'auth_token', '18818ae145bf13353810984f032f7394d8c71f311df6ad7d9514cb28571f7918', '[\"*\"]', NULL, NULL, '2025-07-10 17:01:10', '2025-07-10 17:01:10'),
(72, 'App\\Models\\User', 3, 'auth_token', 'c8cf130a804a7b0ba01c1ea1866c73d87c84bc6a6db2d06375af86a842cb8074', '[\"*\"]', NULL, NULL, '2025-07-10 17:04:07', '2025-07-10 17:04:07'),
(73, 'App\\Models\\User', 8, 'auth_token', 'cba846adb5a4e1e0225983c0a522ac1d8295d89b64819d34ab8627c1d7602f4f', '[\"*\"]', NULL, NULL, '2025-07-10 17:04:41', '2025-07-10 17:04:41'),
(74, 'App\\Models\\User', 8, 'auth_token', '6b9a13a5d3a6e8a2b12ff75f50f4925b8a788abf4fe6a43feada261329d9703d', '[\"*\"]', NULL, NULL, '2025-07-10 18:15:57', '2025-07-10 18:15:57'),
(75, 'App\\Models\\User', 3, 'auth_token', 'e897aa3f384ae580aacd63a74e23da4aa5c8f88f1bb9b1e85dde87cfca7482cf', '[\"*\"]', NULL, NULL, '2025-07-10 18:16:23', '2025-07-10 18:16:23'),
(76, 'App\\Models\\User', 3, 'auth_token', 'ae39c044dd6a273fc2a0b8bb516c6a5ab71e96e83e2c2d9f70c8b7b7481a412b', '[\"*\"]', NULL, NULL, '2025-07-10 18:57:14', '2025-07-10 18:57:14'),
(77, 'App\\Models\\User', 3, 'auth_token', 'd33c9650e8908927af7c6c4606b665b0da6b6a78e4ef4666253d84f9174a6fe6', '[\"*\"]', NULL, NULL, '2025-07-10 19:21:11', '2025-07-10 19:21:11'),
(78, 'App\\Models\\User', 8, 'auth_token', 'c837cde3b0fea343dca73a1461fe5c4a8b2d961f8f8ac73531a8f3e0adec6e4c', '[\"*\"]', NULL, NULL, '2025-07-10 19:23:04', '2025-07-10 19:23:04'),
(79, 'App\\Models\\User', 9, 'auth_token', '40be4e995038935bbd15e4bbc272d62af33059256f65145d6e428accdd88989e', '[\"*\"]', NULL, NULL, '2025-07-10 19:35:58', '2025-07-10 19:35:58');

-- --------------------------------------------------------

--
-- Table structure for table `priviews`
--

CREATE TABLE `priviews` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `image` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `image`, `description`, `category_id`, `created_at`, `updated_at`) VALUES
(16, 'Swimming-polo', 5.00, 'products/GOWMAdNAIsrJacIn7vNDUafKwErdkYiHTNoPpYfK.jpg', 'Use for store water', 5, '2025-07-08 05:20:48', '2025-07-08 05:20:48'),
(19, 'Port water', 10.00, 'products/Zpg76ztR9rCTzpVQ5W6xrt41ogJSlepNENiyxHMo.jpg', 'You can use it for set to good water.', 5, '2025-07-09 17:05:07', '2025-07-10 06:15:21'),
(20, 'Romane', 5.00, 'products/PYJZQh5G8jayzm4jIPN7ZGPO3ijeg8lEnRqQlIM9.jpg', 'You can help people for store water.', 5, '2025-07-10 06:28:12', '2025-07-10 06:28:12'),
(21, 'Water clean', 30.00, 'products/a3zoFikJAcKaGjMI3SRwns2Ovuhs82FvIKidx50L.jpg', 'You can buy now.', 5, '2025-07-10 06:31:10', '2025-07-10 06:31:10');

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `name`, `quantity`, `created_at`, `updated_at`) VALUES
(1, 'All products', 50, '2025-07-04 04:55:02', '2025-07-09 05:03:10');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `contact_info` varchar(255) NOT NULL,
  `address_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'user',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(3, 'Aurora Stephenson', 'yong@yong12gamil.com', 'user', NULL, '$2y$12$Ud4/DOwFDZB/klfH50dy/uePkOOO3xQs55hl.pcMZElEqMNStDUUu', NULL, '2025-07-09 05:23:05', '2025-07-09 05:23:05'),
(8, 'Kin  Doung', 'kin@doung12gmail.com', 'admin', NULL, '$2y$12$63zpQ7R.jhz/7Naokl664e0VizUWORCJRM2Fi5hMuyKC5sqHWGzje', NULL, '2025-07-09 17:14:02', '2025-07-09 19:40:06'),
(9, 'Erasmus Mendez', 'hehe@mailinator.com', 'user', NULL, '$2y$12$KoOJjWUX24VpNq7JYPqnXulEsoqXbeCts2E6tcli4OXNY4OToWGQK', NULL, '2025-07-10 19:35:58', '2025-07-10 19:35:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_user_id_foreign` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_stock_id_foreign` (`stock_id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `discounts_stock_id_foreign` (`stock_id`),
  ADD KEY `discounts_product_id_foreign` (`product_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `inventories`
--
ALTER TABLE `inventories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventories_stock_id_foreign` (`stock_id`),
  ADD KEY `inventories_product_id_foreign` (`product_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`),
  ADD KEY `orders_address_id_foreign` (`address_id`);

--
-- Indexes for table `order__items`
--
ALTER TABLE `order__items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order__items_order_id_foreign` (`order_id`),
  ADD KEY `order__items_product_id_foreign` (`product_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_order_id_foreign` (`order_id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `priviews`
--
ALTER TABLE `priviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `priviews_user_id_foreign` (`user_id`),
  ADD KEY `priviews_product_id_foreign` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_category_id_foreign` (`category_id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `suppliers_address_id_foreign` (`address_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `discounts`
--
ALTER TABLE `discounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventories`
--
ALTER TABLE `inventories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `order__items`
--
ALTER TABLE `order__items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `priviews`
--
ALTER TABLE `priviews`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_stock_id_foreign` FOREIGN KEY (`stock_id`) REFERENCES `stocks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `discounts`
--
ALTER TABLE `discounts`
  ADD CONSTRAINT `discounts_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `discounts_stock_id_foreign` FOREIGN KEY (`stock_id`) REFERENCES `stocks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventories`
--
ALTER TABLE `inventories`
  ADD CONSTRAINT `inventories_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventories_stock_id_foreign` FOREIGN KEY (`stock_id`) REFERENCES `stocks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_address_id_foreign` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order__items`
--
ALTER TABLE `order__items`
  ADD CONSTRAINT `order__items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order__items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `priviews`
--
ALTER TABLE `priviews`
  ADD CONSTRAINT `priviews_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `priviews_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD CONSTRAINT `suppliers_address_id_foreign` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
