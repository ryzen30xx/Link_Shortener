const express = require("express")
const cors = require("cors")
const helmet = require("helmet")
const dotenv = require("dotenv")
const { logger } = require("./src/utils/logger")
const redirectRoutes = require("./src/routes/redirectRoutes")
const healthRoutes = require("./src/routes/healthRoutes")

// Load environment variables
dotenv.config()

// Initialize express app
const app = express()
const PORT = process.env.PORT || 3001

// Middleware
app.use(helmet()) // Security headers
app.use(cors()) // Enable CORS
app.use(express.json()) // Parse JSON bodies

// Request logging middleware
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.url}`)
  next()
})

// Routes
app.use("/health", healthRoutes)
app.use("/", redirectRoutes) // Root path for redirect functionality

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error(err.stack)
  res.status(500).json({
    status: "error",
    message: "Internal Server Error",
  })
})

// Start server
app.listen(PORT, () => {
  logger.info(`RedirectService running on port ${PORT}`)
})

module.exports = app // For testing
