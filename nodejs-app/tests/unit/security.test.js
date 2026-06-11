const request = require('supertest');
const app = require('../../src/app');
const db = require('../../src/config/database');

jest.mock('../../src/config/database');

describe('Security controls', () => {
  beforeEach(() => {
    db.query.mockReset();
  });

  it('sets security headers and hides framework fingerprinting', async () => {
    db.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });

    const response = await request(app).get('/health');

    expect(response.headers['x-content-type-options']).toBe('nosniff');
    expect(response.headers['x-frame-options']).toBe('DENY');
    expect(response.headers['content-security-policy']).toContain('default-src \'none\'');
    expect(response.headers['x-powered-by']).toBeUndefined();
  });

  it('rejects invalid user ids before querying the database', async () => {
    const response = await request(app).get('/users/not-a-number');

    expect(response.status).toBe(400);
    expect(db.query).not.toHaveBeenCalled();
  });

  it('normalizes user email before persistence', async () => {
    db.query.mockResolvedValueOnce({
      rows: [{ id: 1, name: 'Test User', email: 'test@example.com' }],
    });

    const response = await request(app)
      .post('/users')
      .send({ name: ' Test User ', email: 'TEST@EXAMPLE.COM ' });

    expect(response.status).toBe(201);
    expect(db.query.mock.calls[0][1]).toEqual(['Test User', 'test@example.com']);
  });
});
