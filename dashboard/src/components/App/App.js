import React from 'react';
import './App.scss';
import Header from '../Header';
import Chart from '../Chart';
import CategoryApi from '../api/CategoryApi';
import ThemeApi from '../api/ThemeApi';

function App() {
  return (
    <section className="App">
      <Header />
      <div className="Charts">
        <div className="Chart">
          <CategoryApi>
            {{
              render: function render(data) {
                return <Chart dataset={data.dataset} categories={data.categories} title="Average sentiment by categories" />;
              },
            }}
          </CategoryApi>
        </div>

        <div className="Chart">
          <ThemeApi>
            {{
              render: function render(data) {
                return <Chart dataset={data.dataset} categories={data.categories} title="Average sentiment by themes" />;
              },
            }}
          </ThemeApi>
        </div>
      </div>
    </section>
  );
}

export default App;
