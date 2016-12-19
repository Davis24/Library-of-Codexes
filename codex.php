<?php 
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if($db === false)
	{
		echo "error occured, put in an error page";
	}
	include('header.php');

	$codex_id = (int)$_GET["c"];
	//Pulls game id and game title
	$row = $db->query("SELECT FK_GAME_ID, games.GAME_TITLE FROM codexes INNER JOIN games ON FK_GAME_ID = games.GAME_ID WHERE CODEX_ID = ('".$codex_id."')")->fetch_assoc();
	$game_id = $row["FK_GAME_ID"];
	$game_title = $row["GAME_TITLE"];

	//Pulls author_name, codexes title, text 
	$row = $db->query("SELECT CODEX_TITLE, CONCAT(authors.FIRST_NAME, ' ', authors.LAST_NAME) as name, FK_AUTHOR_ID, CODEX_TEXT FROM codexes INNER JOIN authors ON FK_AUTHOR_ID = authors.AUTHOR_ID WHERE CODEX_ID = ('".$codex_id."')")->fetch_assoc();
	$author_id = $row["FK_AUTHOR_ID"];
	$author_name = $row["name"];

	$codex_text = $row["CODEX_TEXT"];
	$codex_title = $row["CODEX_TITLE"];

?> 

<!-- to do
	-increase text size
	-add button functionality
	-add on hove for links

	-->
<br/><br/><br/>
<div  class="centering" style="text-align:center;">
	<h1 id="text-change"><?php echo $codex_title; ?></h1>
	<h3><?php echo "<a href='/library-of-codexes/author=".$author_id."'>".$author_name; ?></h3> 
	<h4><?php echo "<a href='/library-of-codexes/game=".$game_id."'>".$game_title; ?></a></h4>
	<div id="buttons" class="w3-btn-group">
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-chevron-left" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-plus" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-minus" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-adjust" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-chevron-right" aria-hidden="true"></i></button>
	</div>
</div>

<br/><br/><br/>
<div class="centering">
	<p><?php echo nl2br($codex_text); ?> </p>
</div>
<br/><br/>
<div id="buttons2" class="w3-btn-group">
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-chevron-left" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-plus" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-minus" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-adjust" aria-hidden="true"></i></button>
  		<button class="w3-btn w3-white w3-border w3-hover-black"><i class="fa fa-chevron-right" aria-hidden="true"></i></button>
	</div>
<?php include('footer.html'); ?>