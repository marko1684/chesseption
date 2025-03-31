const Game = require("../config/db");

const game_model = {
   async create_game(game_id, players, board_state){
      return await Game.create({game_id, players, board_state: board_state});
   }
}