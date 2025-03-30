const express = require("express");
const cors = require("cors");
require("dotenv").config();

const game_routes = require("./routes/game_routes");
const player_routes = require("./routes/player_routes");

const app = express();
app.use(cors());
app.use(express.json());

app.use("/game", game_routes);
app.use("/player", player_routes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => console.log(`Server running on port ${PORT}!`));
