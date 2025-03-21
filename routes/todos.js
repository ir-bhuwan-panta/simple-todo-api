const express = require('express');
const router = express.Router();
const Todo = require('../models/Todo');

/**
 * @swagger
 * components:
 *   schemas:
 *     Todo:
 *       type: object
 *       required:
 *         - item
 *         - description
 *         - tag
 *       properties:
 *         item:
 *           type: string
 *           description: The todo item
 *         description:
 *           type: string
 *           description: Detailed description of the todo
 *         tag:
 *           type: string
 *           description: Category or tag for the todo
 *         completed:
 *           type: boolean
 *           description: Todo completion status
 */

/**
 * @swagger
 * /api/todos:
 *   get:
 *     summary: Get all todos
 *     responses:
 *       200:
 *         description: List of todos
 */
router.get('/', async (req, res) => {
  try {
    const todos = await Todo.findAll();
    res.json(todos);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

/**
 * @swagger
 * /api/todos:
 *   post:
 *     summary: Create a new todo
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Todo'
 *     responses:
 *       201:
 *         description: Created todo
 */
router.post('/', async (req, res) => {
  try {
    const newTodo = await Todo.create({
      item: req.body.item,
      description: req.body.description,
      tag: req.body.tag
    });
    res.status(201).json(newTodo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

/**
 * @swagger
 * /api/todos/{id}:
 *   get:
 *     summary: Get a todo by id
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Todo details
 */
router.get('/:id', async (req, res) => {
  try {
    const todo = await Todo.findByPk(req.params.id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });
    res.json(todo);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

/**
 * @swagger
 * /api/todos/{id}:
 *   put:
 *     summary: Update a todo
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/Todo'
 *     responses:
 *       200:
 *         description: Updated todo
 */
router.put('/:id', async (req, res) => {
  try {
    const todo = await Todo.findByPk(req.params.id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });
    await todo.update(req.body);
    res.json(todo);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

/**
 * @swagger
 * /api/todos/{id}:
 *   delete:
 *     summary: Delete a todo
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Todo deleted
 */
router.delete('/:id', async (req, res) => {
  try {
    const todo = await Todo.findByPk(req.params.id);
    if (!todo) return res.status(404).json({ message: 'Todo not found' });
    await todo.destroy();
    res.json({ message: 'Todo deleted' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;