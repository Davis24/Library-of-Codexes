<?php
	if(isset($_POST['game'])) {
		$game_id = $_POST['game']; //Incoming Variable
		//Create database connection
		$config = parse_ini_file('config.ini');
		$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
		if(!$db) {
			echo "error occured, put in an error page";
		}
		$row = $db->query("SELECT GAME_TITLE, GAME_DESCRIPTION FROM GAMES WHERE GAME_ID = ('".$game_id."')")->fetch_assoc();
		mysqli_close($db);
		//Display game title, link to ebooks, and description
		$game_title = $row['GAME_TITLE'];
		$game_temp = preg_replace("![^a-z0-9]+!i", "-", $row["GAME_TITLE"]);
		echo '<h1><b><a href="/library-of-codexes/game='.$game_id.'/'.$game_temp.'">'.$game_title.'<i class="fa fa-angle-double-right" aria-hidden="true"></i></a></b></h1><h3><a href="files/azw3/'.$game_temp.'.azw3">AZW3</a> · <a href="files/epub/'.$game_temp.'.epub">EPUB</a> · <a href="files/pdf/'.$game_temp.'.pdf">PDF</a></h3><p>'.$row["GAME_DESCRIPTION"].'</p>';
}  ?>