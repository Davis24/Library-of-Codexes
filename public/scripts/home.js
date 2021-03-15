//Temporary fix for Safari download issue
//-Written by Gerrit
$(document).ready(function () {
	if(isSafari()) {
		$("#download").attr('target', '_');
		$("#download").removeAttr('download');
	}
	if(isChrome()){
		$("#download").attr('target', '_');
		$("#download").removeAttr('download');
	}
 });
 
//Temporary fix for Safari download issue
//-Written by Gerrit
function isSafari () {
	return /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || (typeof safari !== 'undefined' && safari.pushNotification));
}

function isChrome(){
	return window.chrome;
}

function getBaseUrl() {
    var re = new RegExp(/^.*\//);
    return re.exec(window.location.href);
}

$("#download").on("click", function(){
    callPHPZip();
});

//capitalize_Words 
function capitalize_words(str)
{
 return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

function callPHPZip(){
	var game_titles = $('#games').val();
	var ebook_type = $('#ebook_type').val();

	if(ebook_type.length <= 0 || game_titles.length == 0){
		$('.message').removeClass('hidden');
		$('#message').text("Select at least one videogame series and an ebook format.");
	}
	else{
		game_titles.forEach(function(part, index) {
			//this[index] = getBaseUrl() + "ebooks/" + capitalize_words(this[index]) + "." + ebook_type;
			this[index] =  "ebooks/" + capitalize_words(this[index]) + "." + ebook_type;
		  }, game_titles); 

		if(ebook_type.length > 0 && game_titles.length == 1){
			window.location = game_titles[0];
		}
		else{
			$('#loading').addClass('active');
			
			$.ajax({
				type: 'post',
				url: "./zipEbooks.php",
				data: {data : JSON.stringify(game_titles)},
				success: function(response){
					$('#loading').removeClass('active');
					if(response === "Error occurred, please try again."){
						$('.message').removeClass('hidden');
						$('#message').text(response);
					}
					else{
						if(response.includes('Error')){
							$('.message').removeClass('hidden');
							$('#message').text(response);
						}
						else{
							window.location = response;
						}
						
					}
					
				},
				error: function(err){
					$('#loading').removeClass('active');
					$('.message').addClass('active');
					$('.message header').text(err);
				}
			});
		}
	} 	
}