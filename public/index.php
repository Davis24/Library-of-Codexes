<?php 
    $title = "Library of Codexes";
    $custom_css = "#ebooks {
      margin-bottom: 1em;
    }
    .ui.inverted.vertical.masthead.segment{
      min-height: 500px;
      background-image: url('./img/banner2000x1250.png') !important;
      background-size: cover;
      background-repeat: no-repeat;
      background-position: center center;
      
    }
    .testwrapper{
      color: white; 
      font: bold 24px/45px Helvetica, Sans-Serif; 
      letter-spacing: -1px;  
      background: rgb(0, 0, 0); /* fallback color */
      background: rgba(0, 0, 0, 0.7);
      padding: 10px; 
    }

    h1,h2{
      font-family: 'Bebas Neue', cursive !important;
    }
    h3,h4, p{
      font-family: 'Roboto', sans-serif;
    }
    ";

    require_once './inc/header.php'; 

?>

  <div class="ui inverted vertical masthead segment">
    <div class="ui main container">
      <div class="testwrapper" style=" margin-top:10%; padding: 15px;">
        <h3 class="ui inverted header " style="text-align:center">Welcome to</h3>
        <h1 class="ui inverted header" style="text-align:center; font-family: 'Bebas Neue', cursive; font-size: 3em;">Library of Codexes</h1>
        <h3 class="ui inverted header" style="text-align:center; color: #ec9444;">The easiest way to read in-game text from your favourite videogames.</h3>
      </div>
    </div>
  </div>
  <br/>

  <div id="ebooks" class="ui main container" style="margin-top: 2%; margin-bottom: 5%">
    <div class="ui basic segment">
      <h1 class="ui header">Ebooks</h1>
      <div class="ui negative message hidden">
        <i class="close icon"></i>
        <div id="message" class="header"></div>
      </div>
      <div id="loading" class="ui indeterminate inverted dimmer">
        <div class="ui text loader">Zipping Files</div>
      </div>

      <form class="ui form">
        <div class="field">
          <label>Select Videogame Series:</label>
          <select id="games" multiple="" class="ui dropdown">
            <option value="">Ebooks</option>
            <option value="assassins creed">Assassin's Creed</option>
            <option value="baldurs gate">Baldur's Gate</option>
            <option value="battlefield">Battlefield</option>
            <option value="crysis">Crysis</option>
            <option value="dead space">Dead Space</option>
            <option value="deus ex">Deus Ex</option>
            <option value="diablo">Diablo</option>
            <option value="dishonored">Dishonored</option>
            <option value="dragon age">Dragon Age</option>
            <option value="dying light">Dying Light</option>
            <option value="fable">Fable</option>
            <option value="fallout">Fallout</option>
            <option value="horizon zero dawn">Horizon Zero Dawn</option>
            <option value="kingdoms of amalur">Kingdoms of Amalur</option>
            <option value="mass effect">Mass Effect</option>
            <option value="mass effect andromeda">Mass Effect Andromeda</option>
            <option value="metroid prime">Metroid Prime</option>
            <option value="middle earth shadow of mordor">Middle-earth: Shadow of Mordor</option>
            <!--<option value="nier">Nier</option>-->  
            <!--<option value="red dead redemption">Red Dead Redemption</option>-->
            <option value="star wars the old republic">Star Wars: The Old Republic</option>
            <option value="system shock">System Shock</option>
            <option value="the division">The Division</option>
            <option value="the elder scrolls">The Elder Scrolls</option>
            <option value="the elder scrolls online">The Elder Scrolls Online</option>
            <option value="the last of us">The Last of Us</option>
            <option value="the witcher">The Witcher</option>
            <option value="tomb raider">Tomb Raider</option>
            <option value="world of warcraft">World of Warcraft</option>
          </select>
        </div>
        <div class="field">
            <label>Select Ebook Format:</label>
            <div class="ui selection dropdown">
                <input id="ebook_type" type="hidden">
                <i class="dropdown icon"></i>
                <div class="default text">Ebook Format</div>
                <div class="menu">
                    <div class="item" data-value="azw3">AZW3</div>
                    <div class="item" data-value="epub">EPUB</div>
                    <div class="item" data-value="pdf">PDF</div>
                </div>
            </div>
        </div>
        <a class="ui green button" id="download">Download</a> <!-- To prevent reloading of the page-->
        <button class="ui red button" type="submit">Reset</button>
      </form>
    </div>
  </div>
</main>

<?php require_once 'inc/footer.php'; ?>