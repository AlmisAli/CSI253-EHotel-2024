import React, { useState } from 'react';

const UserForm = () => {
  const [formData, setFormData] = useState({
    email: '',
    fullName: '',
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

  return (
    <div>
      <h2>User Registration</h2>
      <form>
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
        <input 
            type="checkbox" 
            id="employerCheckbox" 
            checked={isEmployer} 
            onChange={handleCheckboxChange} 
          />
          <label htmlFor="employerCheckbox">Employer</label>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default UserForm;