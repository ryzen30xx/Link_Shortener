const express = require("express")
const router = express.Router()
const { getOriginalUrl, checkAndDeleteExpiredLink } = require("../services/redirectService")
const { logger } = require("../utils/logger")

/**
 * Redirect to the original URL based on the short code
 */
router.get("/:shortCode", async (req, res) => {
  try {
    const { shortCode } = req.params

    // Get the original URL
    const originalUrl = await getOriginalUrl(shortCode)

    if (!originalUrl) {
      return res.status(404).json({
        status: "error",
        message: "Short link not found or has expired",
      })
    }

    // Check if the link has expired in the background
    // This is done asynchronously to not block the redirect
    checkAndDeleteExpiredLink(shortCode).catch((err) => {
      logger.error("Error in background expiry check:", err)
    })

    // Redirect to the original URL
    return res.redirect(originalUrl)
  } catch (error) {
    logger.error("Error in redirect:", error)
    return res.status(500).json({
      status: "error",
      message: "Internal server error",
    })
  }
})

module.exports = router
