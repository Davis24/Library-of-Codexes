<?php 
	require_once 'inc/header.php';

  
	
	$game_id = 41;
?> 

<div class ="w3-container">
<?php
		$query = "SELECT CODEX_TITLE, FK_AUTHOR_ID, CODEX_TEXT, CODEX_ID FROM codexes WHERE FK_SERIES_ID = 16  ORDER BY codexes . CODEX_TITLE ASC";
		#query = "SELECT CODEX_TITLE, FK_AUTHOR_ID, CODEX_TEXT, CODEX_ID FROM codexes ORDER BY codexes . CODEX_TITLE ASC";
		echo $query;
  		if($result = $db -> query($query)){
  			while($row = $result -> fetch_assoc()) {
    			echo "<h1>".$row['CODEX_TITLE']."</h1>";
    			//echo "<h2>".$row['name']."</h2>";
  				echo "<p>".nl2br($row['CODEX_TEXT']).'</p>';
  					}
  				}
  			?>
</div>

<?php require_once 'inc/footer.php'; ?>