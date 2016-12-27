<?php 
	include('header.php'); 
	//Database Connection
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if(!$db)
{
		echo "error occured, put in an error page";
	}
	//Query for numbers
	$codexes_num = $db->query("SELECT COUNT(CODEX_ID) as 'count' FROM CODEXES")->fetch_object()->count;
	$authors_num = $db->query("SELECT COUNT(AUTHOR_ID) as 'count' FROM AUTHORS")->fetch_object()->count;
	$collections_num = $db->query("SELECT COUNT(COLLECTIONS_ID) as 'count' FROM COLLECTIONS")->fetch_object()->count;
	$games_num = $db->query("SELECT COUNT(*) as 'count' FROM GAMES")->fetch_object()->count;
?>
<!--Banner-->
<div id="about-banner" style = "background-color: #fff4d3;">
	<div class="centering-text">
		<h1> The Library of Codexes currently contains: <?php echo $codexes_num." individual works, ".$authors_num." authors, ".$collections_num." collections, and ".$games_num." games."?></h1>
	</div>
</div>
<br/>
<div class="centering">
	<h1><b>Our Mission</b></h1>
	<p>Videogames have always excelled at creating complex worlds filled with creatures, items, and that one mind-numbingly slow NPC you <em>must</em> escort. These games often have a plethora of in-game text that can be difficult to collect and read in-game. Library of Codexes sole mission is to create an archive of in-game text that is easily accessible, either online or offline (ebooks).</p>
</div>

<?php include('footer_min.html'); ?>