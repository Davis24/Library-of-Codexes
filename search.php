<?php
	include('header.php');
		$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if($db === false)
	{
		echo "error occured, put in an error page";
	}
	//Variables and Queries 
//	$game_num = (int)$_GET["g"];
//	$game_title = $db->query("SELECT GAME_TITLE FROM GAMES WHERE GAME_ID = ('".$game_num."')")->fetch_object()->GAME_TITLE;
	//Codex Count Query
 
	$codexes_num = $db->query("SELECT COUNT(CODEX_ID) as 'count' FROM CODEXES WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
	$authors_num = $db->query("SELECT COUNT(AUTHOR_ID) as 'count' FROM AUTHORS WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
	$collections_num = $db->query("SELECT COUNT(COLLECTIONS_ID) as 'count' FROM COLLECTIONS WHERE FK_GAME_ID = ('".$game_num."')")->fetch_object()->count;
 
?>
<br/><br/><br/>

<div  class="centering" style="text-align:center;">
	<h1 id="text-change">Search Results for </h1>
	<h4 id="text-change"> </h4>
</div>
<br/>
<!-- table -->
<div class="centering">
	<ul class="tab">
  		<li><a href="javascript:void(0)" class="tablinks active" onclick="openTab(event, 'Codexes')">Codexes(<?php echo $codexes_num;?>)</a></li>
  		<li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Authors')">Authors(<?php echo $authors_num;?>)</a></li>
  		<li><a href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'Collections')">Collections(<?php echo $collections_num;?>)</a></li>
	</ul>

	<div id="Codexes" class="tabcontent">
	<br/>
		<table id="example" class="display" width="100%" cellspacing="0">
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
              			$codex_temp = str_replace(" ", "-", $row["CODEX_TITLE"]);
              			$author_temp = str_replace(" ", "-", $row["Name"]); 
              			$author_temp = str_replace("'", "&#39;", $author_temp);
              			echo "<tr><td><a href='/library-of-codexes/codex=".$row["CODEX_ID"]."/".$codex_temp."'>".$row["CODEX_TITLE"] ."</a></td>";
              			echo "<td><a href='/library-of-codexes/author=" .$row["FK_AUTHOR_ID"]."/".$author_temp."'>" .$row["Name"]  ."</a></td></tr>"; 
            		}
            	}
          		mysqli_close($db);		
            ?>
        	</tbody>
    	</table>
    <br/>
	</div>
    <div id="Authors" class="tabcontent">
  		<h3>Paris</h3>
  		<p>Paris is the capital of France.</p> 
	</div>

	<div id="Collections" class="tabcontent">
  		<h3>Tokyo</h3>
  		<p>Tokyo is the capital of Japan.</p>
	</div>

</div>
<script>
function openTab(evt, libraryType) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(libraryType).style.display = "block";
    evt.currentTarget.className += " active";
}
</script>

<?php include('footer.html'); ?>