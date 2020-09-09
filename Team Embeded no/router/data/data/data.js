const DataModel = require('../../../models/Data')
const moment = require('moment')

exports.getMaxData = function (req, res) {
    const { type } = req.query;
    
    if(type == 'temp')
    DataModel.find()
        .sort({ temp : -1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
            .catch((err) => res.status(404).json({ status: 404, message: err.message }));
    if(type == 'hum')
    DataModel.find()
        .sort({ hum : -1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
        .catch((err) => res.status(404).json({ status: 404, message: err.message }));
    if(type == 'gas')
    DataModel.find()
        .sort({ gas : -1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
        .catch((err) => res.status(404).json({ status: 404, message: err.message }));
}
exports.getMinData = function (req, res) {
    const { type } = req.query;
    
    if(type == 'temp')
    DataModel.find()
        .sort({ temp : 1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
            .catch((err) => res.status(404).json({ status: 404, message: err.message }));
    if(type == 'hum')
    DataModel.find()
        .sort({ hum : 1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
        .catch((err) => res.status(404).json({ status: 404, message: err.message }));
    if(type == 'gas')
    DataModel.find()
        .sort({ gas : 1 })
        .limit(1)
        .then((result) => res.json({ status: 200, message: " Successfully find data", data: result }))
        .catch((err) => res.status(404).json({ status: 404, message: err.message }));
}
exports.getAllData = function (req, res) {
    const max = req.query.max;
    console.log(max);
    const onError = (err) => {
        res.status(404).json({ 
            status: 404,
            message: err.message
        })
    }
    const result = (result) => {
        res.json({
            status: 200,
            message: "Successfully retrieved all data",
            data: result
        })
    }
    DataModel.find().sort({uploaded: 'desc'}).limit(max ? max * 1 : 10).then(result).catch(onError)
}
exports.selectOneHour = function (req, res) {
    const date = Date.now()
    console.log(Date(moment().toDate()))
    DataModel.find()
        .sort({ uploaded: -1 })
        .limit(120)
        .then(result => {
            var arr = [];
            for (var i = 0; i < 120; i += 12) arr[i / 12] = { temp: result[i].temp, hum: result[i].hum, gas: result[i].gas, uploaded: result[i].uploaded };
            res.json({ status: 200, message: "Successfully selected one hour", data: arr })
        })
        .catch(err => res.json({ status: 404, message: err.message }));
}
exports.addData = function (req, res) {
    console.log("OK Received");
    const { temp, hum, gas } = req.body;
    console.log(temp + " < " + hum + " < " + gas);
    const date = Date.now() + (3600000 * 9);
    console.log(date)
    const model = new DataModel();
    model.temp = temp;
    model.hum = hum;
    model.gas = gas;
    model.uploaded = date;

    const result = (result) => {
        res.json({
            status: 200,
            message: "Successfully added data",
            data: result
        })
    }
    const onError = (err) => {
        res.status(404).json({
            status: 404,
            message: err.message
        })
    }
    model.save().then(result).catch(onError);
}


