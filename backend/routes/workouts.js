const express = require('express');
const router = express.Router();
const workoutsController = require('../controllers/workouts'); // Import the controller

router.post('/workouts', workoutsController.addWorkout); // Ensure this is correct
router.get('/workouts', workoutsController.getWorkouts);

module.exports = router;