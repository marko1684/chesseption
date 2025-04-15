const player = require('../config/player.js');

const player_model = {
    async login(uid, displayName, email, photoURL) {
        if (!uid) {
            throw new Error('UID is required for login');
        }

        let player = await Player.findOne({ uid });

        if (!player) {
            player = await Player.create({
                uid,
                displayName,
                email,
                photoURL,
            });
        }

        return player;
    },
};

module.exports = player_model;
