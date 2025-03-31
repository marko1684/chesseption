const Game = require("../config/db");

// last_move: {
//    player_id: String, default : null,
//    move_piece: String, default : null,
//    from: String, default : null, 
//    to: String, default : null,
//    lied: Boolean, default : null,
// },

const game_model = {
   async create_game(game_id, players, board_state){
      return await Game.create({game_id, players, board_state: board_state});
   },
   
   async make_move(game_id, move, new_board_state){
      current_game = await Game.findById(game_id);
      current_game.last_move = move;
      current_game.board_state = new_board_state;
      return await Game.findByIdAndUpdate(game_id, current_game);
   }
}