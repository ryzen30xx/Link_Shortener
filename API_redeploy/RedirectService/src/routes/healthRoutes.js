const express = require("express")
const router = express.Router()
const { pool } = require("../config/db")
const { logger } = require("../utils/logger")

/**
 * Health check endpoint
 */
router.get("/", async (req, res) => {
  return res.status(200).json({
    status: "ok",
    service: "redirect-service",
    timestamp: new Date().toISOString(),
  })
})

/**
 * Database health check endpoint
 */
router.get("/db", async (req, res) => {
  try {
    await pool.connect()

    // Simple query to check DB connection
    const result = await pool.request().query("SELECT 1 as dbCheck")

    if (result.recordset[0].dbCheck === 1) {
      return res.status(200).json({
        status: "ok",
        database: "connected",
        timestamp: new Date().toISOString(),
      })
    } else {
      throw new Error("Database check failed")
    }
  } catch (error) {
    logger.error("Database health check failed:", error)
    return res.status(500).json({
      status: "error",
      database: "disconnected",
      message: error.message,
      timestamp: new Date().toISOString(),
    })
  }
})

module.exports = router
