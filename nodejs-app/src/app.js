const express = require('express');
const errorHandler = require('./middleware/errorHandler');
const requestLogger = require('./middleware/requestLogger');
const rateLimiter = require('./middleware/rateLimiter');
const sensitiveDataRedactor = require('./middleware/sensitiveDataRedactor');
const securityHeaders = require('./middleware/securityHeaders');

const app = express();

app.disable('x-powered-by');
app.set('trust proxy', 1);

app.use(securityHeaders);
app.use(express.json({ limit: '100kb' }));
app.use(requestLogger);
app.use(rateLimiter);
app.use(sensitiveDataRedactor);

app.use('/health', require('./routes/health'));
app.post('/users', require('./routes/users').create);
app.get('/users/:id', require('./routes/users').read);
app.put('/users/:id', require('./routes/users').update);
app.delete('/users/:id', require('./routes/users').delete);

app.use(errorHandler);

const PORT = process.env.PORT || 3000;
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;
