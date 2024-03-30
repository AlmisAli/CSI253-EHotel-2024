import React, { useState } from 'react';

const LoginForm = () => {
  const [formData, setFormData] = useState({
    email: '',
    name: '',
    nas: ''
  });
  const [isEmployer, setIsEmployer] = useState(false);
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
    // Handle login logic here, e.g., send data to server for authentication
    console.log(formData);
    // Clear form fields after submission (optional)
    setFormData({
      email: '',
      name: '',
      nas: ''
    });
    setIsEmployer(false); // Reset the checkbox to unchecked state after submission

  };

  return (
    <div>
      <h2>User Login</h2>
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
        <div>
          <input 
            type="checkbox" 
            id="employerCheckbox" 
            checked={isEmployer} 
            onChange={handleCheckboxChange} 
          />
          <label htmlFor="employerCheckbox">Employer</label>
        </div>
        <button type="submit">Login</button>
      </form>
    </div>
  );
};

export default LoginForm;
//l