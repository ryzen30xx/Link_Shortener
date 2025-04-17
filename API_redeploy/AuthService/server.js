require('dotenv').config();
const express = require('express');
const sequelize = require('./config/database');
const authRoutes = require('./api/routes/AuthRoute');

const app = express();
app.use(express.json());
app.use('/api/auth', authRoutes);

sequelize.sync().then(() => {
  console.log('✅ Database synced');
  app.listen(process.env.PORT, () => {
    console.log(`🚀 Server running on port ${process.env.PORT}`);
  });
}).catch(err => {
  console.error('❌ DB connection error:', err);
});
