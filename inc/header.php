<!DOCTYPE html>
<html lang="en">
<head>
<?php 
	//Connect to database
	
	require_once '../app/config/config.php';
	require_once '../scripts/dbconnect.php';
	if($db === false){
		echo "Error occured, put in an error page";
	}
    ?>
	<meta charset="UTF-8">
	<meta name = "viewport" content="width=device-width, initial-scale=1.0">
	<meta name = "description" content = "Welcome to Library of Codexes, the most comprehensive collection of Video Game codexes. The collection includes Elder Scrolls, Mass Effect, World of Warcraft and more.">
    <meta name = "keywords" content = "library, codexes, video games, reading, lore, codex, dishonored, mass effect">
	<meta property="og:image" content="http://libraryofcodexes.com/img/loc_image.png">
	<meta property="og:image:type" content="image/png">
	<meta property="og:image:width" content="200">
	<meta property="og:image:height" content="200">
	<link rel="icon" href="img/favicon.ico" type="image/ico" />    

	<title>Library of Codexes</title>
	
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/w3.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/balloon.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/general-min.css">
	<link rel="stylesheet" href="<?php echo URLROOT; ?>/css/footer-min.css">

    <link href="https://fonts.googleapis.com/css?family=Permanent+Marker|Raleway" rel="stylesheet"> 
</head>

<!-- Web Header Navigation -->
<nav>
    <div class="w3-bar w3-black">
        <a id="logo" href="#" class="w3-bar-item w3-button w3-hover-white" ><b>Library of Codexes</b></a>
        <a href="https://ko-fi.com/V7V7BH05" target='_blank' class="w3-hide-small w3-bar-item w3-button w3-right w3-hover-white"><img height='36' style="border:0px;height:36px;" src="https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com"></a>
        <a href="https://www.patreon.com/thelibrarian" target="_blank" class="w3-hide-small w3-bar-item w3-button w3-right w3-hover-white"><img src = "img/patreon_logo-min.png" height = "36"></a>
    </div>
</nav>
