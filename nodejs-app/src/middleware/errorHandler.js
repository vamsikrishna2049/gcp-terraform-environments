const errorHandler = (err, req, res, _next) => {
  const status = err.status || 500;
  const isClientError = status >= 400 && status < 500;
  const message = isClientError ? err.message : 'Internal Server Error';
  console.error(`Error [${status}]: ${message}`);
  res.status(status).json({
    status,
    message,
    timestamp: new Date().toISOString(),
  });
};

module.exports = errorHandler;
