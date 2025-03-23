const StepData = require('../models/StepData');

exports.addSteps = async (req, res) => {
  const { steps, date } = req.body;
  const userId = req.user.id;
  try {
    const stepData = new StepData({ userId, steps, date });
    await stepData.save();
    res.status(201).json(stepData);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getSteps = async (req, res) => {
  const userId = req.user.id;
  try {
    const steps = await StepData.find({ userId }).sort({ date: -1 });
    res.json(steps);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};