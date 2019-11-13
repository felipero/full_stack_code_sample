import React, { useState } from 'react';
import './App.scss';
import Header from '../Header';
import Chart from '../Chart';
import AverageApi from '../api/AverageApi';
import Filters from '../Filters';

function App() {
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [themes, setThemes] = useState([]);
  const [selectedTheme, setSelectedTheme] = useState(null);
  const [term, setTerm] = useState('');
  const [searchTerm, setSearchTerm] = useState('');

  const handleSearch = () => {
    setSearchTerm(term);
  };

  return (
    <section className="App">
      <Header />
      <Filters
        categories={categories}
        categoryCallback={setSelectedCategory}
        themes={themes}
        themeCallback={setSelectedTheme}
        term={term}
        termCallback={setTerm}
        searchCallback={handleSearch}
      />

      <div className="Charts">
        <div className="Chart">
          <AverageApi
            key={selectedCategory + searchTerm}
            searchTerm={searchTerm}
            type={'categories'}
            selectedId={selectedCategory}
            callback={setCategories}>
            {{
              render: function render(data) {
                return <Chart dataset={data.dataset} categories={data.categories} title="Average sentiment by categories" />;
              },
            }}
          </AverageApi>
        </div>

        <div className="Chart">
          <AverageApi key={selectedTheme + searchTerm} searchTerm={searchTerm} type={'themes'} selectedId={selectedTheme} callback={setThemes}>
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
