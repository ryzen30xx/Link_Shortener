const { pool, sql } = require("../config/db")
const { logger } = require("../utils/logger")

/**
 * Get the original URL for a short link code
 * @param {string} shortCode - The short code to look up
 * @returns {Promise<string|null>} - The original URL or null if not found
 */
async function getOriginalUrl(shortCode) {
  try {
    await pool.connect()

    const result = await pool
      .request()
      .input("shortCode", sql.VarChar(50), shortCode)
      .query(`
        SELECT OriginalUrl, ExpiryDate, ClickCount
        FROM Links
        WHERE ShortCode = @shortCode
      `)

    if (result.recordset.length === 0) {
      return null
    }

    const link = result.recordset[0]

    // Check if link has expired
    if (link.ExpiryDate && new Date(link.ExpiryDate) < new Date()) {
      logger.info(`Link ${shortCode} has expired`)
      return null
    }

    // Update click count
    await pool
      .request()
      .input("shortCode", sql.VarChar(50), shortCode)
      .query(`
        UPDATE Links
        SET ClickCount = ClickCount + 1, 
            LastAccessedDate = GETDATE()
        WHERE ShortCode = @shortCode
      `)

    // Log access for analytics
    await logLinkAccess(shortCode)

    return link.OriginalUrl
  } catch (error) {
    logger.error("Error getting original URL:", error)
    throw error
  }
}

/**
 * Log link access for analytics
 * @param {string} shortCode - The short code that was accessed
 */
async function logLinkAccess(shortCode) {
  try {
    await pool
      .request()
      .input("shortCode", sql.VarChar(50), shortCode)
      .input("accessDate", sql.DateTime, new Date())
      .input("ipAddress", sql.VarChar(50), "0.0.0.0") // In a real app, you'd get this from the request
      .input("userAgent", sql.VarChar(255), "Unknown") // In a real app, you'd get this from the request
      .query(`
        INSERT INTO LinkClicks (ShortCode, AccessDate, IPAddress, UserAgent)
        VALUES (@shortCode, @accessDate, @ipAddress, @userAgent)
      `)
  } catch (error) {
    logger.error("Error logging link access:", error)
    // Don't throw here, just log the error
  }
}

/**
 * Check if a link has expired and delete it if needed
 * @param {string} shortCode - The short code to check
 */
async function checkAndDeleteExpiredLink(shortCode) {
  try {
    await pool.connect()

    const result = await pool
      .request()
      .input("shortCode", sql.VarChar(50), shortCode)
      .query(`
        SELECT ExpiryDate
        FROM Links
        WHERE ShortenedUrl = @shortCode
      `)

    if (result.recordset.length === 0) {
      return
    }

    const link = result.recordset[0]

    // Check if link has expired
    if (link.ExpiryDate && new Date(link.ExpiryDate) < new Date()) {
      await pool
        .request()
        .input("shortCode", sql.VarChar(50), shortCode)
        .query(`
          DELETE FROM Links
          WHERE ShortCode = @shortCode
        `)

      logger.info(`Deleted expired link: ${shortCode}`)
    }
  } catch (error) {
    logger.error("Error checking/deleting expired link:", error)
    throw error
  }
}

module.exports = {
  getOriginalUrl,
  checkAndDeleteExpiredLink,
}
