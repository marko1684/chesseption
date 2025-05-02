const mongoose = require('mongoose');

const friendship_schema = new mongoose.Schema({
    player1_id: String,
    player2_id: String,
    status: {
        type: String,
        enum: ['pending', 'accepted', 'blocked'],
        default: 'pending',
    },
    created_at: { type: Date, default: Date.now },
});
