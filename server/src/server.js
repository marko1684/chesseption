const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const uuidv4 = require('uuid');

require('dotenv').config();

const game_routes = require('./routes/game_routes');
const player_routes = require('./routes/player_routes');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/game', game_routes);
app.use('/player', player_routes);

const PORT = process.env.PORT || 3000;

require('dotenv').config();

mongoose
    .connect(process.env.MONGO_URI || 'mongodb://localhost:27017/chesseption', {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    })
    .then(() => console.log('Connected to MongoDB'))
    .catch((err) => console.error('MongoDB connection error:', err));

app.listen(PORT, () => console.log(`Server running on port ${PORT}!`));
