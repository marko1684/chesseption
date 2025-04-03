const Game = require('../config/db');

const game_model = {
    async create_game(game_id, players, board_state) {
        return await Game.create({
            game_id,
            players,
            board_state: board_state,
        });
    },

    async make_move(game_id, move, new_board_state) {
        const current_game = await Game.findById(game_id);
        if (!current_game) {
            throw new Error('Game not found');
        }
        current_game.last_move.board_state = current_game.board_state;
        current_game.board_state = new_board_state;
        current_game.last_move.player_id = move.player_id;
        current_game.last_move.lied = move.lied;
        await current_game.save();
        return current_game;
    },

    async get_current_state(game_id) {
        let current_game = await Game.findById(game_id);
        if (!current_game) {
            throw new Error('Game not found');
        }
        return current_game;
    },

    async finish_game(game_id) {
        let current_game = await Game.findById(game_id);
        if (!current_game) {
            throw new Error('Game not found');
        }
        current_game.status = 'finished';
        await current_game.save();
        return current_game;
    },

    async challenge_move(game_id, player1_id, player2_id) {
        let current_game = await Game.findById(game_id);
        if (!current_game) {
            throw new Error('Game not found');
        }

        if (current_game.last_move.lied === true) {
            current_game.status = 'challangedblabla';

            current_game.last_move.lied = false;
            current_game.board_state = current_game.last_move.board_state;

            current_game.board_state.player_positions.get(player1_id).points +=
                1;
            current_game.board_state.player_positions.get(player2_id).points -=
                1;
        } else {
            current_game.board_state.player_positions.get(player1_id).points -=
                1;
        }

        await current_game.save();
    },
};
