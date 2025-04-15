const mongoose = require('mongoose');

const playerSchema = new mongoose.Schema({
    uid: { type: String, required: true, unique: true }, // Firebase UID
    display_name: String,
    email: String,
    photo_URL: String,
    createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Player', playerSchema);
