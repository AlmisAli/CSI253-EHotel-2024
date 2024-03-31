const { query } = require('express');
const pool = require('../../db');
const queries = require('./queries');

const getClients = (req, res) => {
    pool.query(queries.getClients, (error, results) => {
        if (error) throw error;
        res.status(200).json(results.rows);
    })
};

const getClientsByNAS = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.getClientByNAS, [id], (error, results) => {
        if (error) throw error;
        res.status(200).json(results.rows);
    });
};

const removeClient = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.checkNASExistsC, [id], (error, results) => {
        if (error) {
            throw error 
            return;
        }
        if (results.rows.length === 0) {
            res.send("Client does not exist!")
        }

        else {
            pool.query(queries.deleteClient, [id], (error, results) =>  {
                if (error) throw error;
                res.status(202).send("Client removed succesfully");
            })
        }
    } );
};

const updateClient = (req, res) => {
    const { name, address, date_e } = req.body;
    const id = parseInt(req.params.id);


    const setValues = [];
    if (name) setValues.push(`name = '${name}'`);
    if (address) setValues.push(`address = '${address}'`);
    if (date_e) setValues.push(`date_e = '${date_e}'`);


    if (setValues.length === 0) {
        res.status(400).send('No update parameters provided');
        return;
    }


    const queryString = `UPDATE client SET ${setValues.join(',')} WHERE nas = $1`;


    pool.query(queryString, [id], (error, results) => {
        if (error) {
            console.error('Error updating client:', error);
            res.status(500).send('Internal Server Error');
            return;
        }
        res.status(200).send(`Client with ID ${id} updated successfully`);
    });
};

const getEmployees = (req, res) => {
    pool.query(queries.getEmployees, (error, results) => {
        if (error) throw error;
        res.status(200).json(results.rows);
    })
};

const getEmployeesByNAS = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.getEmployeesByNAS, [id], (error, results) => {
        if (error) throw error;
        res.status(200).json(results.rows);
    });
};

const removeEmployee = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.checkNASExistsE, [id], (error, results) => {
        if (error) {
            throw error 
            return;
        }
        if (results.rows.length === 0) {
            res.send("Employee does not exist!")
        }

        else {
            pool.query(queries.deleteEmployee, [id], (error, results) =>  {
                if (error) throw error;
                res.status(202).send("Employee removed succesfully");
            })
        }
    } );
};

const updateEmployee = (req, res) => {
    const { name, address, hotel_id, nas_manager } = req.body;
    const id = parseInt(req.params.id);


    const setValues = [];
    if (name) setValues.push(`name = '${name}'`);
    if (address) setValues.push(`address = '${address}'`);
    if (hotel_id) setValues.push(`hotel_id = '${hotel_id}'`);
    if (nas_manager) setValues.push(`nas_manager = '${nas_manager}`);


    if (setValues.length === 0) {
        res.status(400).send('No update parameters provided');
        return;
    }


    const queryString = `UPDATE employee SET ${setValues.join(',')} WHERE nas = $1`;


    pool.query(queryString, [id], (error, results) => {
        if (error) {
            console.error('Error updating employee:', error);
            res.status(500).send('Internal Server Error');
            return;
        }
        res.status(200).send(`Employee with ID ${id} updated successfully`);
    });
};

const getReservations = (req, res) => {
    pool.query(queries.getReservations, (error, results) =>{
        if (error) {
            console.error('Error getting registrations:', error);
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    });
}

const getReservationsByID = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.getReservationsByID, [id], (error, results) => {
        if (error) {
            console.error('Error getting requested reservation:', error);
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    })
}

const getReservationsClient = (req, res) => {
    const userNAS = req.userId;

    pool.query(queries.getReservationsClient, [userNAS], (error, results) => {
        if (error) {
            console.error('Error getting reservations:', error)
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    })
}

const getReservationsEmployee = (req, res) => {
    const userNAS = req.userId;

    pool.query(queries.getReservationsEmployee, [userNAS], (error, results) => {
        if (error) {
            console.error('Error getting reservations:', error)
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    })
}

const addReservation = (req, res) => {
    const userNAS = req.userId;
    
    const { start_date, end_date, status, number_people, nas_e, room_number, hotel_id} = req.body;

    const reservation_id = req.body.reservation_id;

    if (!start_date || !end_date || !status || !number_people || !nas_e || !room_number || !hotel_id) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    pool.query(queries.addReservation, [reservation_id, start_date, end_date, status, number_people, nas_e, userNAS, room_number, hotel_id], (error, results) => {
        if (error) {
            console.error('Error adding reservation:', error);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        res.status(201).json({ message: 'Reservation added successfully', reservation_id });
    });
}

const addLocation = (req, res) => {
    const userNAS = req.userId;
    
    const { start_date, end_date, total_amount, number_people, nas_c, room_number, hotel_id} = req.body;

    const location_id = req.body.reservation_id;

    if (!start_date || !end_date || !number_people || !nas_e || !room_number || !hotel_id) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    pool.query(queries.addLocation, [reservation_id, start_date, end_date, total_amount, number_people, userNAS, nas_c, room_number, hotel_id], (error, results) => {
        if (error) {
            console.error('Error adding location:', error);
            return res.status(500).json({ error: 'Internal Server Error' });
        }
        res.status(201).json({ message: 'Location added successfully', reservation_id });
    });
}

const getLocationsClient = (req, res) => {
    const userNAS = req.userId;

    pool.query(queries.getLocationsClient, [userNAS], (error, results) => {
        if (error) {
            console.error('Error getting Locations:', error)
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    })
}

const getLocationsEmployee = (req, res) => {
    const userNAS = req.userId;

    pool.query(queries.getLocationsEmployee, [userNAS], (error, results) => {
        if (error) {
            console.error('Error getting Locations:', error)
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    })
}

const getLocations = (req, res) => {
    pool.query(queries.getLocations, (error, results) => {
        if (error) {
            console.error('Error getting locations:', error);
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    });
}

const getLocationsByID = (req, res) => {
    const id = parseInt(req.params.id);
    pool.query(queries.getLocationsByID, [id], (error, results) => {
        if (error) {
            console.error('Error getting requested location:', error);
            res.status(500).send('Internal Server Error');
            return
        }
        res.status(200).json(results.rows);
    });
};

const deleteLocation = (req, res) => {
    const userNAS = req.userId;

    const location_id = req.body.location_id;

    pool.query(queries.checkLocationPermission, [userNAS, location_id], (error, results) => {
        if (error) {
            console.error('Error checking location permission:', error);
            res.status(500).json({ error: 'Internal Server Error' });
            return;
        }

        if (results.rows.length === 0) {
            res.status(403).json({ error: 'You do not have permission to delete this location' });
            return;
        }

        // Delete the location from the database
        pool.query(queries.deleteLocation, [location_id], (error, results) => {
            if (error) {
                console.error('Error deleting location:', error);
                res.status(500).json({ error: 'Internal Server Error' });
                return;
            }
            res.status(200).json({ message: 'Location deleted successfully' });
        });
    });
};

const deleteReservation = (req, res) => {
    const userNAS = req.userId;

    const reservation_id = req.body.reservation_id;

    pool.query(queries.checkReservationPermission, [userNAS, reservation_id], (error, results) => {
        if (error) {
            console.error('Error checking location permission:', error);
            res.status(500).json({ error: 'Internal Server Error' });
            return;
        }

        if (results.rows.length === 0) {
            res.status(403).json({ error: 'You do not have permission to delete this location' });
            return;
        }

        // Delete the location from the database
        pool.query(queries.deleteReservation, [location_id], (error, results) => {
            if (error) {
                console.error('Error deleting location:', error);
                res.status(500).json({ error: 'Internal Server Error' });
                return;
            }
            res.status(200).json({ message: 'Location deleted successfully' });
        });
    });
};

const getChambresDisp = (req, res) => {
    const { startDate, endDate, capacity, hotelChain, hotelCategory, totalRooms, price } = req.body;
    sqlQuery = queries.getChambresDisp;
    const params = [];

    // Add filters based on hotel-related criteria
    if (hotelChain) {
        sqlQuery += ' AND hotel.chain_name = $' + (params.length + 1);
        params.push(hotelChain);
    }
    if (hotelCategory) {
        sqlQuery += ' AND hotel.stars >= $' + (params.length + 1);
        params.push(hotelCategory);
    }
    if (totalRooms) {
        sqlQuery += ' AND hotel.n_room >= $' + (params.length + 1);
        params.push(totalRooms);
    }

    if (capacity) {
        sqlQuery += ' AND room.capacity >= $' + (params.length + 1);
        params.push(capacity);
    }

    if (startDate && endDate) {
        sqlQuery += `
            AND NOT EXISTS (
                SELECT 1 
                FROM reservations 
                WHERE reservations.room_number = room.room_number 
                AND reservations.hotel_id = room.hotel_id
                AND reservations.start_date <= $${params.length + 1} 
                AND reservations.end_date >= $${params.length + 2}
            )
        `;
        params.push(startDate, endDate);
    }
    if (price) {
        sqlQuery += ' AND room.price <= $' + (params.length + 1);
        params.push(price);
    }

    console.log('Built SQL Query:', sqlQuery, 'with parameters:', params);
    // Execute the SQL query in the database
    pool.query(sqlQuery, params, (error, results) => {
        if (error) {
            console.error('Error searching for available rooms:', error);
            res.status(500).json({ error: 'Internal Server Error' });
            return;
        }
        // Return the search results as JSON
        res.status(200).json(results.rows);
    });
};



module.exports = {
    getClientsByNAS,
    getClients,
    removeClient,
    updateClient,
    getChambresDisp,
    getEmployees,
    getEmployeesByNAS,
    removeEmployee,
    updateEmployee,
    getReservations,
    getReservationsByID,
    getLocations,
    getLocationsByID,
    getReservationsEmployee,
    getLocationsEmployee,
    getReservationsClient,
    getLocationsClient,
    addReservation,
    addLocation, 
    deleteLocation,
    deleteReservation,

};