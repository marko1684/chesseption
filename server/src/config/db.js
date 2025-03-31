const mongoose = require("mongoose");

const gameSchema = new mongoose.Schema({
   game_id : {type : String, required: true, unique: true},
   players : [{player_id: String, points : Number}],
   board_state : {
      player_positions: {type: Map, of: String},
      diamond_position: {type: String},
   },
   last_move: {
      player_id: String, default : null,
      move_piece: String, default : null,
      from: String, default : null, 
      to: String, default : null,
      lied: Boolean, default : null,
   },
   status: {
      type: String,
      enum: ["waiting", "in_progress", "finished"], default: "waiting"
   },
});

module.exports = mongoose.model("Game", gameSchema);