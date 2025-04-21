require("dotenv").config(); // ✅ Must be at the top

const sql = require("mssql");
const { logger } = require("../utils/logger");

const config = {
  user: process.env.DB_USER || "sa",
  password: process.env.DB_PASS || "YourStrong@Passw0rd",
  server: process.env.DB_HOST || "localhost",  // <-- This should now pick rdp.isharoverwhite.cloud
  database: process.env.DB_NAME || "Shortener",
  options: {
    encrypt: process.env.DB_ENCRYPT === "true",
    trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === "true",
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
};


// Create a connection pool
const pool = new sql.ConnectionPool(config);
const poolConnect = pool.connect();

poolConnect.catch((err) => {
  logger.error("Error connecting to database:", err);
});

module.exports = {
  pool,
  sql,
};
