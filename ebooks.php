<?php
  //Database Connection
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if($db === false)	{
		echo "error occured, put in an error page";
	}
	include('header.php');
?>

<!--- Banner -->
<div id="about-banner" style = "background-color: #fff4d3;">
	<div class="centering" style="text-align: center;">
	</div>
</div>

<div  class="centering" style="text-align:center;">
	<h1 id="text-change">EBOOKS</h1>
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
              					<td><a href = '/ebooks/epub/".$game_temp.".epub'>EPUB</a> · <a href = '/ebooks/azw3/".$game_temp.".azw3'>AZW3</a> · <a href = '/ebooks/pdf/".$game_temp.".pdf
              					'>PDF</a></td></tr>";
            		}
            	}
          		mysqli_close($db);		
            ?>
        </tbody>
    </table>
</div>


<?php include('footer.html'); ?>