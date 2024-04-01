import React, { useState, useEffect } from 'react';
import axios from 'axios';

const SearchRooms = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [rooms, setRooms] = useState([]);

  useEffect(() => {
    axios.get(`http://localhost:3000/api/v1/rooms?query=${searchTerm}`)
      .then(response => {
        setRooms(response.data);
      })
      .catch(error => {
        console.error('Search error:', error.response.data);
      });
  }, [searchTerm]);

  const handleChange = (e) => {
    setSearchTerm(e.target.value);
  };

  return (
    <div>
      <h2>Search Rooms</h2>
      <input
        type="text"
        placeholder="Search..."
        value={searchTerm}
        onChange={handleChange}
      />
      <ul>
        {rooms.map(room => (
          <li key={room.id}>{room.roomType}</li>
        ))}
      </ul>
    </div>
  );
};

export default SearchRooms;