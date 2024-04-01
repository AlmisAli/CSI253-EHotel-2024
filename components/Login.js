import React, { useState } from 'react';
import axios from 'axios';

const Login = ({ onLogin }) => {
  const [formData, setFormData] = useState({
    email: '',
    name: '',
    nas: ''
  });
  const [errorMessage, setErrorMessage] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value
    });
  };

  const handleLogin = (e) => {
    e.preventDefault();

    axios.post('http://localhost:3000/api/v1/EhotelClients/login-client', formData)
      .then(response => {
        console.log('Login successful:', response.data);

        // Store token in localStorage
        localStorage.setItem('token', response.data.token);

        // Redirect or set token/session here
        // For now, you can just redirect to a home page
        window.location.href = '/'; // Redirect to home page
        onLogin(); // Call onLogin function
      })
      .catch(error => {
        console.error('Login error:', error.response.data);
        setErrorMessage(error.response.data.message || 'An error occurred');
      });
  };

  return (
    <div>
      <h2>User Login</h2>
      {errorMessage && <p>{errorMessage}</p>}
      <form onSubmit={handleLogin}>
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
          <label>Name:</label>
          <input
            type="text"
            name="name"
            value={formData.name}
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
        <button type="submit">Login</button>
      </form>
    </div>
  );
};

export default Login;