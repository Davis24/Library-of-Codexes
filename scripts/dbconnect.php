<?php
function db_connect() {

        // Define connection as a static variable, to avoid connecting more than once 
    static $db;

        // Try and connect to the database, if a connection has not been established yet
    if(!isset($db)) {
             // Load configuration as an array. Use the actual location of your configuration file
        $config = parse_ini_file('C:/xampp/htdocs/LibraryofCodexes/config.ini'); 
        $db = mysqli_connect($config['servername'],$config['username'],$config['password'],$config['dbname']);
    }

        // If connection was not successful, handle the error
    if($db === false) {
            // Handle error - notify administrator, log to a file, show an error screen, etc.
        return mysqli_connect_error(); 
    }
    return $db;
}

// Connect to the database
$db = db_connect();

// Check connection
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}
?> 