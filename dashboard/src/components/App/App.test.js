import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import App from './App';

jest.mock('../Header', () => {
  return function DummyHeader() {
    return <div className="Header">chattermill mocked header</div>;
  };
});

jest.mock('../api/CategoryApi', () => {
  return function MockApi(_) {
    return <div className="CategoryChart">chart</div>;
  };
});

jest.mock('../api/ThemeApi', () => {
  return function MockApi(_) {
    return <div className="ThemeChart">chart</div>;
  };
});

let container = null;

beforeEach(() => {
  container = document.createElement('div');
  document.body.appendChild(container);
});

afterEach(() => {
  unmountComponentAtNode(container);
  container.remove();
  container = null;
});

it('renders without crashing', () => {
  act(() => {
    render(<App />, container);
  });
  expect(container.querySelector('.App .Header').textContent).toBe('chattermill mocked header');
  expect(container.querySelector('.App .CategoryChart').textContent).toBe('chart');
  expect(container.querySelector('.App .ThemeChart').textContent).toBe('chart');
});
