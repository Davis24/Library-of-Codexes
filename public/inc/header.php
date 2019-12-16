<?php 	
	require_once('../config/config.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Global site tag (gtag.js) - Google Analytics -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=UA-79563886-1"></script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
		gtag('js', new Date());
		gtag('config', 'UA-79563886-1');
	</script>
	<meta charset="UTF-8">
	<meta name = "viewport" content="width=device-width, initial-scale=1.0">
	<meta name = "description" content = "Welcome to Library of Codexes, the most comprehensive collection of Video Game codexes. The collection includes Elder Scrolls, Mass Effect, World of Warcraft and more.">
    <meta name = "keywords" content = "library, codexes, video games, reading, lore, codex, dishonored, mass effect">
	<meta property="og:image" content="https://libraryofcodexes.com/img/loc_image.png">
	<meta property="og:image:type" content="image/png">
	<meta property="og:image:width" content="200">
	<meta property="og:image:height" content="200">
	<link rel="icon" href="img/favicon.ico" type="image/ico" />    

	<title><?php echo $title ?></title>
	<link href="https://fonts.googleapis.com/css?family=Bebas+Neue|Roboto&display=swap" rel="stylesheet"> 
	<!-- Production uses URLROOT /css/ -->
 	<link rel="stylesheet" type="text/css" href="<?php echo URLROOT . 'resources/semantic/semantic.min.css' ?>">
    <link rel="stylesheet" type="text/css" href="<?php echo URLROOT . 'resources/semantic/components/hamburger.css' ?>"><!-- Get this added to semantic.min.css-->
    <link rel="stylesheet" type="text/css" href="<?php echo URLROOT . 'resources/semantic/components/footer.css' ?>"><!-- Get this added to semantic.min.css-->
    
    <style type="text/css"><?php echo $custom_css ?></style>   
    
</head>
<body class="Site">    
    <header>
        <nav>
            <div class="ui stackable borderless menu">
                <div class="ui container">
					<a href="index.php" class="header item left aligned">Library of Codexes</a>
					<div class="right item">
						<a href="https://www.patreon.com/thelibrarian" target="_blank" class="item"><i class="patreon icon"></i>Patreon</a>
						<a href="https://ko-fi.com/V7V7BH05" target="_blank" class="item"><i class="coffee icon"></i>Ko-fi: Buy me a coffee</a>
					</div>
                </div>
                <div class="hamburger "><!-- TODO: Pull the hamburger icon in a little bit so it's not so on the edge-->
                    <span class="hamburger-bun"></span>
                    <span class="hamburger-patty"></span>
                    <span class="hamburger-bun"></span>
                </div>
            </div>
        </nav>
    </header>
    <main class="Site-content">