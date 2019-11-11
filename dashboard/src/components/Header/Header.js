import React from 'react';
import './Header.scss';
import logo from '../../assets/images/logo.svg';

function Header() {
  return (
    <header className="Header">
      <img src={logo} className="Header-logo" alt="logo" />
      <h2>Chattermill</h2>
    </header>
  );
}

export default Header;
