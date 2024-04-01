import React, { useState, useEffect } from 'react';
import axios from 'axios';

const ViewLocations = ({ match }) => {
  const [locations, setLocations] = useState([]);

  useEffect(() => {
    axios.get(`http://localhost:3000/api/v1/clients/${match.params.nas}/locations`)
      .then(response => {
        setLocations(response.data);
      })
      .catch(error => {
        console.error('View Locations error:', error.response.data);
      });
  }, [match.params.nas]);

  return (
    <div>
      <h2>View Locations</h2>
      <ul>
        {locations.map(location => (
          <li key={location.id}>{location.name} - {location.address}</li>
        ))}
      </ul>
    </div>
  );
};

export default ViewLocations;