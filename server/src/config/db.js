const mongoose = require('mongoose');

const gameSchema = new mongoose.Schema({
    game_id: { type: String, required: true, unique: true },
    players: [{ player_id: String }],
    player_id: String,
    lied: Boolean,
    next_player: String,
    accepted: [{ accept: Number }],
    board_state: {
        player_positions: {
            type: Map,
            of: { position: String, points: Number },
        },
        diamond_position: { type: String },
    },
    last_move: {
        board_state: {
            player_positions: {
                type: Map,
                of: { position: String, points: Number },
            },
            diamond_position: { type: String },
        },
    },
    status: {
        type: String,
        enum: ['waiting', 'in_progress', 'finished', 'challanged'],
        default: 'waiting',
    },
});

module.exports = mongoose.model('Game', gameSchema);
