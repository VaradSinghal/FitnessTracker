const StepData = require('../models/StepData');

exports.getSteps = async (req, res) => {
  const userId = req.user.id;
  const page = parseInt(req.query.page) || 1; 
  const limit = parseInt(req.query.limit) || 10; 
  const skip = (page - 1) * limit;

  try {
    
    const steps = await StepData.find({ userId })
      .sort({ date: -1 }) 
      .skip(skip)         
      .limit(limit);      

    const totalSteps = await StepData.countDocuments({ userId });
    const totalPages = Math.ceil(totalSteps / limit);

    res.json({
      steps,
      currentPage: page,
      totalPages,
      totalSteps,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


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