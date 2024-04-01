import React, { useState, useEffect } from 'react';
import axios from 'axios';

const ViewReservations = ({ match }) => {
  const [reservations, setReservations] = useState([]);

  useEffect(() => {
    axios.get(`http://localhost:3000/api/v1/clients/${match.params.nas}/reservations`)
      .then(response => {
        setReservations(response.data);
      })
      .catch(error => {
        console.error('View Reservations error:', error.response.data);
      });
  }, [match.params.nas]);

  return (
    <div>
      <h2>View Reservations</h2>
      <ul>
        {reservations.map(reservation => (
          <li key={reservation.id}>{reservation.roomType} - {reservation.checkInDate} to {reservation.checkOutDate}</li>
        ))}
      </ul>
    </div>
  );
};

export default ViewReservations;