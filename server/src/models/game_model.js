const Game = require('../config/db')

const game_model = {
    async create_game(game_id, players, board_state) {
        return await Game.create({ game_id, players, board_state: board_state })
    },

    async make_move(game_id, move, new_board_state) {
        const current_game = await Game.findById(game_id)
        if (!current_game) {
            throw new Error('Game not found')
        }
        return await Game.findByIdAndUpdate(
            game_id,
            {
                // potentially add pending to status when players accept the move
                $set: {
                    last_move: move,
                    board_state: new_board_state,
                },
            },
            { new: true }
        )
    },

    async get_current_state(game_id) {
        return await Game.findById(game_id)
    },

    async finish_game(game_id) {
        return await Game.findOneAndUpdate(
            { game_id: gameId },
            { status: 'finished' },
            { new: true }
        )
    },
}
