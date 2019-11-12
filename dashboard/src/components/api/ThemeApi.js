import React from 'react';
import axios from 'axios';

export default class ThemeApi extends React.Component {
  constructor(props) {
    super(props);
    const {
      children: { render: renderChild },
    } = props;

    this.renderChild = renderChild;
    this.state = { data: null };
  }

  componentDidMount() {
    axios
      .get('http://127.0.0.1:4000/api/averages/themes')
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
