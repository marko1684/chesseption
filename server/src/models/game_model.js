const Game = require('../config/db');
const { v4: uuidv4 } = require('uuid');

const starting_positions = ['a4k', 'h5k', 'e1k', 'd8k'];

const possible_positions = [
    'a1',
    'a2',
    'a3',
    // 'a4',
    'a5',
    'a6',
    'a7',
    'a8',
    'b1',
    'b2',
    'b3',
    'b4',
    'b5',
    'b6',
    'b7',
    'b8',
    'c1',
    'c2',
    'c3',
    'c4',
    'c5',
    'c6',
    'c7',
    'c8',
    'd1',
    'd2',
    'd3',
    'd4',
    'd5',
    'd6',
    'd7',
    // 'd8',
    // 'e1',
    'e2',
    'e3',
    'e4',
    'e5',
    'e6',
    'e7',
    'e8',
    'f1',
    'f2',
    'f3',
    'f4',
    'f5',
    'f6',
    'f7',
    'f8',
    'g1',
    'g2',
    'g3',
    'g4',
    'g5',
    'g6',
    'g7',
    'g8',
    'h1',
    'h2',
    'h3',
    'h4',
    // 'h5',
    'h6',
    'h7',
    'h8',
];

const game_model = {
    async create_game(game_id, players, board_state) {
        board_state.diamond_position = possible_positions[Math.floor(Math.random() * possible_positions.length)];
        return await Game.create({
            game_id,
            players,
            board_state: board_state,
        });
    },

    async create_game(lobby) {
        const player_positions = new Map();
        lobby.players.forEach((player, index) => {
            player_positions.set(player.player_id, {
                position: starting_positions[index],
                points: 0,
            });
        });
        const new_game = new Game({
            game_id: lobby._id,
            players: lobby.players,
            player_id: '123',
            next_player: lobby.players[0]['player_id'],
            board_state: {
                player_positions,
                diamond_position: possible_positions[Math.floor(Math.random() * possible_positions.length)],
            },
            accepted: lobby.players.map(() => ({ accept: 0 })),
            last_move: null,
            status: 'in_progress',
        });

        await new_game.save();
    },

    async make_move(game_id, player_id, lied, box, new_board_state) {
        const current_game = await Game.findOne({ game_id: game_id });
        if (!current_game) {
            throw new Error('Game not found');
        }

        current_game.last_move.board_state.player_positions = new Map();
        for (const [player_id, data] of current_game.board_state.player_positions.entries()) {
            current_game.last_move.board_state.player_positions.set(player_id, {
                position: data.position,
                points: data.points,
            });
        }

        current_game.last_move.board_state.diamond_position = current_game.board_state.diamond_position;

        current_game.board_state.player_positions = new Map();
        for (const [player_id, data] of Object.entries(new_board_state.player_positions)) {
            current_game.board_state.player_positions.set(player_id, {
                position: data.position,
                points: data.points,
            });
        }
        console.log('Incoming box:', box);

        // current_game.box = box;

        if (Array.isArray(box)) {
            for (let i = 0; i < box.length; i++) {
                current_game.box[i] = box[i];
            }
        } else {
            console.log('error');
            throw new Error('Invalid box data');
        }

        current_game.board_state.diamond_position = new_board_state.diamond_position;

        current_game.player_id = player_id;
        current_game.lied = lied;

        // const all_gone = current_game.box.every((entry) => entry === 0);
        // if (all_gone) {
        //     current_game.box = current_game.box.map(() => 1);
        // }

        const playerIndex = current_game.players.findIndex((p) => p.player_id === player_id);
        if (playerIndex === -1) throw new Error('Player not found in game');
        current_game.accepted[playerIndex].accept = 1;
        current_game.next_player = current_game.players[(playerIndex + 1) % current_game.players.length]['player_id'];
        await current_game.save();
        return current_game;
    },

    async get_current_state(game_id) {
        let current_game = await Game.findOne({ game_id: game_id });
        if (!current_game) {
            return -1;
        }
        return current_game;
    },

    async finish_game(game_id) {
        let current_game = await Game.findOne({ game_id: game_id });
        if (!current_game) {
            throw new Error('Game not found');
        }
        current_game.status = 'finished';
        await current_game.save();
        return current_game;
    },

    async challenge_move(game_id, player1_id, player2_id) {
        let current_game = await Game.findOne({ game_id: game_id });
        if (!current_game) {
            throw new Error('Game not found');
        }

        if (current_game.lied === true) {
            current_game.status = 'in_progress';

            current_game.board_state.player_positions = new Map();
            for (const [playerId, data] of current_game.last_move.board_state.player_positions.entries()) {
                current_game.board_state.player_positions.set(playerId, {
                    position: data.position,
                    points: data.points,
                });
            }
            current_game.board_state.diamond_position = current_game.last_move.board_state.diamond_position;

            // current_game.board_state.player_positions.get(player1_id).points += 1;
            current_game.board_state.player_positions.get(player2_id).points -= 1;
        } else {
            current_game.board_state.player_positions.get(player1_id).points -= 1;
        }

        current_game.accepted = current_game.players.map(() => ({ accept: 0 }));
        current_game.lied = false;
        await current_game.save();
        return current_game;
    },

    async accept_move(game_id, player_id) {
        const current_game = await Game.findOne({ game_id: game_id });
        if (!current_game) {
            throw new Error('Game not found');
        }

        const index = current_game.players.findIndex((player) => player.player_id === player_id);
        current_game.accepted[index].accept = 1;
        const allAccepted = current_game.accepted.every((entry) => entry.accept === 1);
        if (allAccepted === true) {
            current_game.accepted = current_game.accepted.map(() => ({
                accept: 0,
            }));
            current_game.lied = false;
        }
        await current_game.save();
        return current_game;
    },
};

module.exports = game_model;
