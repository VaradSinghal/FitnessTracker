const mongoose = require('mongoose');

const stepSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  date: { type: Date, required: true },
  steps: { type: Number, required: true },
});

module.exports = mongoose.model('StepData', stepSchema);