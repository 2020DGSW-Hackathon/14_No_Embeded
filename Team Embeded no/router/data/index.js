const router = require('express').Router()
const controller = require('./data/data')

router.get('/datas', controller.getAllData);
router.post('/datas/add', controller.addData)
router.get('/datas/max', controller.getMaxData)
router.get('/datas/min', controller.getMinData)
router.get('/datas/test', controller.selectOneHour)
module.exports = router;