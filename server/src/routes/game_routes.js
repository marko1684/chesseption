const express = require('express')
const router = express.Router()
const game_controller = require('../controllers/game_controller')

// routes

router.post('/create', game_controller.create_game)
router.post('/join', game_controller.join_game)
router.post('/make_move', game_controller.make_move)
router.post('/challenge_move', game_controller.challenge_move)

// I guess we will need it
router.get('state/:gameId', game_controller.get_game_state)
router.post('/finish', game_controller.finish_game)

module.exports = router
