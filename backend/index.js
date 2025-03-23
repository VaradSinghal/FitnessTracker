const express = require('express');
const connectDB = require('./config/db');
const authRoutes = require('./routes/auth');
const stepsRoutes = require('./routes/steps');
const workoutsRoutes = require('./routes/workouts');

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/steps', stepsRoutes);
app.use('/api/workouts', workoutsRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));