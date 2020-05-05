<?php
$servername = "localhost";
$username   = "";
$password   = "";
$dbname     = "slumber6_grocery";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>