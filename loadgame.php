<?php
	if(isset($_POST['game'])) {
		$game_id = $_POST['game']; //Incoming Variable
		//Create database connection
		require_once('./scripts/dbconnect.php');
		$row = $db->query("SELECT GAME_TITLE, GAME_DESCRIPTION FROM games WHERE GAME_ID = ('".$game_id."')")->fetch_assoc();
		mysqli_close($db);
		//Display game title, link to ebooks, and description
		$game_title = $row['GAME_TITLE'];
		$game_temp = preg_replace("![^a-z0-9]+!i", "-", $row["GAME_TITLE"]);
		$game_file = str_replace(" ", "%20", preg_replace("![^a-z0-9\s]+!i", "", $row["GAME_TITLE"]));
		echo '<h1><b><a href="/game='.$game_id.'/'.$game_temp.'">'.$game_title.'<i class="fa fa-angle-double-right" aria-hidden="true"></i></a></b></h1><h3><a href="files/'.$game_file.'/'.$game_file.'.azw3">AZW3</a> · <a href="files/'.$game_file.'/'.$game_file.'.epub">EPUB</a> · <a href="files/'.$game_file.'/'.$game_file.'.pdf">PDF</a></h3><p>'.$row["GAME_DESCRIPTION"].'</p>';
}  ?>