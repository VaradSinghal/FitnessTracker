const mongoose = require('mongoose');

const workoutSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { type: String, required: true }, // e.g., "Running", "Cycling"
  duration: { type: Number, required: true }, // in minutes
  distance: { type: Number }, // in kilometers
  calories: { type: Number }, // optional, calculated
  date: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Workout', workoutSchema);