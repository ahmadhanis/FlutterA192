<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$oldpassword = $_POST["oldpassword"];
$newpassword = $_POST["newpassword"];

$oldpass = sha1($oldpassword);
$newpass = sha1($newpassword);

if (isset($encoded_string)){
    $path = '../profile/'.$phone.'.jpg';
    file_put_contents($path, $decoded_string);
    echo 'success';
}

if (isset($name)){
    $nama = ucwords($name);
    $sqlupdatename = "UPDATE USER SET NAME = '$name' WHERE EMAIL = '$email'";
    if ($conn->query($sqlupdatename)){
        echo 'success';    
    }else{
        echo 'success';
    }
    
}

if (isset($oldpassword) && isset($newpassword)){
    $sql = "SELECT * FROM USER WHERE EMAIL = '$email' AND PASSWORD = '$oldpass'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $sqlupdatepass = "UPDATE USER SET PASSWORD = '$newpass' WHERE EMAIL = '$email'";
        $conn->query($sqlupdatepass);
        echo 'success';
        
    }else{
        echo 'failed';
    }
    
}


if (isset($phone)){
    $sqlupdatepass = "UPDATE USER SET PHONE = '$phone' WHERE EMAIL = '$email'";
    if($conn->query($sqlupdatepass)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}



$conn->close();
?>