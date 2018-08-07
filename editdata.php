<?php 
	require_once 'inc/header.php';
?> 

<div class ="w3-container">
<?php
		$query = "SELECT
		CODEX_ID,
		CODEX_TITLE,
		CODEX_TEXT,
		c.FK_GAME_ID,
		c.FK_SERIES_ID,
		GROUP_CONCAT(a.NAME ORDER BY a.NAME) AUTHORS
	FROM 
	   codexes c
			   INNER JOIN
				codexes_authors z ON c.CODEX_ID = z.FK_CODEX_ID
			INNER JOIN
				AUTHORS a ON z.FK_AUTHOR_ID = a.AUTHOR_ID
	GROUP BY
		c.CODEX_ID,
		c.CODEX_TITLE
	#HAVING c.FK_SERIES_ID = 2 ORDER BY c.CODEX_TITLE ASC
	HAVING c.FK_SERIES_ID = 9 ORDER BY c.CODEX_ID ASC";
	if($result = $db -> query($query)){
		while($row = $result -> fetch_assoc()) {
			echo "<h1>".$row['CODEX_TITLE']."-".$row['CODEX_ID']."-".$row['FK_GAME_ID']." <button class=\"w3-button w3-orange\" type=\"button\" onclick=\"editText(".$row['CODEX_ID'].")\">Edit</button></h1>";
			echo "<h3>".$row['AUTHORS']." <button class=\"w3-button w3-red w3-small\" type=\"button\" onclick=\"deleteEntry(".$row['CODEX_ID'].")\">DELETE</button></h3>";
			echo "<p id=\"".$row['CODEX_ID']."_text\">".nl2br($row['CODEX_TEXT']).'</p>';
			echo "<p><textarea id=".$row['CODEX_ID']." rows='50' cols='150' style='display:none;'>".nl2br($row['CODEX_TEXT'])."</textarea></p>";
			echo "<p><button onclick=\"updateText(".$row['CODEX_ID'].")\" class=\"w3-button w3-green\">Update</button> <button onclick=\"cancelEdit(".$row['CODEX_ID'].")\" class=\"w3-button w3-red\">Cancel</button></p>";
			
		}
	}
?>
</div>
<?php require_once 'inc/footer.php'; ?>