<template>
    <div class="AmCharts">
        <div class="AmCharts-chart" ref="amcharts" />
        <q-resize-observer ref="observer" @resize="onChartResize" />
    </div>
</template>

<script>
import {
    useTheme,
    create as amchartsCreate,
    color as amchartsColor,
    Percent,
    ColorSet
} from '@amcharts/amcharts4/core';
import { PieChart, PieSeries } from '@amcharts/amcharts4/charts';

import am4themes_animated from '@amcharts/amcharts4/themes/animated';
import am4themes_material from '@amcharts/amcharts4/themes/material';

useTheme(am4themes_animated);
useTheme(am4themes_material);

import { byPercent } from '@services/utils';

export default {
    name: 'AmCharts',
    props: {
        minSize: {
            type: Number,
            required: false,
            default: 0
        },
        maxSize: {
            type: Number,
            required: false,
            default: Infinity
        },
        percent: {
            type: Number,
            required: false,
            default: 99
        },
        padding: {
            type: Array,
            required: false,
            default: () => [0, 0]
        },
        data: {
            type: Array,
            required: true,
            default: () => []
        },
        idKey: {
            type: String,
            required: false,
            default: 'id'
        },
        sort: {
            type: Function,
            required: false
        }
    },
    watch: {
        minSize() {
            this.computeChartSize();
        },
        maxSize() {
            this.computeChartSize();
        },
        percent() {
            this.computeChartSize();
        },
        padding() {
            this.computeChartSize();
        },
        data(newData) {
            this.chart.data = this.sortFn(newData);

            // Повторяет стартовую анимацию при смене данных
            this.pieSeries.appear();
        }
    },
    data() {
        return {
            chart: null,
            pieSeries: null,
            wasInit: false,
            selected: null,
            active: null,
            containerSize: {
                width: null,
                height: null
            },
            chartRadius: new Percent(this.percent),
            labelsWidth: null,
            colorList: []
        };
    },
    created() {
        window.AmCharts = this;
    },
    mounted() {
        let chart = amchartsCreate(this.$refs.amcharts, PieChart);
        let data = this.sortFn(this.data);

        chart.data = data;
        chart.pixelPerfect = true;

        chart.align = 'center';
        chart.valign = 'middle';
        chart.radius = this.chartRadius;

        // Конфигурация набора данных для отображения в графике
        let pieSeries = chart.series.push(new PieSeries());
        pieSeries.dataFields.id = this.idKey;
        pieSeries.dataFields.value = 'value';
        pieSeries.dataFields.category = 'name';
        pieSeries.slices.template.stroke = amchartsColor('#fff');
        pieSeries.slices.template.strokeWidth = 2;
        pieSeries.slices.template.strokeOpacity = 1;

        pieSeries.labels.template.paddingTop = 0;
        pieSeries.labels.template.paddingBottom = 0;

        // pieSeries.labels.template.text = '{category}: {value.value}';

        pieSeries.labels.template.maxWidth = this.labelsWidth;
        pieSeries.labels.template.truncate = true;
        pieSeries.labels.template.tooltipText = '{category}: {value}';

        // pieSeries.slices.template.alwaysShowTooltip = true;

        pieSeries.autoWrap = true;

        chart.responsive.enabled = true;
        chart.responsive.useDefault = false;

        chart.events.on('inited', e => {
            this.wasInit = true;

            this.computeChartSize();
        });

        // Задает начальную анимацию разворачивания графика
        pieSeries.hiddenState.properties.opacity = 1;
        pieSeries.hiddenState.properties.endAngle = -90;
        pieSeries.hiddenState.properties.startAngle = -90;

        pieSeries.slices.template.events.on('hit', e => this.onHit(e, false));
        pieSeries.labels.template.events.on('hit', e => this.onHit(e));

        data.forEach(({ color }) => {
            if (!color) return;

            this.colorList.push(amchartsColor(color));
        });

        if (this.colorList.length === data.length) {
            pieSeries.colors.list = this.colorList;
        }

        this.chart = chart;
        this.pieSeries = pieSeries;
    },
    beforeDestroy() {
        if (this.chart) {
            this.chart.dispose();
        }
    },
    methods: {
        sortFn(data) {
            let result;

            if (this.sort) {
                result = [...data].sort(this.sort);
            } else {
                result = data;
            }

            return result;
        },
        computeChartSize() {
            if (!this.wasInit) return;

            // Получаем в пикселях нужный процент от ширины контейнера графика
            let chartPercentInPixels = byPercent(this.containerSize.width, this.percent);

            // Чтобы график адекватно реагировал на высоту контейнера
            let minHeight = this.containerSize.height - this.padding[0] * 2;
            if (chartPercentInPixels > minHeight) {
                chartPercentInPixels = minHeight;
            }

            // Проверки на минимально и максимально допустимые размеры графика
            if (chartPercentInPixels < this.minSize) {
                chartPercentInPixels = this.minSize;
            } else if (chartPercentInPixels > this.maxSize) {
                chartPercentInPixels = this.maxSize;
            }

            this.computeSizes(chartPercentInPixels);

            this.chart.radius = this.chartRadius;
            this.pieSeries.labels.template.maxWidth = this.labelsWidth;
        },
        computeSizes(chartPercentInPixels) {
            let chartRadius = chartPercentInPixels / 2;
            let labelsWidth = (this.containerSize.width - chartPercentInPixels) / 2;

            this.chartRadius = chartRadius;
            this.labelsWidth = labelsWidth + byPercent(this.containerSize.width, 5);
        },
        onChartResize({ width, height }) {
            this.containerSize.width = width;
            this.containerSize.height = height;

            this.computeChartSize();
        },
        onHit(e, remote) {
            let selectedItemData = e.target.dataItem.dataContext;

            // Если не найдено поле с id или нет такого id, то сбрасываем выбранный сегмент и выходим
            let selectedId = selectedItemData[this.idKey];
            if (selectedId === undefined) {
                this.clearSelected();
                return;
            }

            // Вручную нужно контролировать чтобы был выбран только один сегмент графика
            this.selectById(selectedId, remote);

            this.$emit('selected', selectedItemData);
        },
        // Возвращает сегмент по его полю id
        findSliceById(id) {
            let slice = null;

            this.pieSeries.slices.each(item => {
                let itemData = item.dataItem.dataContext;
                if (itemData[this.idKey] !== undefined && itemData[this.idKey] === id) {
                    slice = item;
                }
            });

            return slice;
        },
        selectById(id, remote = true) {
            let isSelect = false;
            // Если не найден сегмент - сбрасываем ранее выбранный сегмент и выходим
            let slice = this.findSliceById(id);
            if (!slice) {
                this.clearSelected();
                return false;
            }

            // Если выбор вызван снаружи, а не из обработчика onHit, то инвертируем текущее состояние сегмента,
            // а если из обработчика onHit, то сегмент уже выбран/не выбран правильно и инвертировать не нужно
            isSelect = remote ? !slice.isActive : slice.isActive;

            this.clearSelected();
            slice.isActive = isSelect;

            this.selected = isSelect ? slice : null;

            return isSelect;
        },
        activeById(id) {
            let isActive = false;
            let slice = this.findSliceById(id);
            if (!slice) {
                this.clearActive();
                return false;
            }

            isActive = !slice.isHover;
            this.clearActive();

            slice.isHover = isActive;
            this.active = isActive ? slice : null;

            return isActive;
        },
        clearActive() {
            this.pieSeries.slices.each(item => (item.isHover = false));
            this.active = null;
        },
        clearSelected() {
            this.pieSeries.slices.each(item => (item.isActive = false));
            this.selected = null;
        }
    }
};
</script>

<style lang="sass">
.AmCharts
    width: 100%
    height: 100%
    display: flex
    flex-direction: column
    justify-content: center
    align-items: center
    &-chart
        // width: calc(var(--percent) * 1%)
        // height: calc(var(--percent) * 1%)

        // width: 50%
        // height: 50%

        flex-grow: 1
        width: 100%
        height: 100%
    &-hide
        opacity: 0
</style>
