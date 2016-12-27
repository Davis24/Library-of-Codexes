function openTab(evt, libraryType, num) {
    var i, tablinks;
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    document.getElementById(libraryType).style.display = "block";
    evt.currentTarget.className += " active";
    reloadTable(libraryType, num);
}
function reloadTable(choice, num) {
    if(choice){
      $.ajax ({
        type: 'post',
        url: '/library-of-codexes/loadtable.php',
        data: {
          type: choice,
          game_id: num,
        },
        success: function(response){
          $('#table_info').html(response);
          $('#game_table').dataTable();
        }
      });
    }
}