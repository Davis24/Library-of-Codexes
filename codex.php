<?php 
	$codex_id = (int)$_GET["c"]; //Incoming Variable
	$config = parse_ini_file('config.ini');
		$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	//Pulls game id and game title
	$row = $db->query("SELECT FK_GAME_ID, games.GAME_TITLE FROM codexes INNER JOIN games ON FK_GAME_ID = games.GAME_ID WHERE CODEX_ID = ('".$codex_id."')")->fetch_assoc();
	$game_id = $row["FK_GAME_ID"];
	$game_title = $row["GAME_TITLE"];
	$game_temp = preg_replace("![^a-z0-9]+!i", "-", $game_title);
	//Pulls author name, codexes title, text 
	$row = $db->query("SELECT CODEX_TITLE, CONCAT(authors.FIRST_NAME, ' ', authors.LAST_NAME) as name, FK_AUTHOR_ID, CODEX_TEXT FROM codexes INNER JOIN authors ON FK_AUTHOR_ID = authors.AUTHOR_ID WHERE CODEX_ID = ('".$codex_id."')")->fetch_assoc();
	$author_id = $row["FK_AUTHOR_ID"];
	$author_name = $row["name"];
	$author_temp = trim($row["name"]);
    $author_temp = preg_replace("![^a-z0-9]+!i", "-", $author_name);

    $codex_title = $row["CODEX_TITLE"];
	$codex_temp = preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
	$codex_text = $row["CODEX_TEXT"];

	$_tpl = array();
    $_tpl['title'] = $codex_title .' | Library of Codexes';
    $_tpl['meta_desc'] = 'A video game codex database website with authors, collections, and ebooks from your favorite games.';

	include('header.php');
?> 
<br/><br/>
<div class="centering-text">
	<h1 id="text-change"><?php echo $codex_title; ?></h1>
	<h3><?php echo "<a href='/author=".$author_id."/".$author_temp."'>".$author_name; ?></a></h3> 
	<h4><?php echo "<a href='/game=".$game_id."/".$game_temp."'>".$game_title; ?></a></h4>
	<div id="buttons" class="w3-btn-group">
		<?php 
			$row = $db->query("SELECT CODEX_ID, CODEX_TITLE FROM codexes where CODEX_ID < ".$codex_id." AND FK_GAME_ID =".$game_id." ORDER BY CODEX_ID DESC LIMIT 1")->fetch_assoc();
			if(!empty($row)) {
				$codex_before = "/codex=".$row["CODEX_ID"]."/". preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
				echo '<button class="w3-btn w3-white w3-border w3-hover-black" onclick="location.href=\''.$codex_before.'\'" > <i class="fa fa-chevron-left" aria-hidden="true"></i> </button>';
			}
		?>
  		<button id="increase_font" class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-plus" aria-hidden="true"></i></button>
  		<button id="decrease_font" class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-minus" aria-hidden="true"></i></button>
  		<button id="change_color" class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-adjust" aria-hidden="true"></i></button>
  		<?php
  			$row = $db->query("SELECT CODEX_ID, CODEX_TITLE FROM codexes where CODEX_ID > ".$codex_id." AND FK_GAME_ID =".$game_id." ORDER BY CODEX_ID LIMIT 1")->fetch_assoc();
			if(!empty($row)) {
				$codex_after = "/codex=".$row["CODEX_ID"]."/". preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
				echo '<button class="w3-btn w3-white w3-border w3-hover-black" onclick="location.href=\''.$codex_after.'\'"><i class="fa fa-chevron-right" aria-hidden="true"></i></button>';
			}
  		?>
	</div>
</div>
<br/><br/>
<div class="centering">
	<p id="text"><?php echo nl2br($codex_text);
					 mysqli_close($db); ?> 
	</p>
</div>
<br/><br/>

<?php include('footer.html'); ?>