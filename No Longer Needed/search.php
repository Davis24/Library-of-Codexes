<?php 
	//Database Connection
  $search=$_POST['search'];
	require_once('./scripts/dbconnect.php');
  
  $_tpl = array();
  $_tpl['title'] = $search .' | Library of Codexes Search';
  $_tpl['meta_desc'] = 'A video game codex database website with authors, collections, and ebooks from your favorite games.';
	include('header.php'); 
?>

<!--- Banner -->
<div id="banner">
  <div class="centering-text">
	   <h1 id="text-change">Search results for <i><?php echo $search; ?></i></h1>
  </div>
</div>
<br/>
<br/>
<!-- Table -->
<div class="centering">
	<br/>
    <div id="table_info">
		  <table id="page_table" class="display row-table-link" width="100%" cellspacing="0">
        <thead>
          <tr>
            <th>Name</th>
            <th>Type</th>
          </tr>
        </thead>
        <tbody>
        	<?php
        		if(isset($_POST['submit']))
        		{
              
              $query = "SELECT CODEX_TITLE, CODEX_ID FROM codexes WHERE LOWER(CODEX_TITLE) LIKE LOWER('%".$search."%')";
              if($result = $db ->query($query)) {
                while($row = $result -> fetch_assoc()) {
                  echo "<tr><td><a href = '/codex=".$row['CODEX_ID']."/".preg_replace("![^a-z0-9]+!i", "-", $row["CODEX_TITLE"])."'>".$row['CODEX_TITLE']."</a></td>";
                  echo "<td> Codex </td></tr>";
                }
              }
              $query = "SELECT CONCAT(FIRST_NAME,' ', LAST_NAME) as Name, AUTHOR_ID FROM AUTHORS WHERE LOWER(CONCAT(FIRST_NAME, ' ', LAST_NAME)) LIKE LOWER('%".$search."%')";
              if($result = $db ->query($query)) {
                while($row = $result -> fetch_assoc()) {
                  echo "<tr><td><a href = '/author=".$row["AUTHOR_ID"]."/".preg_replace("![^a-z0-9]+!i", "-", $row["Name"])."'>".$row['Name']."</a></td>";
                  echo "<td> Author </td></tr>";
                }
              }
              $query = "SELECT NAME, COLLECTIONS_ID FROM COLLECTIONS WHERE LOWER(NAME) LIKE LOWER('%".$search."%')";
              if($result = $db ->query($query)) {
                while($row = $result -> fetch_assoc()) {
                  echo "<tr><td><a href = '/collections=".$row["COLLECTIONS_ID"]."/".preg_replace("![^a-z0-9]+!i", "-", $row["NAME"]) ."'>".$row['NAME']."</a></td>";
                  echo "<td> Collection </td></tr>";
                }
        		}

          }
        		
          ?>
        </tbody>
      </table>
    </div>
  <br/>
	</div>
</div>
</br>

<?php include('footer.html'); ?>