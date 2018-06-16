<?php 
 	require_once 'inc/header.php'; 
	//Changing to manual update since site DB will be changed to only hold up to date ebook information
	$codexes_num = 12304;
	$games_num = 44;
	$authors_num = 3270;
	mysqli_close($db);
?>
<!--Banner-->
<div id="banner">
	<div class="centering-text">
		<h1> The Library of Codexes currently contains: <?php echo $codexes_num." individual works, ".$authors_num." authors, and ".$games_num." games."?></h1>
	</div>
</div>
<br/>
<div class="centering">
	<h1><b>Our Mission</b></h1>
	<p>Videogames have always excelled at creating complex worlds filled with creatures, items, and that one mind-numbingly slow NPC you <em>must</em> escort. These games often have a plethora of in-game text that can be difficult to collect and read in-game. Library of Codexes sole mission is to create an archive of in-game text that is easily accessible.</p>
</div>

<?php require_once 'inc/footer.php'; ?>