import React, { useState } from 'react';
import './App.scss';
import Header from '../Header';
import Chart from '../Chart';
import AverageApi from '../api/AverageApi';

function App() {
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [themes, setThemes] = useState([]);
  const [selectedTheme, setSelectedTheme] = useState(null);

  const handleCategoryChange = e => {
    const value = e.target.options[e.target.selectedIndex].value;
    setSelectedCategory(value);
  };

  const handleThemeChange = e => {
    const value = e.target.options[e.target.selectedIndex].value;
    setSelectedTheme(value);
  };

  return (
    <section className="App">
      <Header />
      <div className="Filters">
        <select onChange={handleCategoryChange}>
          <option value="">All categories</option>
          {categories.map(category => (
            <option key={category.name + category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>

        <select onChange={handleThemeChange}>
          <option value="">All themes</option>
          {themes.map(theme => (
            <option key={theme.name + theme.id} value={theme.id}>
              {theme.name}
            </option>
          ))}
        </select>
      </div>
      <div className="Charts">
        <div className="Chart">
          <AverageApi key={selectedCategory} type={'categories'} selectedId={selectedCategory} callback={setCategories}>
            {{
              render: function render(data) {
                return <Chart dataset={data.dataset} categories={data.categories} title="Average sentiment by categories" />;
              },
            }}
          </AverageApi>
        </div>

        <div className="Chart">
          <AverageApi key={selectedTheme} type={'themes'} selectedId={selectedTheme} callback={setThemes}>
            {{
              render: function render(data) {
                return <Chart dataset={data.dataset} categories={data.categories} title="Average sentiment by themes" />;
              },
            }}
          </AverageApi>
        </div>
      </div>
    </section>
  );
}

export default App;
