import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

const ClientProfile = ({ user }) => {
  const [clientData, setClientData] = useState(null);

  useEffect(() => {
    const token = localStorage.getItem('token');

    axios.get(`http://localhost:3000/api/v1/EhotelClients/${user.nas}/profile-client`, {
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
  }, [user.nas]);

  return (
    <div>
      <h2>Client Profile</h2>
      <p>Welcome, {user && user.name}!</p>
      {/* Display clientData here */}
      <Link to="/make-reservation">Make Reservation</Link>
      <Link to={`/view-reservations/${user && user.nas}`}>View Reservations</Link>
      <Link to={`/search-rooms`}>Search Rooms</Link>
    </div>
  );
};

export default ClientProfile;