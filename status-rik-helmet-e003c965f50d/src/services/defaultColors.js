// https://www.amcharts.com/demos/donut-chart/?theme=material
// https://quasar.dev/style/color-palette

import { remixArray } from './utils';

const defaultColors = {
    red: '#f44336',
    pink: '#e91e63',
    purple: '#9c27b0',
    deepPurple: '#673ab7',
    indigo: '#3f51b5',
    blue: '#2196f3',
    lightBlue: '#03a9f4',
    cyan: '#00bcd4',
    teal: '#009688',
    green: '#4caf50',
    lightGreen: '#8bc34a',
    lime: '#cddc39',
    yellow: '#ffeb3b',
    amber: '#ffc107',
    orange: '#ff9800',
    deepOrange: '#ff5722'
};

const colorsArr = [
    defaultColors.red,
    defaultColors.pink,
    defaultColors.purple,
    defaultColors.deepPurple,
    defaultColors.indigo,
    defaultColors.blue,
    defaultColors.lightBlue,
    defaultColors.cyan,
    defaultColors.teal,
    defaultColors.green,
    defaultColors.lightGreen,
    defaultColors.lime,
    defaultColors.yellow,
    defaultColors.amber,
    defaultColors.orange,
    defaultColors.deepOrange
];

const colorsArrRandom = remixArray.bind(this, colorsArr);

export default defaultColors;

export { defaultColors, colorsArr, colorsArrRandom };
