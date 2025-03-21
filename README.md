# Todo API

A RESTful API for managing todo items built with Node.js, Express, and Sequelize.

## Features

- Create, read, update, and delete todo items
- Mark todos as complete/incomplete
- Filter todos by tags
- Detailed todo descriptions
- Timestamps for todo creation

## Prerequisites

- Node.js (v12 or higher)
- npm (Node Package Manager)
- SQLite (database)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd todo-api
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. The application uses SQLite as the database, which will be automatically created when you start the server.

4. Start the server:
   ```bash
   npm start
   ```

## API Endpoints

### Get all todos
```
GET /api/todos
```
Response:
```json
[
  {
    "id": 1,
    "item": "Buy groceries",
    "description": "Get milk, bread, and eggs",
    "tag": "shopping",
    "completed": false,
    "createdAt": "2023-01-01T12:00:00.000Z"
  }
]
```

### Create a new todo
```
POST /api/todos
```
Request body:
```json
{
  "item": "Buy groceries",
  "description": "Get milk, bread, and eggs",
  "tag": "shopping"
}
```

### Get a specific todo
```
GET /api/todos/:id
```

### Update a todo
```
PUT /api/todos/:id
```
Request body:
```json
{
  "item": "Buy groceries",
  "description": "Get milk, bread, and eggs",
  "tag": "shopping",
  "completed": true
}
```

### Delete a todo
```
DELETE /api/todos/:id
```

## Data Model

Todo items have the following structure:

- `item`: String (required) - The title of the todo item
- `description`: String (required) - Detailed description of the todo
- `tag`: String (required) - Category or tag for the todo
- `completed`: Boolean (defaults to false) - Status of the todo
- `createdAt`: Date (auto-generated) - Timestamp when the todo was created

## Error Handling

The API returns appropriate HTTP status codes:

- 200: Success
- 201: Resource created
- 400: Bad request
- 404: Resource not found
- 500: Server error

## Development

To run the server in development mode with automatic reloading:

```bash
npm run dev
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License.