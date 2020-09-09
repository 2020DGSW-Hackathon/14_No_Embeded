const mongoose = require("mongoose");
const schema = mongoose.Schema;

var DataSchema = new schema({
    temp: Number,
    hum: Number,
    gas: Number,
    uploaded: Date,
})

module.exports = mongoose.model("Temp", DataSchema);