const errorHandler = require('../../src/middleware/errorHandler');
const rateLimiter = require('../../src/middleware/rateLimiter');
const sensitiveDataRedactor = require('../../src/middleware/sensitiveDataRedactor');

const createResponse = () => {
  const res = {
    statusCode: null,
    body: null,
    status(code) {
      this.statusCode = code;
      return this;
    },
    json(body) {
      this.body = body;
      return this;
    },
  };
  return res;
};

describe('Middleware', () => {
  it('redacts sensitive request fields', () => {
    const req = {
      body: { username: 'user', password: 'secret' },
      headers: { authorization: 'Bearer token' },
    };
    const next = jest.fn();

    sensitiveDataRedactor(req, {}, next);

    expect(req.body.password).toBe('REDACTED');
    expect(req.headers.authorization).toBe('REDACTED');
    expect(next).toHaveBeenCalled();
  });

  it('returns generic messages for server errors', () => {
    const res = createResponse();

    errorHandler(new Error('database password leaked'), {}, res, jest.fn());

    expect(res.statusCode).toBe(500);
    expect(res.body.message).toBe('Internal Server Error');
  });

  it('preserves client error messages', () => {
    const res = createResponse();
    const err = new Error('Invalid request');
    err.status = 400;

    errorHandler(err, {}, res, jest.fn());

    expect(res.statusCode).toBe(400);
    expect(res.body.message).toBe('Invalid request');
  });

  it('rate limits clients that exceed the request budget', () => {
    const req = { ip: '192.0.2.10' };
    const res = createResponse();
    const next = jest.fn();

    for (let i = 0; i < 100; i += 1) {
      rateLimiter(req, createResponse(), next);
    }

    rateLimiter(req, res, next);

    expect(res.statusCode).toBe(429);
    expect(res.body.message).toBe('Too many requests');
  });
});
