<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
//$status = "notpaid";

if (isset($email)){
   $sql = "SELECT PRODUCT.ID, PRODUCT.NAME, PRODUCT.PRICE, PRODUCT.QUANTITY, PRODUCT.WEIGHT, CART.CQUANTITY FROM PRODUCT INNER JOIN CART ON CART.PRODID = PRODUCT.ID WHERE CART.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["price"] = $row["PRICE"];
        $cartlist["quantity"] = $row["QUANTITY"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
         $cartlist["weight"] = $row["WEIGHT"];
        $cartlist["yourprice"] = round(doubleval($row["PRICE"])*(doubleval($row["CQUANTITY"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
