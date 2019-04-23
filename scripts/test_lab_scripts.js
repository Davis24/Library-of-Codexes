
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
    //updateDB(id,document.getElementById("editor").value);
    var text = document.getElementById("editor").innerHTML;
    //console.log(document.getElementById("editor").innerHTML);
    text = text.replace(/<p>\s*<\/p>/g,"\n");
    text = text.replace(/<strong>\s*<\/strong>/g,"");
    text = text.replace(/<p>/g,"");
    text = text.replace(/<\/p>/g,"\n");
    text = text.replace(/<div class="ql-editor" data-gramm="false" contenteditable="true">/g,"");
    text = text.replace(/<\/div><div class="ql-clipboard" tabindex="-1" contenteditable="true"><\/div><div class="ql-tooltip ql-hidden"><a class="ql-preview" target="_blank" href="about:blank"><\/a><input type="text" data-formula="e=mc\^2" data\-link="https\:\/\/quilljs\.com" data\-video="Embed URL"><a class="ql-action"><\/a><a class="ql-remove"><\/a><\/div>/g, "");
    console.log(text);
    updateDB(id,text);
    //document.getElementById(id).style.display = "none";
    //document.getElementById(textid).style.display = "block";
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
    console.log("Called updateText");
    if(codex_id){
        $.ajax ({
            type: 'post',
            url: './updateCodex.php',
            data: {
                codex: codex_id,
                str: text,
            },
            success: function(response){
                console.log(response);
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