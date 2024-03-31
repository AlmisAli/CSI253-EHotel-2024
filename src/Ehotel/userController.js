const { query } = require('express');
const pool = require('../../db');
const queries = require('./queries');
const jwt = require("jsonwebtoken");

JWT_SECRET = 'NT4trINHkwjSmnipY2lvRRGgd3cuoquL';

const registerClient = (req, res) => {
    
        const { nas, name, address, date_e } = req.body;
    
        // Insert user into the database
        pool.query(queries.checkNASExistsC, [nas], (error, results) => {
            if (results.rows.length) {
                res.send("NAS already exists.");
                return
            }
    
            pool.query(queries.addClient, [nas, name, address, date_e], (error, results) => {
                if (error) {
                    console.error('Error registering user:', error);
                    res.status(500).json({ error: 'Internal Server Error' });
                  };
                  res.status(201).json({ message: 'User registered successfully', nas });;
            })
      }); 
}

const registerEmployee = (req, res) => {
    
    const { nas, name, address, hotel_id, nas_manager } = req.body;

    // check if NAS exists
    pool.query(queries.checkNASExistsE, [nas], (error, results) => {
        if (results.rows.length) {
            res.send("NAS already exists.");
        }

        //add Client
        pool.query(queries.addEmployee, [nas, name, address, hotel_id, nas_manager], (error, results) => {
            if (error) {
                console.error('Error registering user:', error);
                res.status(500).json({ error: 'Internal Server Error' });
              };
              res.status(201).json({ message: 'Employee registered successfully', nas });;
        })
    });
};

const loginClient = async (req, res) => {
    try {
        const { nas, name } = req.body;
    
        // Check if user exists
        const user = await pool.query(queries.getClientByNAS, [nas]);
        if (user.rows.length === 0) {
          return res.status(401).json({ error: 'Invalid nas or name' });
        }
    
        // Verify password
        if (user.rows[0].name !== name) {
          return res.status(401).json({ error: 'Invalid username or password' });
        }
    
        const token = jwt.sign({ userId: user.rows[0].nas }, JWT_SECRET, { expiresIn: '1h' });
    
        res.status(200).json({ token });
      } catch (error) {
        console.error('Error logging in:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
    };

const loginEmployee = async (req, res) => {
    try {
        const { nas, name } = req.body;
    
        // Check if user exists
        const user = await pool.query(queries.getEmployeesByNAS, [nas]);
        if (user.rows.length === 0) {
          return res.status(401).json({ error: 'Invalid nas or name' });
        }
    
        // Verify password
        if (user.rows[0].name !== name) {
          return res.status(401).json({ error: 'Invalid username or password' });
        }
    
        const token = jwt.sign({ userId: user.rows[0].nas }, JWT_SECRET, { expiresIn: '1h' });
    
        res.status(200).json({ token });
      } catch (error) {
        console.error('Error logging in:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
    };

    const authenticateToken = (req, res, next) => {
        const authHeader = req.header('Authorization');
        const token = authHeader && authHeader.split(' ')[1];
        if (!token) return res.status(401).json({ error: 'Access Denied' });
      
        jwt.verify(token, JWT_SECRET, (err, decodedToken) => {
          if (err) {
            console.log("error : ", err )
            return res.status(403).json({ error: 'Invalid Token' });
          }
          req.userId = decodedToken.userId;
          next();
        });
      };

const getProfileClient = async (req, res) => {
    try {
        const userNAS = req.userId;
    
        // Fetch user profile from the database
        const user = await pool.query('SELECT nas, name, address FROM client WHERE nas = $1', [userNAS]);
        if (user.rows.length === 0) {
          return res.status(404).json({ error: 'Client not found' });
        }
    
        res.status(200).json(user.rows[0]);
      } catch (error) {
        console.error('Error fetching Client profile:', error);
        res.status(500).json({ error: 'Internal Server Error' });
      }
    };   

    const getProfileEmployee = async (req, res) => {
        try {
            const userNAS = req.userId;
        
            // Fetch user profile from the database
            const user = await pool.query('SELECT nas, name, address, hotel_id, nas_manager FROM employee WHERE nas = $1', [userNAS]);
            if (user.rows.length === 0) {
              return res.status(404).json({ error: 'Employee not found' });
            }
        
            res.status(200).json(user.rows[0]);
          } catch (error) {
            console.error('Error fetching Employee profile:', error);
            res.status(500).json({ error: 'Internal Server Error' });
          }
        };       


module.exports = {
    registerClient,
    registerEmployee,
    loginClient,
    loginEmployee,
    authenticateToken,
    getProfileClient,
    getProfileEmployee,

}
