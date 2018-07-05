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

function getBaseUrl() {
    var re = new RegExp(/^.*\//);
    return re.exec(window.location.href);
}

$("select[name='game']").change(function() {
    //console.log($("select").val());    
	//console.log("Base URL" +getBaseUrl());
	ebookText($("select").val());
	$ebook_path = getBaseUrl() +"ebooks/" + $("select").val() + "." + $("select[name='ebook']").val();
	$('#download').attr('href',$ebook_path);
})

$("select[name='ebook']").change(function() {
	$ebook_path = getBaseUrl() +"ebooks/" + $("select").val() + "." + $("select[name='ebook']").val();
	$('#download').attr('href',$ebook_path);
})

/******************************
 * 
 * Test Lab Scripts Only
 * 
 * 
 *****************************/

//Hides <p> text and shows textarea for editing
function editText(id){
    var textid = id+"_text";
    document.getElementById(id).style.display = "block";
    document.getElementById(textid).style.display = "none";
}

//Submits updated text to updateDB, which updates the db, once complete it hides the text area and shows the <p> text
function updateText(id){
    var textid = id+"_text";
    updateDB(id,document.getElementById(id).value)
    document.getElementById(id).style.display = "none";
    document.getElementById(textid).style.display = "block";
}

//Cancels the edit and reverts back to the <p> text
function cancelEdit(id){
    var textid = id+"_text";
    document.getElementById(id).style.display = "none";
    document.getElementById(textid).style.display = "block";
}

//Deletes entry
function deleteEntry(c_id){
    if(c_id){
        $.ajax ({
            type: 'post',
            url: './updateCodex.php',
            data: {
                id: c_id,
            },
            success: function(response){
                console.log(response);
            },
            error: function(){
                console.log("Something went wrong");
            }
        });
    }
}

//Updates DB
function updateDB(codex_id, text){
    //console.log("Called updateText");
    if(codex_id){
        $.ajax ({
            type: 'post',
            url: './updateCodex.php',
            data: {
                codex: codex_id,
                str: text,
            },
            success: function(response){
                var id_name = codex_id + "_text"; 
                $('#'+id_name).html(response);
                $('#'+codex_id).html(response);
            },
            error: function(){
                console.log("Something went wrong");
            }
        });
    }
}