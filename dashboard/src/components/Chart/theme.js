import Highcharts from 'highcharts';

Highcharts.theme = {
  colors: ['#5f98cf', '#434348', '#49a65e', '#f45b5b', '#708090', '#b68c51', '#397550', '#c0493d', '#4f4a7a', '#b381b3'],
  chart: {
    backgroundColor: 'rgb(240, 240, 255)',
  },
  title: {
    style: {
      color: '#000',
      font: '300 16px "euclid-square", sans-serif',
    },
  },
  subtitle: {
    style: {
      color: '#666666',
      font: 'bold 12px "euclid-square", sans-serif',
    },
  },
  legend: {
    itemStyle: {
      font: '9pt "euclid-square", sans-serif',
      color: 'black',
    },
    itemHoverStyle: {
      color: 'gray',
    },
  },
};
Highcharts.setOptions(Highcharts.theme);
