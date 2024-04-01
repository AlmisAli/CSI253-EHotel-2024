import React, { useState, useEffect } from 'react';
import axios from 'axios';

const ProfileClient = () => {
  const [clientData, setClientData] = useState(null);

  useEffect(() => {
    // Retrieve token from localStorage
    const token = localStorage.getItem('token');

    axios.get('http://localhost:3000/api/v1/EhotelClients/profile-client', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
      .then(response => {
        setClientData(response.data);
      })
      .catch(error => {
        console.error('Error fetching client data:', error);
      });
  }, []);

  // ... rest of the component remains the same
};



const ProfileEmployee = () => {
  const [employeeData, setEmployeeData] = useState(null);

  useEffect(() => {
    // Retrieve token from localStorage
    const token = localStorage.getItem('token');

    axios.get('http://localhost:3000/api/v1/EhotelClients/profile-employee', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
      .then(response => {
        setEmployeeData(response.data);
      })
      .catch(error => {
        console.error('Error fetching employee data:', error);
      });
  }, []);

  // ... rest of the component remains the same
};

export default ProfileEmployee;