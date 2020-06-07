<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM CART WHERE EMAIL = '$email'";    
$quan = 0;
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
      $quan = $quan + $row["CQUANTITY"];
    }
    echo  $quan;
}
else
{
    echo "nodata";
}
?>
