const { Router } = require('express');
const controller = require('./controller');
const userController = require('./userController');

const router = Router();

router.get('/chambres-disponibles', controller.getChambresDisp);
router.get('/clients/:id', controller.getClientsByNAS);
router.put('/clients/:id', controller.updateClient);
router.put('/Employees/:id', controller.updateEmployee);
router.delete("/clients/:id", controller.removeClient);
router.delete("/Employees/:id", controller.removeEmployee);
router.delete("/delete-location", userController.authenticateToken, controller.deleteLocation);
router.delete('/delete-reservation', userController.authenticateToken, controller.deleteReservation);
router.get('/clients', controller.getClients);
router.get('/Employees', controller.getEmployees);
router.get('/Employees/:id', controller.getEmployeesByNAS);
router.get('/reservations', controller.getReservations);
router.get('reservations/:id', controller.getReservationsByID);
router.get('/locations', controller.getLocations);
router.get('/locations/:id', controller.getLocationsByID);
router.post('/register-client', userController.registerClient);
router.post('/register-employee', userController.registerEmployee);
router.post('/login-client', userController.loginClient);
router.post('/login-employee', userController.loginEmployee);
router.post('/make-reservation', userController.authenticateToken, controller.addReservation);
router.post('/make-location', userController.authenticateToken, controller.addLocation);
router.get('/profile-client', userController.authenticateToken, userController.getProfileClient);
router.get('/profile-employee', userController.authenticateToken, userController.getProfileEmployee);
router.get('/reservations-employee', userController.authenticateToken, controller.getReservationsEmployee);
router.get('/locations-employee', userController.authenticateToken, controller.getLocationsEmployee);





module.exports = router;