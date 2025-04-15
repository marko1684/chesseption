// const express = require('express');
// const verifyToken = require('./middleware/verifyToken');

// const app = express();
// app.use(express.json());

// app.post('/start-game', verifyToken, async (req, res) => {
//     const playerId = req.user.uid; // Google's Firebase UID
//     // You can now add this user to a game or check their record
//     res.json({ message: `Game started for ${playerId}` });
// });

// app.listen(3000, () => console.log('Game server listening on port 3000'));

const player_model = require('../models/player_model');

const player_controller = {
    async login(req, res) {
        try {
            const { uid, displayName, email, photoURL } = req.body;
            const player = await player_model.login(uid, displayName, email, photoURL);
            res.status(201).json(player);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    // async logout(req, res) {
    //     try {
    //     } catch (error) {
    //         res.status(500).json({ error: error.message });
    //     }
    // },

    // async register(req, res) {
    //     try {
    //     } catch (error) {
    //         res.status(500).json({ error: error.message });
    //     }
    // },
};

module.exports = player_controller;
