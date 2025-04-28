const Player = require('../config/player.js');

const player_model = {
    async login(uid, display_name, email, photo_URL) {
        if (!uid) {
            throw new Error('UID is required for login');
        }

        let player = await Player.findOne({ uid });

        if (!player) {
            player = await Player.create({
                uid,
                display_name,
                email,
                photo_URL,
            });
        }
        player = await Player.findOne({ uid });

        return player;
    },
};

module.exports = player_model;
