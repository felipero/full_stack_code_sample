import React from 'react';
import './Filters.scss';

function Filters({
  categories: categories,
  themes: themes,
  term: term,
  termCallback: termCallback,
  categoryCallback: categoryCallback,
  themeCallback: themeCallback,
  searchCallback: handleSearch,
}) {
  const handleCategoryChange = e => {
    const value = e.target.options[e.target.selectedIndex].value;
    categoryCallback(value);
  };

  const handleThemeChange = e => {
    const value = e.target.options[e.target.selectedIndex].value;
    themeCallback(value);
  };

  const handleTermChange = e => {
    const value = e.target.value;
    termCallback(value);
  };

  return (
    <section className="Filters">
      <div>
        <label>Categories</label>
        <select onChange={handleCategoryChange}>
          <option value="">All categories</option>
          {categories.map(category => (
            <option key={category.name + category.id} value={category.id}>
              {category.name}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label>Themes</label>
        <select onChange={handleThemeChange}>
          <option value="">All themes</option>
          {themes.map(theme => (
            <option key={theme.name + theme.id} value={theme.id}>
              {theme.name}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label>Comment</label>
        <div className="Search">
          <input type="text" value={term} onChange={handleTermChange} placeholder="Search for a specific review" />
          <button onClick={handleSearch}>Search</button>
        </div>
      </div>
    </section>
  );
}

export default Filters;
