<template>
    <div class="ChartJsMicroLine" :style="{ '--chartjs-color': color }">
        <canvas class="chartjs" ref="chartjs"></canvas>
    </div>
</template>

<script>
import dateParse from '@services/utils/dateUtils/parse';
import { date as quasarDate, colors as quasarColors } from 'quasar';
import Chart from 'chart.js';

export default {
    name: 'ChartJsMicroLine',
    props: {
        data: {
            type: Array,
            required: true,
            default: () => []
        },
        unit: {
            type: String,
            required: false,
            default: ''
        },
        padding: {
            type: Array,
            required: false,
            default: () => [0, 0, 0, 0]
        },
        color: {
            type: String,
            required: false,
            default: '#4bc0c0'
        },
        fill: {
            type: Boolean,
            required: false,
            default: false
        },
        cursor: {
            type: Boolean,
            required: false,
            default: false
        },
        tooltip: {
            type: Boolean,
            required: false,
            default: false
        },
        yAxes: {
            type: Boolean,
            required: false,
            default: false
        },
        yAxesMin: {
            type: Number,
            required: false
        },
        yAxesMax: {
            type: Number,
            required: false
        },
        xAxes: {
            type: Boolean,
            required: false,
            default: false
        },
        xAxesMin: {
            type: [Date, String, Number],
            required: false
        },
        xAxesMax: {
            type: [Date, String, Number],
            required: false
        }
    },
    data() {
        return {
            chart: null,
            canvas: null,
            context: null
        };
    },
    computed: {
        computeScales() {
            return {
                xAxes: [
                    {
                        display: this.xAxes,
                        type: 'time',
                        displayFormats: {
                            day: 'DD.MM.YY hh:mm',
                            hour: 'DD.MM.YY hh:mm',
                            minute: 'DD.MM.YY hh:mm',
                            second: 'DD.MM.YY hh:mm',
                            millisecond: 'DD.MM.YY hh:mm'
                        },
                        distribution: 'linear',
                        bounds: 'ticks',
                        ticks: {
                            min: this.xAxesMin,
                            max: this.xAxesMax,
                            fontSize: 8,
                            fontColor: '#6C83A1',
                            callback: function(value, index, values) {
                                let currentValue = values[index].value;
                                let currentDate = new Date(currentValue);

                                return quasarDate.formatDate(currentDate, 'HH:mm');
                            }
                        }
                    }
                ],
                yAxes: [
                    {
                        display: this.yAxes,
                        ticks: {
                            min: this.yAxesMin,
                            max: this.yAxesMax,
                            fontColor: '#6C83A1'
                        }
                    }
                ]
            };
        },

        options() {
            return {
                layout: {
                    padding: {
                        top: this.padding[0],
                        right: this.padding[1],
                        bottom: this.padding[2],
                        left: this.padding[3]
                    }
                },
                tooltips: {
                    enabled: false,
                    intersect: false,
                    mode: 'nearest',
                    axis: 'x',
                    custom: this.customTooltips
                },
                elements: {
                    point: {
                        radius: 0
                    }
                },
                legend: {
                    display: false
                },

                scales: this.computeScales
            };
        }
    },
    watch: {
        padding() {
            this.updateOptions();
        },
        data: {
            handler(newData) {
                this.updateData(newData);
            },
            deep: true
        },
        color(newColor) {
            this.updateColor(newColor);
        },
        fill(newFill) {
            this.updateFill(newFill);
        },
        cursor(newCursor) {
            if (!newCursor) {
                this.deleteCursor();
            }
        },
        tooltip(newTooltip) {
            if (!newTooltip) {
                this.deleteTooltip();
            }
        },
        yAxes() {
            this.updateOptions();
        },
        yAxesMin() {
            this.updateOptions();
        },
        yAxesMax() {
            this.updateOptions();
        },
        xAxes() {
            this.updateOptions();
        },
        xAxesMin() {
            this.updateOptions();
        },
        xAxesMax() {
            this.updateOptions();
        }
    },
    created() {
        window.ChartJsMicroLine = this;
    },
    mounted() {
        let data = this.getData();
        let labels = this.getLabels();
        this.canvas = this.$refs.chartjs;

        // Получаем физические размеры графика на странице и явно указываем их в качестве размеров канваса
        this.updateSize();

        this.context = this.canvas.getContext('2d');
        let gradient = this.getGradient();

        this.chart = new Chart(this.$refs.chartjs, {
            type: 'line',
            data: {
                labels,
                datasets: [
                    {
                        data,
                        fill: this.fill,
                        backgroundColor: gradient,
                        borderColor: this.getColor(),
                        borderWidth: 2,
                        pointBackgroundColor: this.getColor(),
                        lineTension: 0.1
                    }
                ]
            },
            options: this.options
        });
    },
    beforeDestroy() {
        this.deleteTooltip();
        this.deleteCursor();
    },
    methods: {
        updateSize() {
            let { width, height } = getComputedStyle(this.canvas);
            this.canvas.width = width;
            this.canvas.height = height;
        },
        updateFill(fill = this.fill) {
            this.chart.data.datasets[0].fill = fill;

            this.chart.update();
        },
        updateColor(color = this.color) {
            let gradient = this.getGradient(color);
            color = this.getColor(color);

            this.chart.data.datasets[0].backgroundColor = gradient;
            this.chart.data.datasets[0].borderColor = color;
            this.chart.data.datasets[0].pointBackgroundColor = color;

            this.chart.update();
        },
        getGradient(color = this.color) {
            let { height } = getComputedStyle(this.canvas);
            let gradient = this.context.createLinearGradient(0, 0, 0, parseInt(height));
            gradient.addColorStop(0.0, this.getColor(color, 10));
            gradient.addColorStop(1.0, '#ffffff00');

            return gradient;
        },
        getColor(color = this.color, percent = 0) {
            color = quasarColors.textToRgb(color);
            color = quasarColors.rgbToHex(color);
            return quasarColors.lighten(color, percent);
        },
        updateData(newData) {
            let labels = this.getLabels(newData);
            this.chart.data.labels = labels;

            let data = this.getData(newData);
            this.chart.data.datasets[0].data = data;

            this.chart.update();
        },
        getData(data = this.data) {
            return data.map(({ value }) => value);
        },
        getLabels(data = this.data) {
            return data.map(({ date }) => date);
        },

        updateOptions() {
            this.chart.options = this.options;
            this.chart.update();
        },

        deleteTooltip() {
            let tooltipEl = document.querySelector('.chartjs-tooltip');

            if (tooltipEl) {
                tooltipEl.remove();
            }
        },
        deleteCursor() {
            let cursorEl = document.querySelector('.chartjs-cursor');

            if (cursorEl) {
                cursorEl.remove();
            }
        },
        customTooltips(tooltip) {
            this.$emit('tooltip', tooltip);

            let tooltipEl = document.querySelector('.chartjs-tooltip');
            let cursorEl = document.querySelector('.chartjs-cursor');

            if (tooltip.opacity === 0) {
                if (tooltipEl) tooltipEl.style.opacity = 0;
                if (cursorEl) cursorEl.style.opacity = 0;
                return;
            }

            if (!this.tooltip && !this.cursor) return;

            let offsetTop = this.$refs.chartjs.offsetTop;
            let offsetLeft = this.$refs.chartjs.offsetLeft;
            let { top, left } = this.$refs.chartjs.getBoundingClientRect();
            let positionY = top + offsetTop + tooltip.caretY;
            let positionX = left + offsetLeft + tooltip.caretX;

            if (this.tooltip) {
                if (!tooltipEl) {
                    tooltipEl = document.createElement('div');
                    tooltipEl.className = 'chartjs-tooltip';
                    tooltipEl.innerHTML = '<table></table>';
                    document.body.appendChild(tooltipEl);
                }

                tooltipEl.classList.remove('above', 'below', 'no-transform');
                if (tooltip.yAlign) {
                    tooltipEl.classList.add(tooltip.yAlign);
                } else {
                    tooltipEl.classList.add('no-transform');
                }

                if (tooltip.body) {
                    let titleLines = tooltip.title || [];
                    let bodyLines = tooltip.body.map(bodyItem => bodyItem.lines);
                    let innerHtml = '<tr style="vertical-align: text-bottom;">';

                    titleLines.forEach(title => {
                        let date = dateParse(title);
                        date = quasarDate.formatDate(date, 'DD.MM.YYYY HH:mm');
                        innerHtml += '<td class="chartjs-tooltip-key">' + date + ': </td>';
                    });

                    bodyLines.forEach((body, i) => {
                        innerHtml += '<td class="chartjs-tooltip-value">' + body + this.unit + '</td>';
                    });
                    innerHtml += '</tr>';

                    let tableRoot = tooltipEl.querySelector('table');
                    tableRoot.innerHTML = innerHtml;
                }

                tooltipEl.style.opacity = 1;
                tooltipEl.style.top = positionY + 'px';
                tooltipEl.style.left = positionX + 'px';
                tooltipEl.style.fontFamily = tooltip._bodyFontFamily;
                tooltipEl.style.fontSize = tooltip.bodyFontSize + 'px';
                tooltipEl.style.fontStyle = tooltip._bodyFontStyle;
                tooltipEl.style.padding = tooltip.yPadding + 'px ' + tooltip.xPadding + 'px';
            } else if (!this.tooltip && tooltipEl) {
                tooltipEl.style.opacity = 0;
            }

            if (this.cursor) {
                if (!cursorEl) {
                    cursorEl = document.createElement('div');
                    cursorEl.className = 'chartjs-cursor';
                    document.body.appendChild(cursorEl);
                }

                let canvasHeight = this.$refs.chartjs.offsetHeight;
                let chartHeight = tooltip.height;

                cursorEl.style.opacity = 1;
                cursorEl.style.height = Math.round(canvasHeight) + 'px';
                cursorEl.style.top = Math.round(top) + 'px';
                cursorEl.style.left = Math.round(positionX) + 'px';
                cursorEl.style.setProperty('--translate-y', tooltip.caretY - canvasHeight);
                cursorEl.style.setProperty('--chartjs-color', this.color);
            } else if (!this.cursor && cursorEl) {
                cursorEl.style.opacity = 0;
            }
        }
    }
};
</script>

<style lang="sass">
.ChartJsMicroLine
    position: relative
    .chartjs
        width: 100%
        height: 100%

.chartjs-tooltip
    white-space: pre
    z-index: 2001
    opacity: 1
    position: fixed
    background: rgba(0, 0, 0, 0.7)
    color: white
    border-radius: 3px
    transition: top 200ms ease, left 200ms ease, opacity 100ms ease
    pointer-events: none
    transform: translate(-50%, 8px)
    .chartjs-tooltip-key
        opacity: 0.8
        font-size: 0.9em
    .chartjs-tooltip-value
        font-weight: bold
        font-size: 1.2em

.chartjs-cursor
    --translate-y: 0
    position: fixed
    width: 1px
    background-color: var(--chartjs-color)
    pointer-events: none
    z-index: 2000
    transition: opacity 250ms ease
    box-shadow: 0 0 5px 1px rgba(255, 255, 255, 0.8);
    &:before
        content: ''
        position: absolute
        left: 50%
        bottom: 0
        width: 8px
        height: 8px
        border-radius: 50%
        background-color: var(--chartjs-color)
        transform: translate(-50%, calc( var(--translate-y) * 1px + 50% ))
        box-shadow: 0 0 5px 1px rgba(255, 255, 255, 0.8);
</style>
