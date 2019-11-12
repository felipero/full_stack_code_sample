import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import Chart from './Chart';

jest.mock('highcharts-react-official', () => {
  return function DummyHighcharts({
    options: {
      title: { text: title },
      series,
      xAxis: { categories },
    },
  }) {
    return (
      <div id="MockedHighcharts">
        {title} : {series[0].data[0]} : {categories[0]} {categories[1]}
      </div>
    );
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

it('renders Highcharts', () => {
  const mockedDataset = [{ name: 'My mocked dataset', sentiment: 0.67 }];
  act(() => {
    render(<Chart title="My title" dataset={mockedDataset} categories={['My', 'categories']} />, container);
  });
  expect(container.textContent).toBe('My title : My mocked dataset67 : My categories');
});
