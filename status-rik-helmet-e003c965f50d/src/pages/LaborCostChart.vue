<template>
    <q-page class="LaborCostChart-page page-background">
        <div class="LaborCostChart page-block">
            <div class="LaborCostChart-header">
                <div class="LaborCostChart-title">График распределения трудозатрат по зонам</div>
                <PeriodDatepickerInput
                    class="PeriodDatepickerInput"
                    clickableInput
                    clearable
                    dense
                    align="top middle"
                    panel="range"
                    label="Выбор даты"
                    :mobileMode="$q.screen.width <= 480"
                    :from="periodDate.from"
                    :to="periodDate.to"
                    @input="onDateInput"
                    @reset="onDateReset"
                />
            </div>

            <div class="LaborCostChart-chart">
                <DataPreloader
                    :loading="isLoading"
                    :error="isError"
                    :info="emptyPeriodDate"
                    infoMessage="Не выбран период"
                    :warning="emptyChartData"
                    warningMessage="Нет данных за выбранный период"
                    :vertical="true"
                >
                    <AmChartsStackedArea
                        class="AmChartsStackedArea"
                        :data="nearObjectsChartData"
                        timeField="day"
                        :dataFields="nearObjectsMap"
                        :colorSet="nearObjectsColorSet"
                        @click="onZoneClick"
                    />
                </DataPreloader>
            </div>
        </div>

        <q-dialog
            class="LaborCostChart-modal"
            full-height
            full-width
            :maximized="$q.screen.sm || $q.screen.xs"
            @hide="onDialogZoneHide"
            ref="dialogZone"
        >
            <ModalZone />
        </q-dialog>
    </q-page>
</template>

<script>
import { date } from 'quasar';
const { addToDate } = date;

import PeriodDatepickerInput from '../components/common/PeriodDatepickerInput.vue';
import DataPreloader from '../components/common/DataPreloader.vue';
import AmChartsStackedArea from '../components/common/amcharts/AmChartsStackedArea.vue';
import ModalZone from '../components/WorkPerformance/ModalZone.vue';
import dateISONormalize from '../services/utils/dateISONormalize';

import withProjectSwitch from '@mixins/withProjectSwitch';
import withModuleErrors from '@mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'LaborCostChart',
    components: {
        PeriodDatepickerInput,
        DataPreloader,
        AmChartsStackedArea,
        ModalZone
    },
    mixins: [withModuleErrors('LaborCostChart'), withProjectSwitch('LaborCostChart')],
    watch: {
        periodDate(newPeriodDate) {
            this.setPeriodFrom(newPeriodDate.from);
            this.setPeriodTo(newPeriodDate.to);

            this.update();
        }
    },
    computed: {
        ...mapGetters('LaborCostChart', [
            'moduleErrors',
            'periodDate',
            'nearObjectsMap',
            'nearObjectsChartData',
            'nearObjectsColorSet',
            'isLoading',
            'emptyChartData',
            'emptyPeriodDate'
        ]),

        isError() {
            return this.moduleErrors.requestNearObjects !== undefined;
        }
    },
    created() {
        window.LaborCostChart = this;

        this.setWeekAgoDates();

        // Изначальный запрос на загрузку данных будет инициализирован вызовом
        // projectSwitch из миксина withProjectSwitch
    },
    beforeDestroy() {
        this.clearPeriodDate();
        this.reset();
    },
    methods: {
        ...mapMutations('LaborCostChart', [
            'setProjectId',
            'setPeriodDate',
            'clearPeriodDate',
            'clearNearObjectsChartData'
        ]),
        ...mapActions('LaborCostChart', ['requestNearObjects']),

        ...mapMutations('WorkPerformance', [
            'setPeriodFrom',
            'setPeriodTo',
            'setSelectedZoneId',
            'setSelectedZoneName'
        ]),
        ...mapMutations('WorkPerformance', {
            setProjectIdModal: 'setProjectId'
        }),

        update() {
            // Запрос распределения рабочего времени по зонам
            this.requestNearObjects();
        },
        reset() {
            this.clearNearObjectsChartData();

            this.setSelectedZoneName(null);
            this.setSelectedZoneId(null);
        },

        onDateInput(prop) {
            this.setPeriodDate(prop);
        },
        onDateReset() {
            this.clearPeriodDate();
            this.reset();
        },

        onZoneClick({ target }) {
            let { zoneName, zoneId } = target.propertyFields;

            this.setSelectedZoneName(zoneName);
            this.setSelectedZoneId(Number(zoneId));

            this.$refs.dialogZone.show();
        },

        onDialogZoneHide() {
            this.setSelectedZoneName(null);
            this.setSelectedZoneId(null);
        },

        setWeekAgoDates() {
            let now = new Date();
            let weekAgo = addToDate(now, { days: -7 });

            let from = dateISONormalize(weekAgo);
            let to = dateISONormalize(now);

            this.setPeriodDate({ from, to });

            this.setPeriodFrom(from);
            this.setPeriodTo(to);
        },

        projectSwitch(newId) {
            this.reset();

            this.setProjectId(newId);
            this.setProjectIdModal(newId);

            this.update();
        }
    }
};
</script>

<style lang="sass">
.LaborCostChart
    height: calc(100% - 16px)
    display: flex
    flex-direction: column
    max-width: 100%
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
    &-header
        padding: 0 10px
        margin-top: 10px
        display: flex
        justify-content: flex-end
        position: relative
        .PeriodDatepickerInput
            width: 250px
            @media only screen and (max-width : 900px)
                align-self: flex-end
            @media only screen and (max-width : 480px)
                width: 100%
        @media only screen and (max-width : 900px)
            flex-direction: column
    &-title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        text-align: center
        padding: 0 16px
        position: absolute
        left: 50%
        top: 50%
        transform: translate(-50%, -50%)
        @media only screen and (max-width : 900px)
            position: static
            transform: none
            margin-bottom: 10px
    &-chart
        flex-grow: 1
        display: flex
        flex-direction: column
        justify-content: center
        align-items: center
        position: relative
        .AmChartsStackedArea
            flex-grow: 1
</style>
