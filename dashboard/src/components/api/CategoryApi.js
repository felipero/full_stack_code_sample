import React from 'react';
import axios from 'axios';

export default class CategoryApi extends React.Component {
  constructor(props) {
    super(props);
    const {
      children: { render: renderChild },
    } = props;

    this.axios = axios.create({ baseURL: process.env.REACT_APP_API_HOST });
    this.renderChild = renderChild;
    this.state = { data: null };
  }

  componentDidMount() {
    this.axios
      .get('/averages/categories')
      .then(resp => {
        if (resp && resp.data) {
          const averages = resp.data.averages || [];
          const categories = averages.map(avg => avg.name);
          this.setState({ data: { dataset: averages, categories: categories } });
        }
      })
      .catch(_ => {});
  }

  render() {
    const { data } = this.state;
    if (data && data.dataset.length > 0 && data.categories.length > 0) {
      return this.renderChild(data);
    }
    return null;
  }
}
