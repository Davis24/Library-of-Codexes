<!DOCTYPE html>
<html lang="en">
<head>

    <?php 
	//Connect to database
	require_once 'app/config/config.php';
	require_once 'scripts/dbconnect.php';
	if($db === false){
		echo "Error occured, put in an error page";
	}

    if(!isset($_tpl))
    {
        $_tpl = array();
        $_tpl['title'] = 'Library of Codexes';
        $_tpl['meta_desc'] = 'Welcome to Library of Codexes, the most comprehensive collection of Video Game codexes. The collection includes Elder Scrolls, Mass Effect, World of Warcraft and more.';
    }
    ?>
	<meta charset="UTF-8">
	<meta name = "viewport" content="width=device-width, initial-scale=1.0">
	<meta name = "description" content = "<?php echo $_tpl['meta_desc']?>">
    <meta name = "keywords" content = "library, codexes, video games, reading, lore, codex, dishonored, mass effect">
	
	<title><?php echo $_tpl['title']?></title>
	
	<link rel="icon" href="<?php echo URLROOT; ?>/img/library_of_codexes_icon-3.png" />    
	<link href="https://fonts.googleapis.com/css?family=Merriweather|Oswald" rel="stylesheet"> 
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/w4.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/general-min.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/footer.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/modernscale-min.css"> 
	<header>
	<!--web header navigation -->
		<nav>
			<ul class = "w3-navbar w3-black w3-xlarge">
				<div class="centering">
					<li class="w3-hide-large w3-hide-medium w3-opennav w3-right"><a href="javascript:void(0);" onclick="myFunction()"><i class="fa fa-bars" aria-hidden="true"></i></a></li>
					<li><a href="<?php echo URLROOT; ?>/home"><b>Library of Codexes</b></a></li>
					<li class="w3-hide-small w3-right"><a href="https://www.patreon.com/thelibrarian" target="_blank"><img src = "img/patreon_logo-min.png" height = "30"> Patreon</a></li>
					<li class="w3-hide-small w3-right"><a href='https://ko-fi.com/V7V7BH05' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
				</div>
			</ul>
		</nav>
		<!-- mobile header navigation-->
		<nav id="mobile" class="w3-hide w3-hide-large">
			<ul class="w3-navbar w3-left-align w3-large w3-black">
				<li class="w3-right w3-hide-medium w3-hide-large"><a href="https://www.patreon.com/thelibrarian" target="_blank"><img src = "img/patreon_logo-min.png" height = "30"> Patreon</a></li>
				<li class="w3-right w3-hide-medium w3-hide-large"><a href='https://ko-fi.com/V7V7BH05' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
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
