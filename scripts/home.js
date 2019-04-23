//Temporary fix for Safari download issue
//-Written by Gerrit
$(document).ready(function () {
	if(isSafari()) {
		$("#download").attr('target', '_');
		$("#download").removeAttr('download');
	}
	if(isChrome()){
		console.log("IS chrome");
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
 
function ebookText(ebook_choice){
	//console.log("reaching ebookText: " +ebook_choice);
	if(ebook_choice){
		$.ajax ({
			type: 'post',
			url: './loadgame.php',
			data: {
				ebook: ebook_choice,
			},
			success: function(response){
				$('#ebook_info').html(response);
			},
			error: function(){
				//console.log("Something went wrong");
			}
		});
	}
}

$("#download").on("click", function(){
    callPHPZip();
});

function callPHPZip(){
	if($( "input:checked" ).length == 0){
		$('#ebook_info').html("No Videogame Series selected.");
	}
	else if($( "input:checked" ).length == 1){
		$("input:checked").each(function(){
			$ebook_path = getBaseUrl() +"ebooks/" + $(this).val() + "." + $("select[name='ebook']").val();
			window.location = $ebook_path;
		});
		$('#ebook_info').html("");
	}
	else
	{
		var ebookList = [];
		$("input:checked").each(function(){
			ebookList.push("ebooks/" + $(this).val() + "." +$("select[name='ebook']").val());
		});
		$('#ebook_info').html("");

		$.ajax ({
			type: 'post',
			url: "./zipEbooks.php",
			data: {data : JSON.stringify(ebookList)},
			success: function(response){
				window.location = response;
			},
			error: function(err){
				console.log(err);
			}
		});
	}
}