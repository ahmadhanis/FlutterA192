<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);

    $sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE) VALUES ('$name','$email','$password','$phone')";
    if ($conn->query($sqlinsert) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
    
//http://slumberjer.com/grocery/php/register_user.php?name=Ahmad%20Hanis&email=slumberjer@gmail.com&phone=01949494959&password=123456
?>