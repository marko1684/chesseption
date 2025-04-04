const express = require('express');
const verifyToken = require('./middleware/verifyToken');

const app = express();
app.use(express.json());

app.post('/start-game', verifyToken, async (req, res) => {
    const playerId = req.user.uid; // Google's Firebase UID
    // You can now add this user to a game or check their record
    res.json({ message: `Game started for ${playerId}` });
});

app.listen(3000, () => console.log('Game server listening on port 3000'));
