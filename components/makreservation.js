import React, { useState } from 'react';
import axios from 'axios';

const MakeReservation = ({ user }) => {
  const [formData, setFormData] = useState({
    roomType: '',
    checkInDate: '',
    checkOutDate: ''
  });
  const [errorMessage, setErrorMessage] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    axios.post(`http://localhost:3000/api/v1/clients/${user.nas}/reservations`, formData)
      .then(response => {
        console.log('Reservation successful:', response.data);
      })
      .catch(error => {
        console.error('Reservation error:', error.response.data);
        setErrorMessage(error.response.data.message);
      });
  };

  return (
    <div>
      <h2>Make Reservation</h2>
      {errorMessage && <p>{errorMessage}</p>}
      <form onSubmit={handleSubmit}>
        <div>
          <label>Room Type:</label>
          <input
            type="text"
            name="roomType"
            value={formData.roomType}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Check-in Date:</label>
          <input
            type="date"
            name="checkInDate"
            value={formData.checkInDate}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Check-out Date:</label>
          <input
            type="date"
            name="checkOutDate"
            value={formData.checkOutDate}
            onChange={handleChange}
            required
          />
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default MakeReservation;