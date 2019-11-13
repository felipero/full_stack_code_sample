import React from 'react';
import { render, unmountComponentAtNode } from 'react-dom';
import { act } from 'react-dom/test-utils';
import Filters from './Filters';

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
  const mockCategoryCallback = jest.fn();
  const mockThemeCallback = jest.fn();
  const mockTermCallback = jest.fn();
  const mockSearchCallback = jest.fn();

  const categories = [
    { name: 'Bar', id: 541 },
    { name: 'Baz', id: 451 },
  ];

  const themes = [
    { name: 'Bar', id: 541 },
    { name: 'Baz', id: 451 },
  ];

  const term = '';

  act(() => {
    render(
      <Filters
        categories={categories}
        categoryCallback={mockCategoryCallback}
        themes={themes}
        themeCallback={mockThemeCallback}
        term={term}
        termCallback={mockTermCallback}
        searchCallback={mockSearchCallback}
      />,
      container,
    );
  });
  expect(container.textContent).toBe('CategoriesAll categoriesBarBazThemesAll themesBarBazCommentSearch');
});
