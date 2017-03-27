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
<link rel="stylesheet" href="css/downloads.css"> 
<!--- Banner -->
<div id="banner">
  <div class="centering-text">
	   <h1 id="text-change">EBOOKS</h1>
  </div>
</div>

<br/>
<div class="centering">
  <table>
    <thead>
      <tr>
        <th>File</th>
        <th>Size</th>
      </tr>
    </thead>
    <tbody>
<?php 
  function formatSizeUnits($bytes) {
    if ($bytes >= 1073741824) {
      $bytes = number_format($bytes / 1073741824, 2) . ' GB';
    }
    elseif ($bytes >= 1048576) {
      $bytes = number_format($bytes / 1048576, 2) . ' MB';
    }
    elseif ($bytes >= 1024) {
      $bytes = number_format($bytes / 1024, 2) . ' kB';
    }
    elseif ($bytes > 1){
      $bytes = $bytes . ' bytes';
    }
    return $bytes;
  }
  $dir = "files/";
  $scanned_directory = array_diff(scandir($dir), array('..', '.'));
  foreach ($scanned_directory as $value) {
    $folder_name = str_replace("-", ' ', $value);
    echo '<tbody class="labels"><tr><td colspan="3"><label for="'.$value.'">'.$folder_name.'&#x25BC;</label><input type="checkbox" name="'.$value.'" id="'.$value.'" data-toggle="toggle"></td></tr></tbody><tbody class="hide">';
    $tempdir = $dir  .$value . "/*.*";
    foreach(glob($tempdir) as $filename) {
      $individual_file = basename($filename);
      $individual_file = str_replace("-", ' ', $individual_file);
      echo '<tr><td><a href ="'.$filename.'">'.$individual_file.'</a><td>'.formatSizeUnits(filesize($filename)).'</td></tr>';
    }
    echo '</tbody>';
  }
?>
  </tbody>
</table>
</div>

<?php include('footer.html'); ?>
<script>
$(document).ready(function() {
  $('[data-toggle="toggle"]').change(function(){
    $(this).parents().next('.hide').toggle();
  });
});

</script>