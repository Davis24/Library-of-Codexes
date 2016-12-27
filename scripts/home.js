function gamepopup(game_choice){
	document.getElementById('popup').style.display='block';
	reloadGame(game_choice);
}
function reloadGame(game_choice){
	if(game_choice){
		$.ajax ({
			type: 'post',
			url: '/library-of-codexes/loadgame.php',
			data: {
				game: game_choice,
			},
			success: function(response){
				$('#game_info').html(response);
			}
		});
	}
}