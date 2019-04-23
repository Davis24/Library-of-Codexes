<?php
    $fullpath = "../downloads/";
    array_map('unlink', glob("$fullpath*.zip"));
?>
