const express = require('express');
const router = express.Router();
const player_controller = require('../controllers/player_controller');

router.post('/register', player_controller.register);
router.post('/login', player_controller.login);
router.post('/logout', player_controller.logout);

module.exports = router;
