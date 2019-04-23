<?php 
	require_once 'inc/header.php';
	$codex_id = $_GET['codex'];
	$previous = 0;
	$next = 0;
	$previous_query = "select CODEX_ID from codexes where CODEX_ID = (select min(CODEX_ID) from codexes where CODEX_ID > $codex_id)";
	if($result = $db -> query($previous_query)){
		$row = $result->fetch_assoc();
		$previous = $row['CODEX_ID'];
		$result->free();
	}

	$next_query = "select CODEX_ID from codexes where CODEX_ID = (select max(CODEX_ID) from codexes where CODEX_ID < $codex_id)";
	if($result = $db -> query($next_query)){
		$row = $result->fetch_assoc();
		$next = $row['CODEX_ID'];
		$result->free();
	}
	

?> 

<div class ="w3-container">
<p><a href="<?php echo URLROOT; ?>/editdata.php?codex=<?php echo $previous?>">Previous</a> ||| <a href="<?php echo URLROOT; ?>/editdata.php?codex=<?php echo $next?>">Next </a>
<?php

	if(isset($_GET['codex'])) {
		echo $_GET['codex'];
		$codex_id = $_GET['codex']; 

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
		#22655
	HAVING c.FK_GAME_ID = 51 and c.CODEX_ID = $codex_id ORDER BY c.CODEX_TITLE ASC
	#HAVING c.FK_SERIES_ID = 2 ORDER BY c.CODEX_TITLE ASC";
	if($result = $db -> query($query)){
		while($row = $result -> fetch_assoc()) {
			echo "<h1>".$row['CODEX_TITLE']."-".$row['CODEX_ID']."-".$row['FK_GAME_ID']." <button class=\"w3-button w3-red w3-small\" type=\"button\" onclick=\"deleteEntry(".$row['CODEX_ID'].")\">DELETE</button></h1>";
			echo "<h3>".$row['AUTHORS']." </h3>";
			#echo "<p id=\"".$row['CODEX_ID']."_text\">".nl2br($row['CODEX_TEXT']).'</p>';
			echo "<div id =\"editor\" style=\"height:400px;\">".nl2br($row['CODEX_TEXT'])."</div>";
			echo "<br><br>";
			#echo "<p><textarea id=".$row['CODEX_ID']." rows='25' cols='150' style='display:none;'>".nl2br($row['CODEX_TEXT'])."</textarea></p>";
			echo "<p><button onclick=\"updateText(".$row['CODEX_ID'].")\" class=\"w3-button w3-green\">Update</button> <button onclick=\"cancelEdit(".$row['CODEX_ID'].")\" class=\"w3-button w3-red\">Cancel</button></p>";
			
		}
	}
	}
		
?>
</div>

<footer class="footer-basic-centered">
    <p class="footer-company-motto">Level up your lore skill.</p>
    <p class="footer-links">
        <a href="<?php echo URLROOT; ?>/">Home</a> <span class="w3-text-white" >&#183;</span>
        <a href="<?php echo URLROOT; ?>/about">About</a> <span sclass="w3-text-white">&#183;</span>
        <a href="https://www.patreon.com/thelibrarian" target="_blank">Patreon</a> <span class="w3-text-white">&#183;</span>
        <a href="https://ko-fi.com/V7V7BH05" target="_blank">Buy Me a Coffee</a>
        </p>
    <p class="footer-company-name">Codexes utilized within this site are property of their publisher. Library of Codexes &copy; 2018</p>
</footer>
<script src = "<?php echo URLROOT; ?>/scripts/jquery-3.3.1.min.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/home.js"></script>
<script src="<?php echo URLROOT; ?>/scripts/test_lab_scripts.js"></script>
<script async src="https://c6.patreon.com/becomePatronButton.bundle.js"></script>
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>

<!-- for mobile header -->
<script>
    function myFunction() {
        var x = document.getElementById("mobile");
        if (x.className.indexOf("w3-show") == -1) {
            x.className += " w3-show";
        } else { 
            x.className = x.className.replace(" w3-show", "");
        }
    }
	var quill = new Quill('#editor', {
    theme: 'snow'
  	});
   
</script>
</body>
</html>