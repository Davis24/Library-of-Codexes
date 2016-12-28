<?php include('header.php'); ?>
<!-- Jumbotron Banner -->
<div id="banner-display" class ="w3-display-container w3-text-white" >
	<img id="home-banner" src="img/banner.jpg" alt="">
	<div class ="w3-display-middle w3-container">
		<h1><b>Find a codex to read.</b></h1>
		<h3>Browse through hundreds of codexes from your favourite games.</h3>
	</div>
</div>
<!-- Start of Images -->	
<div class="centering">
	<div class="w3-row-padding book-img">
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(3);"><img src="img/baldurs_gate.png" alt="Baldur's Gate"></a>
    </div>
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(9);"><img src="img/deus_ex.png" alt="Deus Ex"></a>
    </div>
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(4);"><img src="img/diablo.png" alt="Diablo"></a>
    </div>
		<div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(1);"><img src="img/dishonored.png" alt="Dishonored"></a>
    </div>
  </div>
  <div class="w3-row-padding book-img">
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(7);"><img src="img/fable.png" alt="Fable"></a>
    </div>
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(5);"><img src="img/mass_effect.png" alt="Mass Effect"></a>
    </div>
    <div class="w3-col s6 m3 l3">
    	<a href="javascript:void(0);" onclick="gamepopup(2);"><img src="img/swtor.png" alt="Star Wars: The Old Republic"></a>
    </div>
		<div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(8);"><img src="img/the_last_of_us.png" alt="The Last of Us"></a>
    </div>
  </div>
  <div class="w3-row-padding book-img">
    <div class="w3-col s6 m3 l3">
      <a href="javascript:void(0);" onclick="gamepopup(6);"><img src="img/tomb_raider.png" alt="Tomb Raider"></a>
    </div>
    <div class="w3-col s6 m3 l3"></div>
    <div class="w3-col s6 m3 l3"></div>
		<div class="w3-col s6 m3 l3"></div>
  </div>
</div>
<!-- Game link popup -->
<div id="popup" class="w3-panel w3-black" style="display:none;">
	<div class="centering">
    <span onclick="document.getElementById('popup').style.display='none'" class="w3-closebtn">x</span>
    <div id="game_info"></div>
	</div>
</div>
<script src="/library-of-codexes/scripts/home.js"></script>
<?php include('footer_min.html'); ?>