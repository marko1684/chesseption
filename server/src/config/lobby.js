const mongoose = require('mongoose');

const lobbySchema = new mongoose.Schema({
    game_type: {
        type: Number,
        required: true,
        enum: [2, 3, 4],
    },
    players: [{ player_id: String }],
    created_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Lobby', lobbySchema);
