const multer = require('multer');
const multerS3 = require('multer-s3');
const { S3Client } = require('@aws-sdk/client-s3');
require('dotenv').config();

// Configure the S3 client to use environment variables
const s3 = new S3Client({
  region: process.env.AWS_REGION || 'us-east-1', // Default to 'us-east-1' if not provided
  forcePathStyle: true, // Keep this for LocalStack compatibility
  endpoint: process.env.S3_ENDPOINT_URL || 'https://s3.amazonaws.com', // Use the provided endpoint or default to AWS
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'default_access_key', // Default values for development
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'default_secret_key',
  },
});

// Configure multer to use S3 for storage
const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: process.env.S3_BUCKET_NAME, // Bucket name from .env file
    key: function (req, file, cb) {
      cb(null, Date.now().toString() + '-' + file.originalname); // Unique file name
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

module.exports = upload;

