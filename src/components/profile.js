import React from 'react';

const UserProfile = ({ userData }) => {
  return (
    <div>
      <h2>User Profile</h2>
      <p><strong>Full Name:</strong> {userData.fullName}</p>
      <p><strong>Email:</strong> {userData.email}</p>
      <p><strong>Password:</strong> {userData.password}</p>
      <p><strong>Address:</strong> {userData.address}</p>
      <p><strong>NAS:</strong> {userData.nas}</p>
    </div>
  );
};

export default UserProfile;