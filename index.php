<!DOCTYPE html>
<html lang="en">
<head>
<?php 
	//Connect to database
	require_once './app/config/config.php';
	require_once './scripts/dbconnect.php';
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
        <a href="#" class="w3-bar-item w3-button w3-hover-white" style="font-family: 'Permanent Marker', cursive; letter-spacing: 0.1em;"><b>Library of Codexes</b></a>
        <a href="https://ko-fi.com/V7V7BH05" target='_blank' class="w3-hide-small w3-bar-item w3-button w3-right w3-hover-white"><img height='36' style="border:0px;height:36px;" src="https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com" />
        <a href="https://www.patreon.com/thelibrarian" target="_blank" class="w3-hide-small w3-bar-item w3-button w3-right w3-hover-white"><img src = "img/patreon_logo-min.png" height = "36"></a>
    </div>
</nav>


<header class="w3-display-container w3-wide" id="banner">
    <img class="w3-image" alt="Gaming Icons" >
    <div class="w3-display-left w3-padding-large">
      <h1 id="banner-header" class="w3-jumbo w3-hide-small" style="color:#F2E85C;"><b>THE EASIEST WAY TO READ <br> IN-GAME TEXT EVER!</b></h1>
      <h1 id="banner-header" class="w3-hide-large w3-hide-medium" style="color:#F2E85C;"><b>THE EASIEST WAY TO READ <br> IN-GAME TEXT EVER!</b></h1>
      <h6><a href="#ebooks" class="w3-button w3-white w3-padding-large w3-large w3-round w3-hover-opacity-off" >DOWNLOADS</a></h6>
    </div>
</header>

<div id="exclamation-circle" class="w3-hide-small">
    <p>
        <span class="fa-stack fa-4x" style="vertical-align: top;">
                <i id="exclamation-icon-background" class="fas fa-circle fa-stack-1x"></i>
                <i id="exclamation-icon" class="fas fa-exclamation-circle fa-stack-2x "></i>
        </span>
        
    </p>
</div>
<div id="series-text" class="w3-container w3-white w3-margin w3-padding-large w3-round-large">
    <div class="w3-center">
      <h3>Over 24 Ebooks Spanning 65+ Video Games</h3>
      <h5>Thousands of pages of in-game text, hundreds of reading hours.</h5>
    </div>
</div>

<div id="praise" class="w3-container w3-text-white centering centering-text">
    <h1 id="praise-header"  style="color:#F2E85C;"><b>PRAISE FROM THE INTERNET</b></h1>
    <p><i>Awesome, great stuff to read while sitting on the youknowwhat... ;) thx a lot!</i></p>
    <p style="color:#F2DA5E">- u/Edimasta</p>
    <p><i>Clicked for ES. Got distracted by Baldur's Gate and KOTOR. Fell into a nerd vortex.</i></p>
    <p style="color:#F2DA5E">- u/[Deleted]</p>
    <p><i>Sir, i've never seen one in pdf, you are one of those heroes without a cape. Lok'tar, friend!</i></p>
    <p style="color:#F2DA5E">- u/Lexgium</p>
    <p><i>The hero we need but don't deserve</i></p>
    <p style="color:#F2DA5E">- u/ecskde</p>
    <p><i>A good library, worth its weight in <span style="color: #F2DA5E;"><b>gold</b></span>.</i></p>
    <p style="color:#F2DA5E">- u/BKGRila</p>
</div>
<div id="ebooks" class="w3-container w3-padding-large" style="background-color:white;">
        <h1 id="download-header">EBOOKS</h1>
        <!-- Ebook Selection -->
           <form class="w3-container">
               <div class="w3-row" style="text-align:left;">
                   <label><b>Select Videogame Series:</b></label>
                       <div class="checkbox-container">        
                       <?php 
                           $query = "SELECT TITLE, EBOOK_DESCRIPTION FROM ebooks ORDER BY TITLE ASC";
                           if($result = $db -> query($query)){
                               while($row = $result -> fetch_assoc()) {
                                   $val = str_replace(array(':','\''), '', $row["TITLE"]);
                                   echo '<label class="checkbox-label"><input type="checkbox" class="w3-check" value="'.$val.'" >'.$row["TITLE"].'</label>';
                               }
                           }                         
                       ?>                   
                       </div>
                   <br>
                   <label><b>Select Ebook Format:</b></label>
                   <div class="select">
                       <select id="slct" name="ebook">
                           <option value="azw3">AZW3</option>
                           <option value="epub">EPUB</option>
                           <option value="pdf">PDF</option>
                       </select>
                   </div>
               </div>
               <br> 
               <a id="download" href="#" class="w3-button w3-xlarge w3-block w3-green">Download</a>
           </form>
</div>
<?php require_once 'inc/footer.php'; ?>
