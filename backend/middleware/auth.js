const jwt = require('jsonwebtoken');
const { tokenBlacklist } = require('../routes/auth');

module.exports = function (req, res, next) {
  const token = req.header('x-auth-token');
  if (!token) return res.status(401).json({ msg: 'No token, authorization denied' });

  // Check if token is blacklisted
  if (tokenBlacklist.includes(token)) {
    return res.status(401).json({ msg: 'Token has been invalidated' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid' });
  }
};