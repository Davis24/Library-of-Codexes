//Temporary fix for Safari download issue
//-Written by Gerrit
$(document).ready(function () {
	if(isSafari()) {
		$("#download").attr('target', '_');
		$("#download").removeAttr('download');
	}
 });
 
//Temporary fix for Safari download issue
//-Written by Gerrit
function isSafari () {
	return /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || (typeof safari !== 'undefined' && safari.pushNotification));
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
	//console.log("calledPHPZip");
    var ebookList = [];
    $("input:checked").each(function(){
		//console.log($(this).val());
        ebookList.push("ebooks/" + $(this).val() + "." +$("select[name='ebook']").val());
    });
	//console.log("The Ebook List:" + ebookList.join(", "));
	
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


/*$("select[name='game']").change(function() {
    //console.log($("select").val());    
	//console.log("Base URL" +getBaseUrl());
	ebookText($("select").val());
	$ebook_path = getBaseUrl() +"ebooks/" + $("select").val() + "." + $("select[name='ebook']").val();
	$('#download').attr('href',$ebook_path);
})

$("select[name='ebook']").change(function() {
	$ebook_path = getBaseUrl() +"ebooks/" + $("select").val() + "." + $("select[name='ebook']").val();
	$('#download').attr('href',$ebook_path);
})*/