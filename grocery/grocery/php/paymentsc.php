<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 $sqlcart ="SELECT CART.PRODID, CART.CQUANTITY, PRODUCT.PRICE FROM CART INNER JOIN PRODUCT ON CART.PRODID = PRODUCT.ID WHERE CART.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $prodid = $row["PRODID"];
            $cq = $row["CQUANTITY"]; //cart qty
            $pr = $row["PRICE"];
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,ORDERID,BILLID,PRODID,CQUANTITY,PRICE) VALUES ('$userid','$orderid','$receiptid','$prodid','$cq','$pr')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM PRODUCT WHERE ID = '$prodid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["QUANTITY"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE PRODUCT SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$prodid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET CREDIT = '$newcr' WHERE EMAIL = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>