const game_model = require('../models/game_model');
const lobby_model = require('../models/lobby_model');

const gameController = {
    async create_game(req, res) {
        try {
            const { game_id, players, board_state } = req.body;
            const game = await game_model.create_game(
                game_id,
                players,
                board_state
            );
            res.status(201).json(game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async make_move(req, res) {
        try {
            const { game_id, move, new_board_state } = req.body;
            const updated_game = await game_model.make_move(
                game_id,
                move,
                new_board_state
            );
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async get_game_state(req, res) {
        try {
            const { gameId } = req.params;
            const game = await game_model.get_current_state(gameId);
            if (!game) {
                return res.status(404).json({ error: 'Game not found' });
            }
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
    async challange_move(req, res) {
        try {
            const { game_id, player1_id, player2_id } = req.body;
            const updated_game = await game_model.challange_move(
                game_id,
                player1_id,
                player2_id
            );
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
    async accept_move(req, res) {
        try {
            const { game_id, player_id } = req.body;
            const updated_game = await game_model.accept_move(
                game_id,
                player_id
            );
            res.json(updated_game);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },

    async join_lobby(player_id, game_type) {
        try {
            const { player_id, game_type } = req.body;
            const game_id = await lobby_model.join_lobby(game_id, player_id);
            res.json(game_id);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    },
};

module.exports = gameController;
