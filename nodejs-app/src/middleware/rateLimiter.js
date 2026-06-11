const rateLimiters = new Map();
const WINDOW_MS = 60000;
const MAX_REQUESTS = 100;
const MAX_KEYS = 10000;

const rateLimiter = (req, res, next) => {
  const key = req.ip;
  const now = Date.now();

  if (rateLimiters.size > MAX_KEYS) {
    for (const [clientKey, clientEntry] of rateLimiters.entries()) {
      if (now - clientEntry.start > WINDOW_MS) {
        rateLimiters.delete(clientKey);
      }
    }
  }

  const entry = rateLimiters.get(key) || { count: 0, start: now };

  if (now - entry.start > WINDOW_MS) {
    entry.count = 1;
    entry.start = now;
  } else {
    entry.count += 1;
  }

  rateLimiters.set(key, entry);

  if (entry.count > MAX_REQUESTS) {
    return res.status(429).json({ message: 'Too many requests' });
  }

  next();
};

module.exports = rateLimiter;
