const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { addSteps, getSteps } = require('../controllers/stepController');

router.post('/', auth, addSteps);
router.get('/', auth, getSteps);

module.exports = router;