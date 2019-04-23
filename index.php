<?php require_once 'inc/header.php'; ?>

<header class="w3-display-container w3-wide" id="banner">
    <img class="w3-image" alt="Gaming Icons" >
    <div class="w3-display-left w3-padding-large">
      <h1 id="banner-header" class="w3-jumbo w3-hide-small"><b>THE EASIEST WAY TO READ <br> IN-GAME TEXT EVER!</b></h1>
      <h1 id="banner-header" class="w3-hide-large w3-hide-medium"><b>THE EASIEST WAY TO READ <br> IN-GAME TEXT EVER!</b></h1>
      <h6><a href="#ebooks" class="w3-button w3-white w3-padding-large w3-large w3-round w3-hover-opacity-off" >DOWNLOADS</a></h6>
    </div>
</header>

<div id="exclamation-circle" class="w3-hide-small">
    <p>
        <span class="fa-stack fa-4x" style="vertical-align:top;">
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
    <h1 id="praise-header"><b>PRAISE FROM THE INTERNET</b></h1>
    <p><i>Awesome, great stuff to read while sitting on the youknowwhat... ;) thx a lot!</i></p>
    <p class ="user_name">- u/Edimasta</p>
    <p><i>Clicked for ES. Got distracted by Baldur's Gate and KOTOR. Fell into a nerd vortex.</i></p>
    <p class ="user_name">- u/[Deleted]</p>
    <p><i>Sir, i've never seen one in pdf, you are one of those heroes without a cape. Lok'tar, friend!</i></p>
    <p class ="user_name">- u/Lexgium</p>
    <p><i>The hero we need but don't deserve</i></p>
    <p class ="user_name">- u/ecskde</p>
    <p><i>A good library, worth its weight in <span style="color: #F2DA5E;"><b>gold</b></span>.</i></p>
    <p class ="user_name">- u/BKGRila</p>
</div>
<div id="ebooks" class="w3-container w3-padding-large">
        <h1 id="download-header">EBOOKS</h1>
        <!-- Ebook Selection -->
           <form class="w3-container">
               <div class="w3-row" style="text-align:left;">
                   <label><b>Select Videogame Series:</b></label>
                       <div class="checkbox-container">        
                       <?php 
                           $query = "SELECT TITLE FROM ebooks ORDER BY TITLE ASC";
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
