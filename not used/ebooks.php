<?php
  //Database Connection
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if(!$db)	{
		echo "error occured, put in an error page";
	}
  $_tpl = array();
  $_tpl['title'] = 'Ebooks | Library of Codexes';
  $_tpl['meta_desc'] = 'A video game codex database website with authors, collections, and ebooks from your favorite games.';
	include('header.php');
?>

<!--- Banner -->
<div id="banner">
  <div class="centering-text">
	   <h1 id="text-change">EBOOKS</h1>
  </div>
</div>


<br/>
<div class="centering">
	<table id="page_table" class="display" width="100%" cellspacing="0">
    	<thead>
       		<tr>
           		<th>Game</th>
           		<th>Ebook</th>
        	</tr>
     	</thead>
        <tbody>
        	<?php
        		$query = "SELECT GAME_TITLE, GAME_ID FROM GAMES ORDER BY GAME_TITLE";
       			if($result = $db->query($query))
           	{
           		while($row = $result ->fetch_assoc())
           		{
                $game_temp = preg_replace("![^a-z0-9]+!i", "-", $row["GAME_TITLE"]);
            		echo "<tr>
              					<td><a href = '/game=" .$row["GAME_ID"]."/".$game_temp."'>".$row["GAME_TITLE"]."</a></td>
              					<td><a href = '/files/epub/".$game_temp.".epub'>EPUB</a> · <a href = '/files/azw3/".$game_temp.".azw3'>AZW3</a> · <a href = '/library-of-codexes/files/pdf/".$game_temp.".pdf
              					'>PDF</a></td></tr>";
            		}
            	}
          		mysqli_close($db);		
            ?>
        </tbody>
    </table>
</div>
<?php include('footer.html'); ?>