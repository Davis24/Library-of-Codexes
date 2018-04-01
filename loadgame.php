<?php
	if(isset($_POST['ebook'])) {
		$ebook_id = $_POST['ebook']; //Incoming Variable
		//Create database connection
		require_once('./scripts/dbconnect.php');
		$row = $db->query("SELECT TITLE, EBOOK_DESCRIPTION FROM ebooks WHERE REPLACE(REPLACE(TITLE,'\'', ''), ':', '') = ('".$ebook_id."')")->fetch_assoc();
		mysqli_close($db);
		//Display game title, link to ebooks, and description
		echo $row["EBOOK_DESCRIPTION"];

	}  
?>