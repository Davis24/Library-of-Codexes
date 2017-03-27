<?php 
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if(!$db) {
		echo "error occured, put in an error page";
	}

	$_tpl = array();
    $_tpl['title'] = 'Library of Codexes';
    $_tpl['meta_desc'] = 'A video game codex database website with authors, collections, and ebooks from your favorite games.';

  
	include('header.php');
	$game_id = 11;
?> 

<div class ="w3-container">
<?php
		$query = "SELECT CODEX_TITLE, CONCAT(authors.TITLE,' ',authors.FIRST_NAME, ' ', authors.LAST_NAME) as name, FK_AUTHOR_ID, CODEX_TEXT FROM codexes INNER JOIN authors ON FK_AUTHOR_ID = authors.AUTHOR_ID WHERE codexes.FK_GAME_ID = ('".$game_id."') ORDER BY codexes . CODEX_TITLE ASC";
		
  		if($result = $db -> query($query)){
  			while($row = $result -> fetch_assoc()) {
    			echo "<h1>".$row['CODEX_TITLE']."</h1>";
    			echo "<h2>".$row['name']."</h2>";
  				echo "<p>".nl2br($row['CODEX_TEXT']).'</p>';
  					}
  				}
  			?>
</div>


<?php include('footer.html'); ?>