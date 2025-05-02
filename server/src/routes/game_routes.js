const express = require('express');
const router = express.Router();
const game_controller = require('../controllers/game_controller');

// routes

router.post('/create', game_controller.create_game);
router.post('/join_lobby', game_controller.join_lobby);
router.post('/leave_lobby', game_controller.leave_lobby);
router.post('/make_move', game_controller.make_move);
router.post('/challenge_move', game_controller.challenge_move);
router.post('/accept_move', game_controller.accept_move);

// I guess we will need it
router.get('/state/:game_id', game_controller.get_game_state);
router.post('/finish_game', game_controller.finish_game);

module.exports = router;
