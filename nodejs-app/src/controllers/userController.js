const pool = require('../config/database');

const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const NAME_PATTERN = /^[a-zA-Z0-9 .'-]{1,100}$/;
const ID_PATTERN = /^[1-9][0-9]{0,18}$/;

const isValidUserPayload = ({ name, email }) => (
  typeof name === 'string'
  && typeof email === 'string'
  && NAME_PATTERN.test(name.trim())
  && EMAIL_PATTERN.test(email.trim())
);

const isValidId = (id) => ID_PATTERN.test(id);

const create = async (req, res, next) => {
  try {
    const { name, email } = req.body;
    if (!isValidUserPayload({ name, email })) {
      return res.status(400).json({ message: 'Invalid user payload' });
    }

    const result = await pool.query(
      'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING id, name, email',
      [name.trim(), email.trim().toLowerCase()]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

const read = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!isValidId(id)) {
      return res.status(400).json({ message: 'Invalid user id' });
    }

    const result = await pool.query('SELECT id, name, email FROM users WHERE id = $1', [id]);
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(200).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

const update = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, email } = req.body;
    if (!isValidId(id) || !isValidUserPayload({ name, email })) {
      return res.status(400).json({ message: 'Invalid user payload' });
    }

    const result = await pool.query(
      'UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING id, name, email',
      [name.trim(), email.trim().toLowerCase(), id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.status(200).json(result.rows[0]);
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    const { id } = req.params;
    if (!isValidId(id)) {
      return res.status(400).json({ message: 'Invalid user id' });
    }

    const result = await pool.query('DELETE FROM users WHERE id = $1', [id]);
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.status(204).send();
  } catch (error) {
    next(error);
  }
};

module.exports = {
  create,
  read,
  update,
  delete: remove,
};
