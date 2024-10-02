const mongoose = require("mongoose");

mongoose
  .connect("mongodb://mongo/mydatabase", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("DB is connected"))
  .catch((err) => console.error(err));

module.exports = mongoose;
