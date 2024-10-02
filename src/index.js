const express = require("express");
const mongoose = require("./database");

const app = express();

// Middleware
app.use(express.json());

// Rutas
app.get("/", (req, res) => {
  res.send("Hello World from Node.js with MongoDB!");
});

// Puerto
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
