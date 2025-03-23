const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { addWorkout, getWorkouts } = require('../controllers/workoutController');

router.post('/', auth, addWorkout);
router.get('/', auth, getWorkouts);

module.exports = router;