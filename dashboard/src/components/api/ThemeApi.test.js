import React from 'react';
import { get } from 'axios';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import ThemeApi from './ThemeApi';

function DummyChart({ dataset, categories, title }) {
  return (
    <div className="Chart">
      {title} : {dataset[0].sentiment}
      {dataset[1].sentiment} : {categories}
    </div>
  );
}

jest.mock('axios', () => ({ get: jest.fn() }));

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

it('renders data when api returns data', done => {
  const promise = Promise.resolve({
    data: {
      averages: [
        { name: 'Bar', id: 541, sentiment: 0.67 },
        { name: 'Baz', id: 451, sentiment: -0.25 },
      ],
    },
  });

  get.mockReturnValueOnce(promise);

  act(() => {
    render(
      <ThemeApi>
        {{
          render: function render(data) {
            return <DummyChart dataset={data.dataset} categories={data.categories} title="Average sentiment by categories" />;
          },
        }}
      </ThemeApi>,
      container,
    );
  });

  promise.then(_data => {
    expect(container.querySelector('.Chart').textContent).toBe('Average sentiment by categories : 0.67-0.25 : BarBaz');
    done();
  });
});

it('renders nothing when api returns empty', done => {
  const promise = Promise.resolve({
    data: { averages: [] },
  });
  get.mockReturnValueOnce(promise);
  act(() => {
    render(
      <ThemeApi>
        {{
          render: function render(_) {
            return 'fail!';
          },
        }}
      </ThemeApi>,
      container,
    );
  });
  promise.then(_ => {
    expect(container.textContent).toBe('');
    done();
  });
});
