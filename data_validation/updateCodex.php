<?php
	if(isset($_POST['codex']) && isset($_POST['str'])) {
        //Incoming Variables
        $codex_id = $_POST['codex']; 
        $text = $_POST['str'];
        //Replace \r\n in text otherwise it'll render extra spaces in the browser
        $text = str_replace("\n","<br>",$text);
        //$text = str_replace("\r\n",'', $text);
        $text = str_replace("\r",'', $text);
        $text = str_replace("\n",'', $text);
        //Escape any necessary characters
        $text = addslashes($text);
        
		//Create database connection
		require_once('./scripts/dbconnect.php');
        $sql = "UPDATE CODEXES SET CODEX_TEXT = '$text' WHERE CODEX_ID = $codex_id";
        //Insert into DB
        if ($db->query($sql) === TRUE){
            echo $_POST['str'];
        }
        else{
            echo "Error updating record: " . mysqli_error($db);
        }
		mysqli_close($db);
    }
    elseif (isset($_POST['id'])) {
    	$codex_id = $_POST['id'];
    	require_once('./scripts/dbconnect.php');
        $sql = "DELETE FROM CODEXES WHERE CODEX_ID = $codex_id";
        //Insert into DB
        if ($db->query($sql) === TRUE){
            echo "Success";
        }
        else{
            echo "Error deleting record: " . mysqli_error($db);
        }
		mysqli_close($db);

    }
?>