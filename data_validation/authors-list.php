<?php 
	require_once 'inc/header.php';
	$series_id = 16;
?> 
<div class ="w3-container">
	<?php
		$query = "SELECT AUTHOR_ID, NAME FROM AUTHORS WHERE authors.FK_SERIES_ID = ('".$series_id."')";
		#query = "SELECT CODEX_TITLE, FK_AUTHOR_ID, CODEX_TEXT, CODEX_ID FROM codexes ORDER BY codexes . CODEX_TITLE ASC";
		echo $query;
		if($result = $db -> query($query)){
			while($row = $result -> fetch_assoc()) {
				echo "<p>".$row['AUTHOR_ID']."- ".$row['NAME']."</p>";
					}
				}
	?>
</div>
<?php require_once 'inc/footer.php'; ?>