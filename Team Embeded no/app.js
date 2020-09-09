const express = require('express');
const app = express();

const port = process.env.PORT || 3000;
const mongoose = require('mongoose')
const bodyParser = require('body-parser');

const io = require('socket.io').listen(80)

const db = mongoose.connection;

db.on('error', err => console.log(err));
db.once('open', ()=>{
    console.log("Connected to MongoDB");
});
app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

mongoose.connect('mongodb://localhost:27017/noembeded');

app.use(require('./router/data'))
app.listen(port, () => {
    console.log("Server is open on : " + port);
})

app.post('/updatedata', (req, res) => {
    const { temp, hum, gas } = req.body;

    io.emit('data', {temp: temp, hum: hum, gas: gas})
    
    res.json({ status: 200, message: "IS you ok?" })
});

io.sockets.on('connection', (socket) => {
    console.log("Some client is connected")
})