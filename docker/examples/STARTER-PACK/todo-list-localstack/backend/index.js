const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const multer = require('multer');
const multerS3 = require('multer-s3');
const { S3Client } = require('@aws-sdk/client-s3');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Connect to MongoDB using the environment variable
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/todos', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch((error) => console.error('Error connecting to MongoDB:', error));

// Define a schema for the Todo model
const todoSchema = new mongoose.Schema({
  text: { type: String, required: true }
});

// Create a model for the Todo items
const Todo = mongoose.model('Todo', todoSchema);

// Route to get all todos
app.get('/api/todos', async (req, res) => {
  try {
    const todos = await Todo.find();
    res.json(todos);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching todos', error });
  }
});

// Route to add a new todo
app.post('/api/todos', async (req, res) => {
  try {
    const todo = new Todo({
      text: req.body.text,
    });
    await todo.save();
    res.json(todo);
  } catch (error) {
    res.status(500).json({ message: 'Error adding todo', error });
  }
});

// Route to delete a todo by ID
app.delete('/api/todos/:id', async (req, res) => {
  try {
    await Todo.findByIdAndDelete(req.params.id);
    res.json({ message: 'Todo deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting todo', error });
  }
});

// Set up the S3 client to use LocalStack or AWS
const s3 = new S3Client({
  region: process.env.AWS_REGION || 'us-east-1',
  forcePathStyle: true,
  endpoint: process.env.S3_ENDPOINT_URL || 'https://s3.amazonaws.com', // Use LocalStack or default AWS S3
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'default_access_key', // Default for development
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'default_secret_key',
  },
});

// Configure multer to use S3 for storage
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.S3_BUCKET_NAME, // Bucket name from environment variables
    key: function (req, file, cb) {
      cb(null, `${Date.now().toString()}-${file.originalname}`); // Unique file name
    },
  }),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB file size limit
  fileFilter: (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type, only images are allowed!'), false);
    }
  },
});

// Route to handle image uploads
app.post('/upload', upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).send('No file uploaded.');
  }

  // Return the S3 file URL
  res.json({
    message: 'File uploaded successfully',
    fileUrl: req.file.location, // The URL of the uploaded file in S3
  });
});

// Start the server
app.listen(5000, () => {
  console.log('Server is running on port 5000');
});

