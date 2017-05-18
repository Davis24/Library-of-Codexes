<!DOCTYPE html>
<html lang="en">
    <?php 
    //Connect to database
	require_once('./scripts/dbconnect.php');
	if($db === false)	{
		echo "error occured, put in an error page";
	}

    if(!isset($_tpl))
    {
        $_tpl = array();
        $_tpl['title'] = 'Library of Codexes';
        $_tpl['meta_desc'] = 'Welcome to Library of Codexes, the most comprehensive collection of Video Game codexes. The collection includes Elder Scrolls, Mass Effect, World of Warcraft and more.';
    }
    ?>
    <link rel="icon" href="/img/library_of_codexes_icon-3.png" />
    <meta name = "description" content = "<?php echo $_tpl['meta_desc']?>">
    <meta name = "keywords" content = "library, codexes, video games, reading, lore, codex, dishonored, mass effect">
	<title><?php echo $_tpl['title']?></title>
	<meta name = "viewport" content="width=device-width, initial-scale=1">
	<link href="https://fonts.googleapis.com/css?family=Merriweather|Oswald" rel="stylesheet"> 
	<link rel="stylesheet" href="/css/w3.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="/css/general-min.css">
	<link rel="stylesheet" href="/css/footer-min.css">
	<link rel="stylesheet" href="/css/modernscale-min.css"> 
	<header>
	<!--web header navigation -->
		<nav>
			<ul class = "w3-navbar w3-black w3-xlarge">
				<div class="centering">
					<li class="w3-hide-large w3-opennav w3-right">
    					<a href="javascript:void(0);" onclick="myFunction()"><i class="fa fa-bars" aria-hidden="true"></i></a>
    				</li>
					<li><a href="/home"><b>Library of Codexes</b></a></li>
					<li class="w3-hide-small w3-hide-medium w3-hover-book"><a href="/ebooks">Ebooks</a></li>
					<li class="w3-hide-small w3-hide-medium w3-dropdown-hover"><a href="javascript:void(0);">Games <i class="fa fa-caret-down"></i></a>
						<div class="w3-dropdown-content w3-white w3-card-4">
						<?php 
							$query = "SELECT GAME_TITLE, GAME_ID FROM games ORDER BY GAME_TITLE ASC";
							if($result = $db -> query($query)){
  								while($row = $result -> fetch_assoc()) {
  									$game_name = str_replace(" ", "-", preg_replace("![^a-z0-9\s]+!i", "-", $row["GAME_TITLE"]));
    								echo '<a href="/game='.$row["GAME_ID"].'/'.$game_name.'">'.$row["GAME_TITLE"]."</a>";
			  					}
  							} 
  						?>
						</div>
					</li>
					<form method = "post" action ="/search">
						<li  class="w3-hide-small w3-hide-medium w3-right">
							<button class="w3-book w3-btn w3-hover-gray" type="submit" name="submit">
								<i class="fa fa-search"></i>
							</button>
						</li>
						<li class="w3-hide-small w3-hide-medium w3-right">
							<input type="text" class="w3-input" name="search" placeholder="Search..">
						</li>
					</form>
					<li class="w3-hide-small w3-hide-medium w3-right"><a href="/contact">Contact</a></li>
					<li class="w3-hide-small w3-hide-medium w3-right"><a href="https://www.patreon.com/thelibrarian"><img src = "/img/patreon_logo-min.png" height = "30"> Patreon</a></li>
				</div>
			</ul>
		</nav>
		<!-- mobile header navigation-->
		<nav id="mobile" class="w3-hide w3-hide-large">
  			<ul class="w3-navbar w3-left-align w3-large w3-black">
    			<li><a href="/ebooks">Ebooks</a></li>
    			<li class="w3-dropdown-hover"><a href="#">Games</a>
    				<div class="w3-dropdown-content w3-white w3-card-4">
						<?php 
							$query = "SELECT GAME_TITLE, GAME_ID FROM games ORDER BY GAME_TITLE ASC";
							if($result = $db -> query($query)){
  								while($row = $result -> fetch_assoc()) {
  									$game_name = str_replace(" ", "-", preg_replace("![^a-z0-9\s]+!i", "-", $row["GAME_TITLE"]));
    								echo '<a href="/game='.$row["GAME_ID"].'/'.$game_name.'">'.$row["GAME_TITLE"]."</a>";
			  					}
  							} 
  						?>
					</div>
    			</li>
    			<li><a href="/contact">Contact</a></li>
    			<li><a href="#" onclick="document.getElementById('support_modal').style.display ='block'">Support</a></li>
    			<form method = "post" action ="/search">
    				<li><input type="text" class="w3-input" name="search" placeholder="Search.."></li>
    				<li><button class="w3-btn" type="submit" name="submit"><i class="fa fa-search"></i></button></li>
    			</form>
  			</ul>
		</nav>
	</header>
<body>
    <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-79563886-1', 'auto');
  ga('send', 'pageview');

</script>
<!-- Support Modal -->
<div id="support_modal" class="w3-modal">
	<div class="w3-modal-content">
	    <header class="w3-container w3-book modal-header">
		  	<span onclick="document.getElementById('support_modal').style.display ='none'" class="w3-closebtn">&times;</span>
	       	<h2>&hearts; Thank You! &hearts;</h2>
	    </header>
		<div class="w3-container modal-header">
			<p>Your support helps keep Library of Codexes alive.</p>
			<a href = "https://www.patreon.com/thelibrarian"><img src = "/img/patreon_black-min.png"></a>
		</div>
	</div>
</div>
