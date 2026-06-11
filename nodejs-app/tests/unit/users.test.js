const request = require('supertest');
const app = require('../../src/app');
const db = require('../../src/config/database');

jest.mock('../../src/config/database');

describe('Users API', () => {
  beforeEach(() => {
    db.query.mockReset();
  });

  describe('POST /users', () => {
    it('should create a user', async () => {
      db.query.mockResolvedValueOnce({ rows: [{ id: 1, name: 'Test User', email: 'test@example.com' }] });

      const response = await request(app)
        .post('/users')
        .send({ name: 'Test User', email: 'test@example.com' });

      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty('id');
      expect(response.body.email).toBe('test@example.com');
    });

    it('should reject invalid email', async () => {
      const response = await request(app)
        .post('/users')
        .send({ name: 'Test', email: 'invalid' });

      expect(response.status).toBe(400);
    });
  });

  describe('GET /users/:id', () => {
    it('should return a user', async () => {
      db.query.mockResolvedValueOnce({
        rowCount: 1,
        rows: [{ id: 1, name: 'Test User', email: 'test@example.com' }],
      });

      const response = await request(app).get('/users/1');

      expect(response.status).toBe(200);
      expect(response.body.email).toBe('test@example.com');
    });

    it('should return 404 when user is missing', async () => {
      db.query.mockResolvedValueOnce({ rowCount: 0, rows: [] });

      const response = await request(app).get('/users/999');

      expect(response.status).toBe(404);
    });
  });

  describe('PUT /users/:id', () => {
    it('should update a user', async () => {
      db.query.mockResolvedValueOnce({
        rowCount: 1,
        rows: [{ id: 1, name: 'Updated User', email: 'updated@example.com' }],
      });

      const response = await request(app)
        .put('/users/1')
        .send({ name: 'Updated User', email: 'updated@example.com' });

      expect(response.status).toBe(200);
      expect(response.body.name).toBe('Updated User');
    });

    it('should return 404 when updating a missing user', async () => {
      db.query.mockResolvedValueOnce({ rowCount: 0, rows: [] });

      const response = await request(app)
        .put('/users/999')
        .send({ name: 'Missing User', email: 'missing@example.com' });

      expect(response.status).toBe(404);
    });
  });

  describe('DELETE /users/:id', () => {
    it('should delete a user', async () => {
      db.query.mockResolvedValueOnce({ rowCount: 1 });

      const response = await request(app).delete('/users/1');

      expect(response.status).toBe(204);
    });

    it('should reject invalid ids', async () => {
      const response = await request(app).delete('/users/0');

      expect(response.status).toBe(400);
    });
  });
});
