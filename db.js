const Pool = require('pg').Pool;

const pool = new Pool({
    user: "postgres",
    host: "localhost",
    database: "EHotel",
    password: "rafdatabase1108",
    port: 5432,
});

module.exports = pool;