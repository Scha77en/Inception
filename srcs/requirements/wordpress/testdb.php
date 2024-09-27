<?php
$link = mysqli_connect("mariadb", "msquser", "123456", "wordpress");

if (!$link) {
    die('Could not connect: ' . mysqli_error($link));
}
echo 'Connected successfully';
mysqli_close($link);
?>
