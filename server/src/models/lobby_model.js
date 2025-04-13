const Lobby = require('../config/lobby.js');
const game_model = require('./game_model.js');

const lobby_model = {
    async join_lobby(player_id, game_type) {
        let lobby = await Lobby.findOne({
            game_type,
            $expr: { $lt: [{ $size: '$players' }, game_type] },
        });
        if (!lobby) {
            lobby = new Lobby({ game_type, players: [] });
        }

        lobby.players.push({ player_id });
        await lobby.save();

        if (lobby.players.length === game_type) {
            game_model.create_game(lobby);
            await Lobby.deleteOne({ _id: lobby._id });
        }

        return lobby;
    },
};

module.exports = lobby_model;
