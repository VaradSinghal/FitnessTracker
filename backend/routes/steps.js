const express = require('express');
const router = express.Router();
const stepsController = require('../controllers/steps'); // Import the controller

router.post('/steps', stepsController.addSteps);
router.get('/steps', stepsController.getSteps);

module.exports = router;