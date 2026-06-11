const express = require('express');
const router = express.Router();
const database = require('../config/database');

router.get('/', async (req, res) => {
  try {
    await database.query('SELECT 1');
    res.status(200).json({
      status: 'ok',
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      error: 'Database connection failed',
    });
  }
});

module.exports = router;
