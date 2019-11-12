import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import App from './App';

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

jest.mock('../Header', () => {
  return function DummyHeader() {
    return <div className="Header">chattermill mocked header</div>;
  };
});

jest.mock('../api/AverageApi', () => {
  return function MockApi({ type: type }) {
    return <div className={'Chart-' + type}>chart {type}</div>;
  };
});

it('renders without crashing', () => {
  act(() => {
    render(<App />, container);
  });
  expect(container.querySelector('.App .Header').textContent).toBe('chattermill mocked header');
  expect(container.querySelector('.App .Chart-categories').textContent).toBe('chart categories');
  expect(container.querySelector('.App .Chart-themes').textContent).toBe('chart themes');
});
