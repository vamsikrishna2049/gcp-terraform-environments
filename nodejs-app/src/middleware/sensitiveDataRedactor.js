const sensitiveDataRedactor = (req, res, next) => {
  if (req.body && typeof req.body === 'object') {
    const redacted = { ...req.body };
    if (redacted.password) {
      redacted.password = 'REDACTED';
    }
    req.body = redacted;
  }
  if (req.headers.authorization) {
    req.headers.authorization = 'REDACTED';
  }
  next();
};

module.exports = sensitiveDataRedactor;
