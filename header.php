<!DOCTYPE html>
<html lang="en">
    <?php 
    if(!isset($_tpl))
    {
        $_tpl = array();
        $_tpl['title'] = 'Library of Codexes';
        $_tpl['meta_desc'] = '';
    }
    ?>
    <link rel="icon" href="/library-of-codexes/img/library_of_codexes_icon-3.png" />
    <meta name = "description" content = "<?php echo $_tpl['meta_desc']?>">
    <meta name = "keywords" content = "library, codexes, video games, reading, lore, codex, dishonored, mass effect">
	<title><?php echo $_tpl['title']?></title>
	<meta name = "viewport" content="width=device-width, initial-scale=1">
	<link href="https://fonts.googleapis.com/css?family=Merriweather|Oswald" rel="stylesheet"> 
	<link rel="stylesheet" href="/library-of-codexes/css/w3.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet" href="/library-of-codexes/css/general-min.css">
	<link rel="stylesheet" href="/library-of-codexes/css/footer-min.css">
	<link rel="stylesheet" href="/library-of-codexes/css/modernscale-min.css"> 
	<header>
	<!--web header navigation -->
		<nav>
			<ul class = "w3-navbar w3-black w3-xlarge">
				<div class="centering">
					<li class="w3-hide-large w3-opennav w3-right">
    					<a href="javascript:void(0);" onclick="myFunction()"><i class="fa fa-bars" aria-hidden="true"></i></a>
    				</li>
					<li><a href="/library-of-codexes/home"><b>Library of Codexes</b></a></li>
					<li class="w3-hide-small w3-hide-medium w3-hover-book"><a href="/library-of-codexes/ebooks">Ebooks</a></li>
					<li class="w3-hide-small w3-hide-medium w3-dropdown-hover"><a href="javascript:void(0);">Games <i class="fa fa-caret-down"></i></a>
						<div class="w3-dropdown-content w3-white w3-card-4">
							<a href="/library-of-codexes/game=3/Baldur-s-Gate">Baldur's Gate</a>	
							<a href="/library-of-codexes/game=9/Deus-Ex">Deus Ex</a>	
							<a href="/library-of-codexes/game=4/Diablo">Diablo</a>
	  						<a href="/library-of-codexes/game=1/Dishonored">Dishonored</a>
	  						<a href="/library-of-codexes/game=7/Fable">Fable</a>
	  						<a href="/library-of-codexes/game=5/Mass-Effect">Mass Effect</a>
                  			<a href="/library-of-codexes/game=2/Star-Wars-The-Old-Republic">Star Wars: The Old Republic</a>
                  			<a href="/library-of-codexes/game=8/The-Last-of-Us">The Last of Us</a>
                  			<a href="/library-of-codexes/game=6/Tomb-Raider">Tomb Raider</a>	
						</div>
					</li>
					<form method = "post" action ="search">
						<li  class="w3-hide-small w3-hide-medium w3-right">
							<button class="w3-book w3-btn w3-hover-gray" type="submit" name="submit">
								<i class="fa fa-search"></i>
							</button>
						</li>
						<li class="w3-hide-small w3-hide-medium w3-right">
							<input type="text" class="w3-input" name="search" placeholder="Search..">
						</li>
					</form>
					<li class="w3-hide-small w3-hide-medium w3-right"><a href="/library-of-codexes/contact">Contact</a></li>
					<li class="w3-hide-small w3-hide-medium w3-right"><a href="javascript:void(0);" onclick="document.getElementById('support_modal').style.display ='block'">Support</a></li>
				</div>
			</ul>
		</nav>
		<!-- mobile header navigation-->
		<nav id="mobile" class="w3-hide w3-hide-large">
  			<ul class="w3-navbar w3-left-align w3-large w3-black">
    			<li><a href="/library-of-codexes/ebooks">Ebooks</a></li>
    			<li class="w3-dropdown-hover"><a href="#">Games</a>
    				<div class="w3-dropdown-content w3-white w3-card-4">
						<a href="/library-of-codexes/game=3/Baldur-s-Gate">Baldur's Gate</a>	
						<a href="/library-of-codexes/game=9/Deus-Ex">Deus Ex</a>	
						<a href="/library-of-codexes/game=4/Diablo">Diablo</a>
	  					<a href="/library-of-codexes/game=1/Dishonored">Dishonored</a>
	  					<a href="/library-of-codexes/game=7/Fable">Fable</a>
	  					<a href="/library-of-codexes/game=5/Mass-Effect">Mass Effect</a>
                  		<a href="/library-of-codexes/game=2/Star-Wars-The-Old-Republic">Star Wars: The Old Republic</a>
                  		<a href="/library-of-codexes/game=8/The-Last-of-Us">The Last of Us</a>
                  		<a href="/library-of-codexes/game=6/Tomb-Raider">Tomb Raider</a>
					</div>
    			</li>
    			<li><a href="/library-of-codexes/contact">Contact</a></li>
    			<li><a href="#" onclick="document.getElementById('support_modal').style.display ='block'">Support</a></li>
    			<form method = "post" action ="search">
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
			<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
				<input type="hidden" name="cmd" value="_s-xclick">
				<input type="hidden" name="encrypted" value="-----BEGIN PKCS7-----MIIHNwYJKoZIhvcNAQcEoIIHKDCCByQCAQExggEwMIIBLAIBADCBlDCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20CAQAwDQYJKoZIhvcNAQEBBQAEgYAKeVd7GcqWoqgJpoDeJxpOj1H1LAea2B5V2e6sDDYpyhhCCbsIX3XKUDngvkhNjPW7/TWhrlctQnuadcwhtpq1dPIdeoiHtNov4Xayc5A3SBOyPFpkHxwFz3WwILGZ+k7thZsEY4vpKhJYTU2IVJdyda5roCLLxgL3ZKkaEI3o4zELMAkGBSsOAwIaBQAwgbQGCSqGSIb3DQEHATAUBggqhkiG9w0DBwQIODC02skxw/eAgZB4XFTc8DIc+UHKsyWQGYQoibzRuDusB0axu85ROaP9Ib9cAbGzdDYW7+eUi+yPQ/cT1xuawsqOUY7FqgthnJnomuk9UzbWIJbQRTiSCsc2TAhxUzWuLdStlWHxIBWz7V6HbWStNbfrDdlj0HpmZXkdCXPjzRLQa+sS+BucY3e6AavJ9bmSkzXnqcnj93bRLlKgggOHMIIDgzCCAuygAwIBAgIBADANBgkqhkiG9w0BAQUFADCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20wHhcNMDQwMjEzMTAxMzE1WhcNMzUwMjEzMTAxMzE1WjCBjjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAkNBMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtQYXlQYWwgSW5jLjETMBEGA1UECxQKbGl2ZV9jZXJ0czERMA8GA1UEAxQIbGl2ZV9hcGkxHDAaBgkqhkiG9w0BCQEWDXJlQHBheXBhbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMFHTt38RMxLXJyO2SmS+Ndl72T7oKJ4u4uw+6awntALWh03PewmIJuzbALScsTS4sZoS1fKciBGoh11gIfHzylvkdNe/hJl66/RGqrj5rFb08sAABNTzDTiqqNpJeBsYs/c2aiGozptX2RlnBktH+SUNpAajW724Nv2Wvhif6sFAgMBAAGjge4wgeswHQYDVR0OBBYEFJaffLvGbxe9WT9S1wob7BDWZJRrMIG7BgNVHSMEgbMwgbCAFJaffLvGbxe9WT9S1wob7BDWZJRroYGUpIGRMIGOMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC1BheVBhbCBJbmMuMRMwEQYDVQQLFApsaXZlX2NlcnRzMREwDwYDVQQDFAhsaXZlX2FwaTEcMBoGCSqGSIb3DQEJARYNcmVAcGF5cGFsLmNvbYIBADAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBAIFfOlaagFrl71+jq6OKidbWFSE+Q4FqROvdgIONth+8kSK//Y/4ihuE4Ymvzn5ceE3S/iBSQQMjyvb+s2TWbQYDwcp129OPIbD9epdr4tJOUNiSojw7BHwYRiPh58S1xGlFgHFXwrEBb3dgNbMUa+u4qectsMAXpVHnD9wIyfmHMYIBmjCCAZYCAQEwgZQwgY4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLUGF5UGFsIEluYy4xEzARBgNVBAsUCmxpdmVfY2VydHMxETAPBgNVBAMUCGxpdmVfYXBpMRwwGgYJKoZIhvcNAQkBFg1yZUBwYXlwYWwuY29tAgEAMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNjA2MjgxNTQ0MDJaMCMGCSqGSIb3DQEJBDEWBBQ6stQkh+LGk9U9Bf5jI44G7xgkSzANBgkqhkiG9w0BAQEFAASBgKrNhrp//jf/8DnqntCML+6zqd3oE66r+XqGosv9WnooCYaPa1tfXX4/VZWrmTONhSYp2IBS905TwaYohpJRvlaD4E40uL5B87OhRWT72JHY0bmTqFYGnwC0Ki5+VvKSjsiz7NWkJNR1J4m5JSDYROKcQiPGZ91BWJwhZ6MGdb6/-----END PKCS7-----">
				<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
    			<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
    		</form>
		</div>
	</div>
</div>
