<template>
    <div class="BlockSingleSelectedMonitoring">
        <div class="BlockSingleSelectedMonitoring-activity">
            <div class="BlockSingleSelectedMonitoring-header">
                Активность
                <div v-if="isHasChartsData" class="BlockSingleSelectedMonitoring-headerValue">
                    {{ lastActivityValue }}
                </div>
                <q-space />
                <MonitoringChartTooltip
                    class="MonitoringChartTooltip activity"
                    :date="chartsOptions.activity.tooltipDate"
                    :value="chartsOptions.activity.tooltipValue"
                    :show="chartsOptions.activity.tooltipShow"
                />
            </div>
            <div class="BlockSingleSelectedMonitoring-chartWrap activity" @mouseleave="onHideTooltip('activity')">
                <ChartJsMicroLine
                    class="BlockSingleSelectedMonitoring-chart"
                    fill
                    cursor
                    :data="chartsData.activity"
                    yAxes
                    xAxes
                    :yAxesMin="chartsOptions.activity.min"
                    :yAxesMax="chartsOptions.activity.max"
                    :xAxesMin="lastDayActivityDevicePeriod.from"
                    :xAxesMax="lastDayActivityDevicePeriod.to"
                    color="#00A1E7"
                    @tooltip="onChartsTooltip('activity', $event)"
                />
            </div>
        </div>
        <div class="BlockSingleSelectedMonitoring-battery">
            <div class="BlockSingleSelectedMonitoring-header">
                Батарея
                <div v-if="isHasChartsData" class="BlockSingleSelectedMonitoring-headerValue">
                    {{ lastBatteryValue }}%
                </div>
                <q-space />
                <MonitoringChartTooltip
                    class="MonitoringChartTooltip battery"
                    :date="chartsOptions.battery.tooltipDate"
                    :value="chartsOptions.battery.tooltipValue"
                    :show="chartsOptions.battery.tooltipShow"
                    unit="%"
                />
            </div>
            <div class="BlockSingleSelectedMonitoring-chartWrap battery" @mouseleave="onHideTooltip('battery')">
                <ChartJsMicroLine
                    class="BlockSingleSelectedMonitoring-chart"
                    fill
                    cursor
                    :data="chartsData.battery"
                    yAxes
                    xAxes
                    :yAxesMin="chartsOptions.battery.min"
                    :yAxesMax="chartsOptions.battery.max"
                    :xAxesMin="lastDayActivityDevicePeriod.from"
                    :xAxesMax="lastDayActivityDevicePeriod.to"
                    unit="%"
                    color="#00A1E7"
                    @tooltip="onChartsTooltip('battery', $event)"
                />
            </div>
        </div>

        <div class="BlockSingleSelectedMonitoring-daySelector">
            <PeriodDatepickerInput v-model="lastDayActivityDevicePeriod" label="Выберите дату отображения данных" />
        </div>
    </div>
</template>

<script>
import ChartJsMicroLine from '@components/common/chartjs/ChartJsMicroLine.vue';
import MonitoringChartTooltip from './MonitoringChartTooltip.vue';
import PeriodDatepickerInput from '@components/common/PeriodDatepickerInput.vue';

import startOfDay from '@services/utils/dateUtils/startOfDay';
import endOfDay from '@services/utils/dateUtils/endOfDay';
import dateParse from '@services/utils/dateUtils/parse';
import isFalse from '@services/utils/isFalse';
import buildChartsDataFromDevicesCoordinates from '@services/dataConverter/buildChartsDataFromDevicesCoordinates';

import { date as quasarDate, throttle } from 'quasar';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'BlockSingleSelectedMonitoring',
    components: {
        ChartJsMicroLine,
        MonitoringChartTooltip,
        PeriodDatepickerInput
    },
    computed: {
        ...mapGetters('DevicesSessions', ['selectedDevicesId', 'getDeviceById']),

        selectedDevice() {
            let id = this.selectedDevicesId[0];

            return this.getDeviceById(id);
        },

        isHasChartsData() {
            // Для определения, есть ли вообще данные для графиков, возьмем данные по активности
            return this.chartsData.activity.length > 0;
        },
        lastActivityValue() {
            if (!this.isHasChartsData) return '';

            let lastIndex = this.chartsData.activity.length - 1;
            return this.chartsData.activity[lastIndex].value;
        },
        lastBatteryValue() {
            if (!this.isHasChartsData) return '';

            let lastIndex = this.chartsData.battery.length - 1;
            return this.chartsData.battery[lastIndex].value;
        }
    },
    watch: {
        selectedDevicesId: {
            // При выборе разных устройств из таблицы, будем получать начало и конец дня,
            // когда были получены последние координаты от этого устройства
            handler(newSelectedDevicesId, oldSelectedDevicesId) {
                if (oldSelectedDevicesId && newSelectedDevicesId[0] === oldSelectedDevicesId[0]) return;

                this.$nextTick(() => (this.lastDayActivityDevicePeriod = this.getLastDayCoordinates()));
            },
            immediate: true
        },

        // При изменении периода времени будем запрашивать координаты
        // Меняется этот период в 2-х случаях: изменилось выбранное устройство в таблице
        // или выбрана новая дата из календаря
        lastDayActivityDevicePeriod() {
            this.requestLastDayCoordinates();
        }
    },
    data() {
        return {
            chartsData: {
                activity: [],
                battery: []
            },

            chartsOptions: {
                activity: {
                    min: 0,
                    max: 4000,
                    tooltipDate: '',
                    tooltipValue: '',
                    tooltipShow: false
                },
                battery: {
                    min: 0,
                    max: 100,
                    tooltipDate: '',
                    tooltipValue: '',
                    tooltipShow: false
                }
            },
            isActiveRequestLastDayCoordinates: false,
            lastDayActivityDevicePeriod: {
                from: null,
                to: null
            }
        };
    },
    created() {
        this.onChartsTooltip = throttle(this.onChartsTooltip, 20);
    },
    methods: {
        ...mapActions('DevicesSessions', ['requestDeviceCoordinates']),

        // Получает период дат, равный суткам в тот день, когда были последние координаты от устройства
        getLastDayCoordinates() {
            let result = { from: null, to: null };
            if (isFalse(this.selectedDevice)) return result;
            let { connectTime } = this.selectedDevice;
            if (isFalse(connectTime)) return result;

            connectTime = dateParse(connectTime);
            result.from = startOfDay(connectTime);
            result.to = endOfDay(connectTime);

            return result;
        },

        async requestLastDayCoordinates(selectedDevicesId = this.selectedDevicesId) {
            this.isActiveRequestLastDayCoordinates = true;

            let { from, to } = this.lastDayActivityDevicePeriod;

            let res = await this.requestDeviceCoordinates({ selectedDevicesId, from, to });
            if (res) this.chartsData = buildChartsDataFromDevicesCoordinates(res);

            this.isActiveRequestLastDayCoordinates = false;
        },

        onChartsTooltip(chartName, tooltip) {
            let date = '';
            let value = '';
            let show = tooltip.opacity ? true : false;

            if (tooltip.title) {
                date = dateParse(tooltip.title[0]);
                date = quasarDate.formatDate(date, 'DD.MM.YYYY HH:mm');
            }
            if (tooltip.body) value = tooltip.body[0].lines[0];

            this.chartsOptions[chartName].tooltipDate = date;
            this.chartsOptions[chartName].tooltipValue = value;
            this.chartsOptions[chartName].tooltipShow = show;
        },

        onHideTooltip(chartName) {
            this.chartsOptions[chartName].tooltipShow = false;
        }
    }
};
</script>

<style lang="sass">
.BlockSingleSelectedMonitoring
    padding: 0 16px 8px 16px

    &-header
        font-size: 14px
        font-weight: bold
        height: 24px
        display: flex
    &-headerValue
        color: var(--ms-primary)
        margin-left: 8px
    &-chartWrap
        height: 100px
        position: relative
        &.activity
        &.battery
            padding-left: 8px
    &-chart
        width: 100%
        height: 100%
        left: 0
        right: 0
        top: 0
        bottom: 0
    &-activity
        padding-top: 8px
    &-battery
        padding-top: 8px

    &-daySelector
        padding-top: 8px

    .MonitoringChartTooltip
        .MonitoringChartTooltip-value
            min-width: 40px
            display: flex
            justify-content: flex-end
</style>
