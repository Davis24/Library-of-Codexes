<?php 
	//Connect to database
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if($db === false)	{
		echo "error occured, put in an error page";
	}
	//Variables and Queries 
	$game_num = (int)$_GET["g"];
	$game_title = $db->query("SELECT GAME_TITLE FROM GAMES WHERE GAME_ID = ('".$game_num."')")->fetch_object()->GAME_TITLE;
  $game_temp = preg_replace("![^a-z0-9]+!i", "-", $game_title);
	//Codex Count Query
	$codexes_num = $db->query("SELECT COUNT(CODEX_ID) as 'count' FROM CODEXES WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
	$authors_num = $db->query("SELECT COUNT(AUTHOR_ID) as 'count' FROM AUTHORS WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
	$collections_num = $db->query("SELECT COUNT(COLLECTIONS_ID) as 'count' FROM COLLECTIONS WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
 
	include('header.php'); 
?>
<!--- Banner -->
<div id="banner">
  <div class="centering-text">
    <h1 id="text-change"><?php echo $game_title ?></h1>
    <h3 id="text-change"><?php echo '<a href="files/azw3/'.$game_temp.'.azw3">AZW3</a> · <a href="files/epub/'.$game_temp.'.epub">EPUB</a> · <a href="files/pdf/'.$game_temp.'.pdf">PDF</a>'; ?></h3>
  </div>
</div>

<br/>
<!-- Table -->
<div class="centering">
	<ul class="tab">
  		<li><a href="javascript:void(0)" class="tablinks active" onclick="openTab(event, 'Codexes', <?php echo $game_num; ?>)">Codexes(<?php echo $codexes_num;?>)</a></li>
  		<li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Authors', <?php echo $game_num; ?>)">Authors(<?php echo $authors_num;?>)</a></li>
  		<li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Collections', <?php echo $game_num; ?>)">Collections(<?php echo $collections_num;?>)</a></li>
	</ul>
	<div id="Codexes" class="tabcontent">
	<br/>
    <div id="table_info">
		  <table id="page_table" class="display row-table-link" width="100%" cellspacing="0">
        <thead>
          <tr>
            <th>Title</th>
            <th>Author</th>
          </tr>
        </thead>
        <tbody>
        	<?php
        		$query = "SELECT CODEX_TITLE, CONCAT(authors.FIRST_NAME, ' ', authors.LAST_NAME) as Name,
                	FK_AUTHOR_ID, CODEX_ID FROM codexes INNER JOIN authors ON codexes.FK_AUTHOR_ID = authors.AUTHOR_ID 
                	WHERE codexes.FK_GAME_ID = ('".$game_num."')";
       			if($result = $db->query($query))
           	{
           		while($row = $result ->fetch_assoc())
           		{
           			$codex_temp = preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
           			$author_temp = trim($row["Name"]);
           			$author_temp = preg_replace("![^a-z0-9]+!i", "-", $author_temp);
             			echo "<tr><td><a href='/library-of-codexes/codex=".$row["CODEX_ID"]."/".$codex_temp."'>".$row["CODEX_TITLE"] ."</a></td>";
             			echo "<td><a href='/library-of-codexes/author=" .$row["FK_AUTHOR_ID"]."/".$author_temp."'>" .$row["Name"]  ."</a></td></tr>"; 
            	}
            }
          	mysqli_close($db);		
          ?>
        </tbody>
      </table>
    </div>
  <br/>
	</div>
  <div id="Authors" class="tabcontent"></div>
	<div id="Collections" class="tabcontent"></div>
</div>
<br/>
<script src="/library-of-codexes/scripts/game.js"></script>
<?php include('footer.html') ?>