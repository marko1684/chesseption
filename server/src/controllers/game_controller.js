const gameModel = require("../models/game_model");

const gameController = {
  async create_game(req, res) {
    try {
      const { game_id, players, board_state } = req.body;
      const game = await gameModel.create_game(game_id, players, board_state);
      res.status(201).json(game);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  async make_move(req, res) {
    try {
      const { game_id, move, new_board_state } = req.body;
      const updatedGame = await gameModel.make_move(game_id, move, new_board_state);
      res.json(updatedGame);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  async get_game_state(req, res) {
    try {
      const { gameId } = req.params;
      const game = await gameModel.get_current_state(gameId);
      if (!game) {
        return res.status(404).json({ error: "Game not found" });
      }
      res.json(game);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  async finish_game(req, res) {
    try {
      const { game_id } = req.body;
      const updatedGame = await gameModel.finish_game(game_id);
      res.json(updatedGame);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
};

module.exports = gameController;
