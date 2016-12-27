<?php
	if(isset($_POST['type']))	{
    //Incoming Variables
		$type = $_POST['type'];
		$game_id = $_POST['game_id'];
		//Database Connection
		$config = parse_ini_file('config.ini');
		$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
		if($db === false)	{
			echo "error occured, put in an error page";
		}

		if("Authors" == $type)
		{
			echo '<table id="game_table" class="display" width="100%" cellspacing="0">
        	  <thead><tr><th>Author</th><th>Biography</th></tr></thead><tbody>';
			$query = "SELECT BIOGRAPHY, CONCAT(FIRST_NAME, ' ', LAST_NAME) as Name, AUTHOR_ID FROM authors WHERE FK_GAME_ID = ('".$game_id."')";
	    if($result = $db->query($query)) {
        while($row = $result ->fetch_assoc()) {
          $author_temp = trim($row["Name"]);
          $author_temp = preg_replace("![^a-z0-9]+!i", "-", $author_temp);
          echo "<tr><td><a href='/library-of-codexes/author=".$row["AUTHOR_ID"]."/".$author_temp."'>".$row["Name"] ."</a></td>";
          echo "<td><a href='/library-of-codexes/author=".$row["AUTHOR_ID"]."/".$author_temp."'>".$row["BIOGRAPHY"]."</a></td></tr>"; 
        }
      }
      mysqli_close($db);		     
      echo '</tbody></table>';
		}
		elseif ("Codexes" == $type) {
			echo '<table id="game_table" class="display" width="100%" cellspacing="0">
            <thead><tr><th>Title</th><th>Author</th></tr></thead><tbody>';
      $query = "SELECT CODEX_TITLE, CONCAT(authors.FIRST_NAME, ' ', authors.LAST_NAME) as Name, FK_AUTHOR_ID, CODEX_ID 
                FROM codexes INNER JOIN authors ON codexes.FK_AUTHOR_ID = authors.AUTHOR_ID 
                WHERE codexes.FK_GAME_ID = ('".$game_id."')";
      if($result = $db->query($query)) {
        while($row = $result ->fetch_assoc()) {
          $codex_temp = preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
          $author_temp = trim($row["Name"]);
          $author_temp = preg_replace("![^a-z0-9]+!i", "-", $author_temp);
          echo "<tr><td><a href='/library-of-codexes/codex=".$row["CODEX_ID"]."/".$codex_temp."'>".$row["CODEX_TITLE"] ."</a></td>";
          echo "<td><a href='/library-of-codexes/author=" .$row["FK_AUTHOR_ID"]."/".$author_temp."'>" .$row["Name"]  ."</a></td></tr>"; 
        }
      }
      mysqli_close($db);		
      echo "</tbody></table>";
		}
		elseif("Collections" == $type){

		}
	}
?>