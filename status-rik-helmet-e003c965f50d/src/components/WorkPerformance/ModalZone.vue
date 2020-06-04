<template>
    <q-card class="ModalZone column full-height full-width ModalZone-card">
        <q-btn
            class="ModalZone-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
            :class="{ 'ModalZone-closeMobile': closeMobile }"
            icon="close"
            flat
            :dense="closeMobile"
            v-close-popup
        />

        <div class="ModalZone-content">
            <div class="ModalZone-content-left">
                <div class="ModalZone-content-left-top">
                    <div class="ModalZone-content-header">График</div>

                    <DataPreloader
                        class="DataPreloader"
                        :loading="loadingData"
                        :error="ModalZoneError"
                        :vertical="true"
                        :duration="100"
                    >
                        <AmCharts
                            class="AmCharts"
                            ref="AmCharts"
                            :minSize="chartMinSize"
                            :maxSize="chartMaxSize"
                            :percent="chartPercent"
                            :padding="[20, 5]"
                            :data="ModalZoneChartData"
                            :sort="AmChartsSort"
                            idKey="worker_id"
                            @selected="onChartSelected"
                        />
                    </DataPreloader>
                </div>
                <div class="ModalZone-content-left-bottom">
                    <div class="ModalZone-content-header">Расположение зоны на карте</div>
                    <ModalZoneMap class="ModalZoneMap" />
                </div>
            </div>
            <div class="ModalZone-content-right">
                <ModalZoneTable
                    class="ModalZoneTable sticky-header sticky-bottom compact table-blue-header table-blue-grid table-no-border-radius"
                    :tableTitle="tableTitle"
                    autoRowHeight
                    :minRowHeight="16"
                    @mouseEnter="onMouseEnter"
                    @mouseLeave="onMouseLeave"
                    @click="onClickTable"
                />
            </div>
        </div>

        <q-dialog
            class="WorkPerformance-modal"
            full-height
            full-width
            :maximized="$q.screen.sm || $q.screen.xs"
            @hide="onDialogHide"
            ref="dialogWorker"
        >
            <ModalWorker />
        </q-dialog>
    </q-card>
</template>

<script>
import { date } from 'quasar';

import ModalZoneTable from './ModalZoneTable.vue';
import AmCharts from '../common/amcharts/AmCharts.vue';
import ModalWorker from './ModalWorker.vue';
import ModalZoneMap from './ModalZoneMap.vue';
import DataPreloader from '../common/DataPreloader.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'ModalZone',
    components: {
        ModalZoneTable,
        AmCharts,
        ModalWorker,
        ModalZoneMap,
        DataPreloader
    },
    computed: {
        ...mapGetters('WorkPerformance', [
            'selectedZoneId',
            'selectedZoneName',
            'selectedWorkerId',
            'ModalZoneTableData',
            'ModalZoneChartData',
            'periodFrom',
            'periodTo',
            'projectId',
            'moduleErrors'
        ]),

        loadingData() {
            return this.ModalZoneChartData.length === 0;
        },

        tableTitle() {
            let fromTS = new Date(this.periodFrom);
            let toTS = new Date(this.periodTo);

            let fromFormat = date.formatDate(fromTS, 'DD/MM/YYYY');
            let toFormat = date.formatDate(toTS, 'DD/MM/YYYY');

            return `Анализ данных по зоне: "${this.selectedZoneName}" с ${fromFormat} по ${toFormat}`;
        },

        ModalZoneError() {
            return this.moduleErrors.requestWorkAnalyzeWorkCostObject !== undefined;
        },

        closeMobile() {
            return this.$q.screen.lt.md;
        }
    },
    data() {
        return {
            chartMinSize: 100,
            chartMaxSize: 400,
            chartPercent: 50
        };
    },
    created() {
        window.ModalZone = this;

        this.update();
    },
    beforeDestroy() {
        this.clearModalZoneTableData();
        this.setSelectedWorkerId(null);
    },
    methods: {
        ...mapMutations('WorkPerformance', ['clearModalZoneTableData', 'setSelectedWorkerId']),
        ...mapActions('WorkPerformance', ['requestWorkAnalyzeWorkCostObject']),

        AmChartsSort(a, b) {
            if (Number(a.value) > Number(b.value)) return 1;
            if (Number(a.value) == Number(b.value)) return 0;
            if (Number(a.value) < Number(b.value)) return -1;
        },

        onDialogHide() {
            this.$refs.AmCharts && this.$refs.AmCharts.clearSelected();
        },
        // Обработчик клика по сегменту графика
        onChartSelected(selectedData) {
            let { worker_id } = selectedData;

            this.openModal(worker_id);
        },
        // Обработчик клика по строке таблицы с работником
        onClickTable(props) {
            let { row } = props;
            this.openModal(row.worker_id);
        },
        onMouseEnter(props) {
            let { worker_id } = props.row;

            this.$refs.AmCharts && this.$refs.AmCharts.selectById(worker_id);
            this.$refs.AmCharts && this.$refs.AmCharts.activeById(worker_id);
        },
        onMouseLeave() {
            this.$refs.AmCharts && this.$refs.AmCharts.clearActive();

            if (this.$refs.dialogWorker.showing) return;
            this.$refs.AmCharts && this.$refs.AmCharts.clearSelected();
        },
        openModal(worker_id) {
            this.setSelectedWorkerId(worker_id);

            this.$refs.dialogWorker.show();
        },
        update() {
            this.requestWorkAnalyzeWorkCostObject();
        }
    }
};
</script>

<style lang="sass">
.ModalZone
    @media only screen and (max-width : 768px)
        height: auto !important
        min-height: 100vh !important
        display: flex
        flex-direction: column
        flex-grow: 1
    &-close
        position: absolute
        top: 0
        right: 0
        z-index: 10
        .q-btn__wrapper
            padding: 0px 12px
            min-height: 2.15em

    &-closeMobile
        position: fixed
        &.q-btn--dense
            .q-btn__wrapper
                padding: 0.285em
                min-height: 2em
    &-content
        display: flex
        height: 100%
        max-width: 100%
        @media screen and (max-width : 768px)
            flex-direction: column
            height: auto !important
            max-height: auto !important
            flex-grow: 1
        &-header
            width: 100%
            font-weight: 600
            font-size: 16px
            line-height: 18px
            text-align: center
            padding: 12px 0
        &-left
            width: 50%
            max-width: 50%
            flex-grow: 1
            height: 100%
            display: flex
            flex-direction: column
            justify-content: center
            align-items: stretch
            position: relative
            @media only screen and (max-width : 768px)
                display: block
                order: 1
                width: 100%
                max-width: 100%
                height: auto
            &-top
                width: 100%
                height: 50%
                min-height: 250px
                padding: 0 0 0 16px
                display: flex
                flex-direction: column
                position: relative
                @media only screen and (max-width : 768px)
                    padding: 0
                @media only screen and (max-width : 600px)
                    min-height: 220px
                @media only screen and (max-width : 500px)
                    min-height: 200px
                .AmCharts
                    flex-grow: 1
                    justify-self: center
            &-bottom
                width: 100%
                height: 50%
                min-height: 300px
                padding: 0 0 16px 16px
                display: flex
                flex-direction: column
                flex-grow: 1
                @media only screen and (max-width : 768px)
                    padding: 0
                .ModalZoneMap
                    display: flex
                    flex-direction: column
                    width: 100%
                    flex-grow: 1

        &-right
            width: 50%
            max-width: 50%
            flex-grow: 1
            display: flex
            flex-direction: column
            height: calc(100% - 16px)
            margin-bottom: 16px
            @media only screen and (max-width : 768px)
                width: 100%
                max-width: 100%
                min-height: 90vh
                height: auto
            .ModalZoneTable
                flex-grow: 1
                @media only screen and (max-width : 768px)
                    margin: 0
    .ModalZoneTable
        max-height: 100%
        height: 100%
        .q-table__top
            padding: 12px 16px
</style>
