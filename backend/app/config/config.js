require('dotenv').config();

module.exports = {
    
    development: {
        username: process.env.DB_USER,
        password: process.env.DB_PASSWORD,
        database: process.env.DB_NAME,
        dialect: 'mysql',
        host: process.env.DB_HOST,
        operatorAliases: false
    }
};