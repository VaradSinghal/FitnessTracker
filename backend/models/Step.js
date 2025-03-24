const mongoose = require('mongoose');

const stepSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  steps: { type: Number, required: true },
  date: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Step', stepSchema);