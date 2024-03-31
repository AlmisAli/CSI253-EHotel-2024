import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link, NavLink, BrowserRouter } from 'react-router-dom';
import LoginForm from './components/Login';
import UserForm from './components/UserForm';
import UserProfile from './components/profile'; // Import UserProfile component

const App = () => {
  return (
    <BrowserRouter>
      <header>
        <nav>
          <Link to="/">UserForm</Link>
          <NavLink to="/login">LoginForm</NavLink>
          <NavLink to="/profile">Profile</NavLink> {/* Add Profile link */}
        </nav>
      </header>
      <div>
        <Routes>
          <Route path="/login" element={<LoginForm />} />
          <Route path="/" element={<UserForm />} />
          <Route path="/profile" element={<UserProfile />} /> {/* Add Profile route */}
          {/* Add more routes for different user types if needed */}
        </Routes>
      </div>
    </BrowserRouter>
  );
};

export default App;