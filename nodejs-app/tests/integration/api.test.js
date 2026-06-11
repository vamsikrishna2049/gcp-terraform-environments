const request = require('supertest');
const app = require('../../src/app');
const db = require('../../src/config/database');

jest.mock('../../src/config/database');

describe('API integration tests', () => {
  beforeEach(() => {
    db.query.mockReset();
  });

  it('returns health status ok', async () => {
    db.query.mockResolvedValueOnce({ rows: [{ '?column?': 1 }] });

    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('ok');
  });

  it('returns unhealthy when database query fails', async () => {
    db.query.mockRejectedValueOnce(new Error('connection failed'));

    const response = await request(app).get('/health');

    expect(response.status).toBe(503);
    expect(response.body.error).toBe('Database connection failed');
  });
});
