var cell_click = function(cell){
	var send_txt = cell.value;
	var req_url = 'http://www.mznh.jp:4567/json/'+ send_txt+"";
	var side = ["","白","黒"]
	$.ajax({ type:'GET', url:req_url, dataType:'json' }).then(
		function(json) {
			$("#side").html("<p>今は"+side[json.side]+ "の番です。</p>")
			$('#game_board').html("");
			for(var i=0;i<8;i++){
				for(var j=0;j<8;j++){
					switch(json.board[i][j]){
						case 0:$('#game_board').append(
							"<input id=\"cell\" type=\"image\" src=\"blank.png\" value=\""+i+","+j+"\"alt=\""+i+","+j+"\"name=\"input_pos\" width=\"32\" height=\"32\" onclick=\"cell_click(this)\" style=\"margin:0px\"> ")
							break;
						case 1:$('#game_board').append(
							"<input id=\"cell\" type=\"image\" src=\"white.png\" value=\""+i+","+j+"\"alt=\""+i+","+j+"\"name=\"input_pos\" width=\"32\" height=\"32\" onclick=\"cell_click(this)\" style=\"margin:0px\"> ")
						break;
						case 2:$('#game_board').append(
							"<input id=\"cell\" type=\"image\" src=\"black.png\" value=\""+i+","+j+"\"alt=\""+i+","+j+"\"name=\"input_pos\" width=\"32\" height=\"32\" onclick=\"cell_click(this)\" style=\"margin:0px\"> ")
						break;
					}
				}
				$('#game_board').append("<br>")
			}
		},
		function() {
			$('#game_board').append('error' + req_url);
		}
	);
};

