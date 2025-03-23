const Workout = require('../models/Workout');


exports.addWorkout = async (req, res) => {
  const { type, duration, distance, calories } = req.body;
  const userId = req.user.id;
  try {
    const workout = new Workout({ userId, type, duration, distance, calories });
    await workout.save();
    res.status(201).json(workout);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getWorkouts = async (req, res) => {
  const userId = req.user.id;
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10; 
  const skip = (page - 1) * limit; 

  try {
 
    const workouts = await Workout.find({ userId })
      .sort({ date: -1 }) 
      .skip(skip)         
      .limit(limit);      

    
    const totalWorkouts = await Workout.countDocuments({ userId });
    const totalPages = Math.ceil(totalWorkouts / limit);

   
    res.json({
      workouts,
      currentPage: page,
      totalPages,
      totalWorkouts,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};