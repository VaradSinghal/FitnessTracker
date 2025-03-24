const Step = require('../models/Step');

const addSteps = async (req, res) => {
  const { steps, date } = req.body;
  if (!steps) {
    return res.status(400).json({ message: 'Steps are required' });
  }
  try {
    const newStep = new Step({
      user: req.user.id,
      steps,
      date: date || Date.now(),
    });
    await newStep.save();
    console.log('Step saved:', newStep);
    res.status(201).json(newStep);
  } catch (err) {
    console.error('Error saving step:', err);
    res.status(500).json({ message: err.message });
  }
};

const getSteps = async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const skip = (page - 1) * limit;

  try {
    const steps = await Step.find({ user: req.user.id })
      .sort({ date: -1 })
      .skip(skip)
      .limit(limit);
    res.json({ steps });
  } catch (err) {
    console.error('Error fetching steps:', err);
    res.status(500).json({ message: err.message });
  }
};

module.exports = { addSteps, getSteps }; // Export the functions