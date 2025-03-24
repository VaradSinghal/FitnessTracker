const Workout = require('../models/Workout');

const addWorkout = async (req, res) => {
  const { name, duration, calories } = req.body;
  if (!name || !duration || !calories) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    const newWorkout = new Workout({
      user: req.user.id,
      name,
      duration,
      calories,
    });
    await newWorkout.save();
    console.log('Workout saved:', newWorkout);
    res.status(201).json(newWorkout);
  } catch (err) {
    console.error('Error saving workout:', err);
    res.status(500).json({ message: err.message });
  }
};

const getWorkouts = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const skip = (page - 1) * limit;

  try {
    const workouts = await Workout.find({ user: req.user.id })
      .sort({ date: -1 })
      .skip(skip)
      .limit(limit);
    res.json({ workouts });
  } catch (err) {
    console.error('Error fetching workouts:', err);
    res.status(500).json({ message: err.message });
  }
};

module.exports = { addWorkout, getWorkouts }; // Export the functions