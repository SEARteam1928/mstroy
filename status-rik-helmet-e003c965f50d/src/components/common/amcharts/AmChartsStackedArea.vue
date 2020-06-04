<template>
    <div class="AmChartsStackedArea">
        <div class="AmChartsStackedArea-chart" ref="amcharts" />
    </div>
</template>

<script>
import { useTheme, create as amchartsCreate, color as amchartsColor, Scrollbar } from '@amcharts/amcharts4/core';
import { XYChart, DateAxis, ValueAxis, LineSeries, XYCursor, Legend, CircleBullet } from '@amcharts/amcharts4/charts';
import am4lang_ru_RU from '@amcharts/amcharts4/lang/ru_RU';

import am4themes_animated from '@amcharts/amcharts4/themes/animated';
import am4themes_material from '@amcharts/amcharts4/themes/material';

useTheme(am4themes_animated);
useTheme(am4themes_material);

export default {
    name: 'AmChartsStackedArea',
    props: {
        data: {
            type: Array,
            required: true,
            default: () => []
        },
        timeField: {
            type: String,
            required: true
        },
        dataFields: {
            type: [Array, Object],
            required: true,
            default: () => []
        },
        colorSet: {
            type: Object,
            required: false
        },
        idKey: {
            type: String,
            required: false,
            default: 'id'
        }
    },
    watch: {
        data(newData) {
            this.chart.data = newData;
        }
    },
    data() {
        return {
            chart: null,
            dateAxis: null,
            tooltipTemplate: '[#000]{valueY.value} ч/ч[/]'
        };
    },
    created() {
        window.AmChartsStackedArea = this;
    },
    mounted() {
        let chart = amchartsCreate(this.$refs.amcharts, XYChart);
        chart.language.locale = am4lang_ru_RU;
        chart.data = this.data;

        let dateAxis = chart.xAxes.push(new DateAxis());
        dateAxis.renderer.minGridDistance = 60;
        dateAxis.startLocation = 0.5;
        dateAxis.endLocation = 0.5;
        dateAxis.baseInterval = {
            timeUnit: this.timeField,
            count: 1
        };

        let valueAxis = chart.yAxes.push(new ValueAxis());

        let dataFields = [];
        if (this.dataFields instanceof Array) {
            dataFields = this.dataFields;
        } else if (this.dataFields instanceof Object) {
            dataFields = Object.entries(this.dataFields);
        }

        dataFields.forEach(field => {
            let { name, dataField } = this.detectField(field);

            let series = chart.series.push(new LineSeries());
            series.dataFields.dateX = this.timeField;
            series.name = name;
            series.dataFields.valueY = dataField;
            series.tooltipText = `[#000]${name}:[/] ${this.tooltipTemplate}`;
            series.tooltip.background.fill = amchartsColor('#FFF');
            series.tooltip.getStrokeFromObject = true;
            series.tooltip.background.strokeWidth = 3;
            series.tooltip.getFillFromObject = false;
            series.fillOpacity = 0.6;
            series.strokeWidth = 2;
            series.stacked = true;
            series.tensionX = 0.9;
            series.tensionY = 0.9;

            series.fill = amchartsColor(this.colorSet[dataField]);
            series.stroke = amchartsColor(this.colorSet[dataField]);

            let bullet = series.bullets.push(new CircleBullet());
            bullet.propertyFields = {
                zoneName: name,
                zoneId: dataField
            };

            bullet.events.on('hit', this.onClick, this);

            series.tooltip.propertyFields = {
                zoneName: name,
                zoneId: dataField
            };

            series.tooltip.label.interactionsEnabled = true;
            window.tooltip = series.tooltip;

            tooltip.events.on('hit', this.onClick, this);
        });

        chart.cursor = new XYCursor();
        chart.cursor.xAxis = dateAxis;

        chart.scrollbarX = new Scrollbar();

        chart.legend = new Legend();
        chart.legend.position = 'top';

        this.chart = chart;
    },
    methods: {
        onClick(e) {
            this.$emit('click', e);
        },

        detectField(field) {
            let result = { name: '', dataField: '' };

            if (field instanceof Array) {
                result.name = field[1];
                result.dataField = field[0];
            } else {
                result.name = field;
                result.dataField = field;
            }

            return result;
        }
    }
};
</script>

<style lang="sass">
.AmChartsStackedArea
    width: 100%
    height: 100%
    display: flex
    flex-direction: column
    justify-content: center
    align-items: center
    &-chart
        flex-grow: 1
        width: 100%
        height: 100%
</style>
