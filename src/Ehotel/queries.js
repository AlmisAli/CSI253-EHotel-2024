const getClients = "SELECT * from client";
const getEmployees = "SELECT * from employee";
const getReservations = "SELECT * from reservation";
const getLocations = "SELECT * FROM location";
const getClientByNAS = "SELECT * from client where nas = $1";
const getEmployeesByNAS = "Select * from employee where nas = $1";
const getReservationsByID = "SELECT * from reservation where reservation_id = $1";
const getLocationsByID = "SELECT * from location where locations_id = $1";
const checkNASExistsC = "SELECT s FROM client s where s.nas = $1";
const checkNASExistsE = "SELECT s FROM employee s where s.nas = $1";
const addClient = "insert into client (nas, name, address, date_e) values ($1, $2, $3, $4)";
const addEmployee = "insert into employee (nas, name, address, hotel_id, nas_manager) values ($1, $2, $3, $4, $5)";
const deleteClient = "delete from client where nas = $1";
const deleteEmployee = "delete from employee where nas = $1";
const getChambresDisp = `
    SELECT room.*
    FROM room
    JOIN hotel ON room.hotel_id = hotel.hotel_id
    WHERE 1=1`;
const getReservationsEmployee = `SELECT reservation.* 
    from employee, reservation 
    where employee.nas = $1, employee.hotel_id = reservation.hotel_id`;
const getLocationsEmployee = `SELECT location.* 
from employee, location 
where employee.nas = $1, employee.hotel_id = location.hotel_id`;
const getReservationsClient = "SELECT * from reservation where nas_c = $1"; 
const getLocationsClient = "Select * from locations where nas_c = $1"; 
const addReservation = `insert into reservation (reservation_id, start_date, end_date, status, number_people, nas_e, nas_c, room_number, hotel_id) 
    values ($1, $2, $3, $4, $5, $6, $7, $8, $9)`
const addLocation = `insert into location (location_id, start_date, end_date, total_amount, number_people, nas_e, nas_c, room_number, hotel_id) 
    values ($1, $2, $3, $4, $5, $6, $7, $8, $9)`
const deleteLocation = `delete from location where location_id = $1`;
const checkLocationPermission = "Select * from location where nas_e = $1, location_id = $2";
const deleteReservation = 'delete from reservation where reservation_id = $1';
const checkReservationPermission = "Select * from reservation where (nas_e = $1 OR nas_c = $1) AND reservation_id = $2";


module.exports = {
    getClients,
    getClientByNAS,
    checkNASExistsC,
    addClient,
    deleteClient,
    getChambresDisp,
    getEmployees,
    getEmployeesByNAS,
    checkNASExistsE,
    addEmployee,
    deleteEmployee,
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
    checkLocationPermission,
    checkReservationPermission,
    deleteReservation,
};