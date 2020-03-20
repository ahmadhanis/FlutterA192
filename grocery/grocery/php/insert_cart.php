<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['proid'];
$price = $_POST['price'];
$quantity = $_POST['quantity'];
$prname = $_POST['prname'];



$sqlinsert = "INSERT INTO CART(EMAIL,PRODID,PRICE,QUANTITY,PRODNAME) VALUES ('$email','$prodid','$price','$quantity','$prname')";

if ($conn->query($sqlinsert) === true)
{
    echo "success";
    
}
else
{
    echo "failed";
}

?>