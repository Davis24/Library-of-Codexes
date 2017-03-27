<?php 
	$config = parse_ini_file('config.ini');
    $db = mysqli_connect('127.0.0.1',$config['username'],$config['password'],$config['dbname']);
  	$author_id = (int)$_GET["a"]; //Incoming Variable
	
	$row = $db->query("SELECT CONCAT(FIRST_NAME,' ', LAST_NAME) as Name, BIOGRAPHY FROM authors WHERE AUTHOR_ID = ('".$author_id."')")->fetch_assoc();
	$author = $row['Name'];
	$bio = $row['BIOGRAPHY'];

  	$_tpl = array();
  	$_tpl['title'] =  $author .' | Library of Codexes';
  	$_tpl['meta_desc'] = 'Biography: ' .$bio;

	include('header.php'); 
?>
<!--- Banner -->
<div id="banner">
  <div class="centering-text">
    <h1 id="text-change"><?php echo $author ?></h1>
    <h4><?php echo $bio ?></h4>
  </div>
</div>

<br/>
<div class="centering">
  <table id="page_table" class="display row-table-link" width="100%" cellspacing="0">
    <thead>
      <tr>
        <th>Title</th>
      </tr>
    </thead>
    <tbody>
      <?php
        $query = "SELECT CODEX_TITLE, CODEX_ID FROM codexes WHERE FK_AUTHOR_ID = ('".$author_id."')";
        if($result = $db->query($query)) {
          while($row = $result ->fetch_assoc()) {
            $codex_temp = preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"]);
            echo "<tr><td><a href='/codex=".$row["CODEX_ID"]."/".$codex_temp."'>".$row["CODEX_TITLE"]."</a></td></tr>";
          }
        }
        mysqli_close($db);		
      ?>
    </tbody>
  </table>
</div>

<?php include('footer.html'); ?>