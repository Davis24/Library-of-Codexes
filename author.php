<?php 
	//Database Connection
	$config = parse_ini_file('config.ini');
	$db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
	if($db === false)
	{
		echo "error occured, put in an error page";
	}
	$author_id = (int)$_GET["a"];
	$row = $db->query("SELECT CONCAT(FIRST_NAME,' ', LAST_NAME) as Name, BIOGRAPHY FROM AUTHORS WHERE AUTHOR_ID = ('".$author_id."')")->fetch_assoc();
	$author = $row['Name'];
	$bio = $row['BIOGRAPHY'];
	include('header.php'); 
?>

<!-- TO DO LIST
	-Banner Image/Icon
	-Font Size
-->


<!--- Banner -->
<div id="about-banner" style = "background-color: #fff4d3;">
	<div class="centering" style="text-align: center;">
	</div>
</div>

<div  class="centering" style="text-align:center;">
	<h1 id="text-change"><?php echo $author ?></h1>
	<h4 id="text-change"><?php echo $bio ?></h4>
</div>
<br/>
<div class="centering">
<table id="example" class="display" width="100%" cellspacing="0">
    <thead>
       	<tr>
           	<th>Title</th>
        </tr>
        </thead>
        <tbody>
        	<?php
        		$query = "SELECT CODEX_TITLE, CODEX_ID FROM CODEXES WHERE FK_AUTHOR_ID = ('".$author_id."')";
       			if($result = $db->query($query))
           		{
           			while($row = $result ->fetch_assoc())
           			{
           				$codex_temp = str_replace(" ", "-", $row["CODEX_TITLE"]);
              			echo "<tr><td><a href = '/library-of-codexes/codex=".$row["CODEX_ID"]."/".$codex_temp."'>" .$row["CODEX_TITLE"] . "</a></td></tr>";
            		}
            	}
          		mysqli_close($db);		
            ?>
        </tbody>
    </table>
</div>

<?php include('footer.html'); ?>