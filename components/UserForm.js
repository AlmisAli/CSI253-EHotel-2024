import React, { useState } from 'react';
import axios from 'axios';

const UserForm = () => {
  const [formData, setFormData] = useState({
    email: '',
    fullName: '',
    nas: ''
  });
  const [isEmployer, setIsEmployer] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleCheckboxChange = () => {
    setIsEmployer(!isEmployer);
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    axios.post('http://localhost:3000/api/v1/clients/register', formData)
      .then(response => {
        console.log('Registration successful:', response.data);
      })
      .catch(error => {
        console.error('Registration error:', error.response.data);
        setErrorMessage(error.response.data.message);
      });
  };

  return (
    <div>
      <h2>User Registration</h2>
      {errorMessage && <p>{errorMessage}</p>}
      <form onSubmit={handleSubmit}>
        <div>
          <label>Email:</label>
          <input
            type="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>Full Name:</label>
          <input
            type="text"
            name="fullName"
            value={formData.fullName}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <label>NAS:</label>
          <input
            type="text"
            name="nas"
            value={formData.nas}
            onChange={handleChange}
            required
          />
        </div>
        <div>
          <input 
            type="checkbox" 
            id="employerCheckbox" 
            checked={isEmployer} 
            onChange={handleCheckboxChange} 
          />
          <label htmlFor="employerCheckbox">Employer</label>
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default UserForm;