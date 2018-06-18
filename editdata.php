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
	HAVING c.FK_SERIES_ID = 18 ORDER BY c.CODEX_TITLE ASC";
	if($result = $db -> query($query)){
		while($row = $result -> fetch_assoc()) {
			echo "<h1>".$row['CODEX_TITLE']."-".$row['CODEX_ID']."-".$row['FK_GAME_ID']."</h1>";
			echo "<h3>".$row['AUTHORS']."</h3>";
			echo "<p>".nl2br($row['CODEX_TEXT']).'</p>';
		}
	}
?>
</div>

<?php require_once 'inc/footer.php'; ?>