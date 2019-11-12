import React from 'react';
import Highcharts from 'highcharts';
import HighchartsReact from 'highcharts-react-official';
import './theme';

const options = {
  chart: {
    type: 'bar',
  },
  title: {
    text: null,
  },
  legend: { enabled: false },
  xAxis: {
    categories: null,
  },
  plotOptions: {
    series: {
      colorByPoint: true,
      pointWidth: 20,
      pointPadding: 0.3,
    },
  },
  tooltip: {
    valueDecimals: 1,
    valueSuffix: '%',
  },
  responsive: {
    rules: [
      {
        condition: {
          maxWidth: 500,
        },
        // Make the labels less space demanding on mobile
        chartOptions: {
          xAxis: {
            labels: {
              formatter: function() {
                return this.value.substring(0, 3);
              },
            },
          },
        },
      },
    ],
  },
  series: [
    {
      name: 'Sentiment',
      data: null,
    },
  ],
};

function Chart({ dataset, categories, title }) {
  const dataSeries = dataset.map(item => {
    return [item.name, item.sentiment * 100];
  });

  options.series[0].data = dataSeries;
  options.xAxis.categories = categories;
  options.title.text = title;
  if (dataSeries.length >= 10) {
    options.chart.height = 300 + dataSeries.length * 20.3;
  }
  return <HighchartsReact highcharts={Highcharts} options={options} />;
}

export default Chart;
