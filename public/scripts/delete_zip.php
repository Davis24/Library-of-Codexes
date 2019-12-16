<?php
    $fullpath = "/home/devimeg30/libraryofcodexes.com/public/downloads/";
    array_map('unlink', glob("$fullpath*.zip"));
?>
