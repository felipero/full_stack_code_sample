import React from 'react';
import axios from 'axios';

export default class AverageApi extends React.Component {
  constructor(props) {
    super(props);
    const {
      children: { render: renderChild },
      callback: setData,
      selectedId: selectedId,
      type: type,
      searchTerm: searchTerm,
    } = props;

    this.axios = axios.create({ baseURL: process.env.REACT_APP_API_HOST });
    this.setData = setData;
    this.renderChild = renderChild;
    this.selectedId = selectedId;
    this.searchTerm = searchTerm;
    this.type = type;
    this.state = { data: null };
  }

  componentDidMount() {
    const path = '/averages/' + this.type;
    const query = this.searchTerm ? '?term=' + this.searchTerm : this.selectedId ? '/' + this.selectedId : '';
    this.axios
      .get(path + query)
      .then(resp => {
        if (resp && resp.data) {
          const averages = resp.data.averages || [];
          const categories = averages.map(avg => avg.name);
          this.setData(averages);
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
