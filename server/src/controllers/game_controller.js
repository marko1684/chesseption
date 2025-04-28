const game_model = require('../models/game_model');
const lobby_model = require('../models/lobby_model');

const gameController = {
    async create_game(req, res) {
        try {
            const { game_id, players, board_state } = req.body;
            const game = await game_model.create_game(game_id, players, board_state);
            res.status(201).json(game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async make_move(req, res) {
        try {
            const { game_id, player_id, lied, new_board_state } = req.body;
            const updated_game = await game_model.make_move(game_id, player_id, lied, new_board_state);
            console.log(req.body);
            console.log('qurac');
            console.log(updated_game);
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async get_game_state(req, res) {
        try {
            const { game_id } = req.params;
            console.log('Game ID:', game_id);
            const game = await game_model.get_current_state(game_id);
            // if (!game) {
            //     return res.status(404).json({ error: 'Game not found' });
            // }
            res.json(game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async finish_game(req, res) {
        try {
            const { game_id } = req.body;
            const updated_game = await game_model.finish_game(game_id);
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
    async challenge_move(req, res) {
        try {
            const { game_id, player1_id, player2_id } = req.body;
            const updated_game = await game_model.challenge_move(game_id, player1_id, player2_id);
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
    async accept_move(req, res) {
        try {
            const { game_id, player_id } = req.body;
            const updated_game = await game_model.accept_move(game_id, player_id);
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async join_lobby(req, res) {
        try {
            const { player_id, game_type } = req.body;
            const lobby = await lobby_model.join_lobby(player_id, game_type);
            res.json(lobby);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
};

module.exports = gameController;
