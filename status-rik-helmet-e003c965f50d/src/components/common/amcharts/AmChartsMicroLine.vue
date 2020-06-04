<template>
    <div class="AmChartsMicroLine">
        <div class="AmChartsMicroLine-chart" ref="amcharts" />
    </div>
</template>

<script>
import { useTheme, create as amchartsCreate, color as amchartsColor } from '@amcharts/amcharts4/core';
import { XYChart, DateAxis, ValueAxis, LineSeries, XYCursor, CircleBullet } from '@amcharts/amcharts4/charts';

import am4themes_animated from '@amcharts/amcharts4/themes/animated';
import am4themes_material from '@amcharts/amcharts4/themes/material';

useTheme(am4themes_animated);
useTheme(am4themes_material);

export default {
    name: 'AmChartsMicroLine',
    props: {
        data: {
            type: Array,
            required: true,
            default: () => []
        }
    },
    data() {
        return {
            chart: null,
            dateAxis: null,
            valueAxis: null,
            series: null,
            bullet: null
        };
    },
    created() {
        window.AmChartsMicroLine = this;
    },
    mounted() {
        let chart = amchartsCreate(this.$refs.amcharts, XYChart);
        chart.data = this.data;
        chart.padding(0, 0, 2, 0);

        // chart.tooltip.zIndex = 1000;

        let dateAxis = chart.xAxes.push(new DateAxis());
        dateAxis.renderer.grid.template.disabled = true;
        dateAxis.renderer.labels.template.disabled = true;
        dateAxis.startLocation = 0.9;
        dateAxis.endLocation = 1;
        dateAxis.cursorTooltipEnabled = false;

        let valueAxis = chart.yAxes.push(new ValueAxis());
        valueAxis.min = 0;
        valueAxis.renderer.grid.template.disabled = true;
        valueAxis.renderer.baseGrid.disabled = true;
        valueAxis.renderer.labels.template.disabled = true;
        valueAxis.cursorTooltipEnabled = false;

        chart.cursor = new XYCursor();
        chart.cursor.lineY.disabled = true;
        chart.cursor.behavior = 'none';

        let series = chart.series.push(new LineSeries());
        series.tooltipText = '{date}: [bold]{value}';
        series.dataFields.dateX = 'date';
        series.dataFields.valueY = 'value';
        series.tensionX = 0.8;
        series.strokeWidth = 2;
        // series.stroke = color;

        // let bullet = series.bullets.push(new CircleBullet());
        // bullet.circle.opacity = 1;
        // bullet.circle.propertyFields.opacity = 1;
        // bullet.circle.radius = 3;

        this.chart = chart;
        this.dateAxis = dateAxis;
        this.valueAxis = valueAxis;
        this.series = series;
        // this.bullet = bullet;
    }
};
</script>

<style lang="sass">
.AmChartsMicroLine
    z-index: 1
    &-chart
        width: 100%
        height: 100%
</style>
