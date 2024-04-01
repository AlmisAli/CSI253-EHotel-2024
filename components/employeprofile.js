import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const EmployeeProfile = ({ user }) => {
  const [employeeData, setEmployeeData] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem('token');

    axios.get(`http://localhost:3000/api/v1/EhotelClients/${user.nas}/profile-employee`, {
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
  }, [user.nas]);

  return (
    <div>
      <h2>Employee Profile</h2>
      <p>Welcome, {user && user.name}!</p>
      {/* Display employeeData here */}
      <Link to={`/view-reservations/${user && user.nas}`}>View Reservations</Link>
      <Link to={`/view-locations/${user && user.nas}`}>View Locations</Link>
    </div>
  );
};

export default EmployeeProfile;
