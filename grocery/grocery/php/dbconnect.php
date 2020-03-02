<?php
$servername = "localhost";
$username   = "usernamehere";
$password   = "passwordhere";
$dbname     = "dbnamehere";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>