const User = require('../../src/models/user');

describe('User model', () => {
  it('maps user properties', () => {
    const user = new User({ id: 1, name: 'Test User', email: 'test@example.com' });

    expect(user).toEqual({
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
    });
  });
});
