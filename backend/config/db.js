const mysql = require('mysql2/promise');
require('dotenv').config();


const connectDB = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME || 'last_mile_delivery',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});


connectDB.getConnection()
    .then(connection => {
        console.log('MySQL connected successfully');
        connection.release();
    })
    .catch(err => {
        console.error('MySQL connection error:', err.message);
    });

module.exports = connectDB;

