<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['proid'];


$sqlquantity = "SELECT * FROM CART WHERE EMAIL = '$email'";

$resultq = $conn->query($sqlquantity);
if ($resultq->num_rows > 0) {
    $quantity = 0;
    while ($row = $resultq ->fetch_assoc()){
        $quantity = $row["CQUANTITY"] + $quantity;
    }
}

$sqlsearch = "SELECT * FROM CART WHERE EMAIL = '$email' AND PRODID= '$prodid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["CQUANTITY"];
    }
    $prquantity = $prquantity + 1;
    $sqlinsert = "UPDATE CART SET CQUANTITY = '$prquantity' WHERE PRODID = '$prodid' AND EMAIL = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO CART(EMAIL,PRODID,CQUANTITY) VALUES ('$email','$prodid','1')";
}

if ($conn->query($sqlinsert) === true)
{
    $quantity = $quantity +1;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>