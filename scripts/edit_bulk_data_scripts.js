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