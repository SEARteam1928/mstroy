<template>
    <q-page class="WorkPerformance-page page-background">
        <DataPreloader :loading="!hasTotalData" :error="totalError" :vertical="true">
            <div class="WorkPerformance page-block">
                <div class="WorkPerformance-left">
                    <PerformanceAnalyze
                        class="PerformanceAnalyze table-blue-header table-blue-grid table-no-border-radius sticky-header compact table-auto-row-height"
                        :style="'--row-height: 27px'"
                        :tableTitle="PerformanceAnalyzeTitle"
                    />
                </div>

                <div class="WorkPerformance-right">
                    <div class="WorkPerformance-right-top">
                        <PerformanceAnalyzeZones
                            class="PerformanceAnalyzeZones table-blue-header table-blue-grid table-no-border-radius sticky-header sticky-bottom compact"
                            :tableData="PerformanceAnalyzeZonesTableData"
                            :tableTitle="PerformanceAnalyzeZonesTitleMonth"
                            autoRowHeight
                            :minRowHeight="minRowHeight"
                            :maxRowHeight="maxRowHeight"
                            :error="PerformanceAnalyzeZonesError"
                            @rowClick="PerformanceAnalyzeZonesCellClicked"
                            @mouseEnter="PerformanceAnalyzeZonesCellMouseenter"
                            @mouseLeave="PerformanceAnalyzeZonesCellMouseleave"
                        />
                    </div>

                    <div class="WorkPerformance-right-bottom">
                        <PerformanceKPI
                            class="PerformanceKPI table-no-border-radius table-blue-header table-blue-grid"
                            :tableData="PerformanceKPIData"
                            :tableTitle="PerformanceKPITitle"
                            :error="PerformanceKPIError"
                        />

                        <div class="AmCharts">
                            <DataPreloader
                                class="DataPreloader"
                                :loading="!hasPerformanceChartData"
                                :error="PerformanceAnalyzeZonesError"
                                :vertical="true"
                                :duration="100"
                            >
                                <AmCharts
                                    ref="AmCharts"
                                    :minSize="minChartSize"
                                    :percent="75"
                                    :padding="[15, 0]"
                                    :data="PerformanceChartData"
                                    :sort="AmChartsSort"
                                    idKey="object_id"
                                    @selected="onChartSelected"
                                />
                            </DataPreloader>
                        </div>
                    </div>
                </div>
            </div>
        </DataPreloader>

        <q-dialog
            class="WorkPerformance-modal"
            full-height
            full-width
            :maximized="$q.screen.sm || $q.screen.xs"
            @hide="onDialogHide"
            ref="dialogZone"
        >
            <ModalZone />
        </q-dialog>
    </q-page>
</template>

<script>
import { date } from 'quasar';

import PerformanceAnalyze from '../components/WorkPerformance/PerformanceAnalyze.vue';
import PerformanceAnalyzeZones from '../components/WorkPerformance/PerformanceAnalyzeZones.vue';
import PerformanceKPI from '../components/WorkPerformance/PerformanceKPI.vue';
import AmCharts from '../components/common/amcharts/AmCharts.vue';
import ModalZone from '../components/WorkPerformance/ModalZone.vue';
import DataPreloader from '../components/common/DataPreloader.vue';

import { dateISONormalize } from '@services/utils';
import withProjectSwitch from '@mixins/withProjectSwitch';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'WorkPerformance',
    components: {
        PerformanceAnalyze,
        PerformanceAnalyzeZones,
        PerformanceKPI,
        AmCharts,
        ModalZone,
        DataPreloader
    },
    mixins: [withProjectSwitch('MonthTable')],
    data() {
        return {
            PerformanceAnalyzeTitle: 'Трудозатраты по различным источникам',
            PerformanceAnalyzeZonesTitle: 'Анализ трудозатрат по зонам производства работ',
            PerformanceKPITitle: 'Целевые KPI, устанавливаемые линейному персоналу',
            maxRowHeight: 30
        };
    },
    watch: {
        moduleErrors(newErrors, oldErrors) {
            // При разработке будут всплывать уведомления с ошибками
            if (process.env.DEV) {
                // Для нахождения свежей ошибки в объекте ошибок
                let newCopyErrors = { ...newErrors };
                Object.keys(oldErrors).forEach(err => delete newCopyErrors[err]);

                // Если ошибки нет, значит watch сработал на очистку одной из прошлых ошибок
                if (!Object.keys(newCopyErrors).length) return;

                console.log('WorkPerformance Error: ', newCopyErrors);
                let [type, error] = Object.entries(newCopyErrors)[0];
                this.$q.notify({
                    icon: 'close',
                    color: 'btn_red',
                    message: `[ ${type} ]: ${String(error)}`
                });
            }
        },

        selectedMonth: {
            handler(newMonth) {
                this.$nextTick(() => {
                    let { from_date, to_date } = this.selectedPeriod;
                    this.setPeriodFrom(from_date);
                    this.setPeriodTo(to_date);

                    // Если нет данных для таблицы PerformanceAnalyzeZones за выбранные месяц, подгружаем их
                    if (!this.PerformanceAnalyzeZonesData[newMonth]) {
                        this.requestWorkAnalyzeWorkCost();
                    }
                });
            },
            immediate: true
        }
    },
    computed: {
        ...mapGetters('WorkPerformance', [
            'projectId',
            'PerformanceChartData',
            'PerformanceAnalyzeTotalData',
            'PerformanceAnalyzeZonesData',
            'PerformanceKPIData',
            'moduleErrors',
            'selectedMonth',
            'selectedPeriod'
        ]),

        hasPerformanceChartData() {
            return this.PerformanceChartData.length > 0;
        },

        minChartSize() {
            let size = 100;
            if (this.$q.screen.width < 600) size = 75;

            return size;
        },

        minRowHeight() {
            let height = 22;
            if (this.$q.screen.lt.sm) {
                height = this.maxRowHeight;
            }

            return height;
        },

        PerformanceAnalyzeZonesTableData() {
            let result = [];

            let data = this.PerformanceAnalyzeZonesData[this.selectedMonth];
            if (data) result = data;

            return result;
        },
        PerformanceAnalyzeZonesTitleMonth() {
            let tableTitle = this.PerformanceAnalyzeZonesTitle;
            let month = this.selectedMonth;
            if (this.selectedMonth) {
                tableTitle = `${tableTitle} за ${this.selectedMonth}`;
            }

            return tableTitle;
        },

        hasTotalData() {
            return this.PerformanceAnalyzeTotalData.length > 0;
        },
        totalError() {
            return this.moduleErrors.requestWorkAnalyzeTotalData !== undefined;
        },

        PerformanceKPIError() {
            return (
                this.moduleErrors.requestWorkAnalyzeComparing !== undefined ||
                this.moduleErrors.requestWorkAnalyzeWorkCost !== undefined
            );
        },
        PerformanceAnalyzeZonesError() {
            return this.moduleErrors.requestWorkAnalyzeWorkCost !== undefined;
        }
    },
    created() {
        window.WorkPerformance = this;

        // Изначальный запрос на загрузку данных будет инициализирован вызовом
        // projectSwitch из миксина withProjectSwitch
    },
    beforeDestroy() {
        this.clearStore();
    },
    methods: {
        ...mapActions('WorkPerformance', [
            'requestWorkAnalyzeTotalData',
            'requestWorkAnalyzeWorkCost',
            'requestWorkZones',
            'clearStore'
        ]),
        ...mapMutations('WorkPerformance', [
            'setPeriodFrom',
            'setPeriodTo',
            'setProjectId',
            'setSelectedZoneId',
            'setSelectedZoneName'
        ]),

        AmChartsSort(a, b) {
            if (Number(a.value) > Number(b.value)) return 1;
            if (Number(a.value) == Number(b.value)) return 0;
            if (Number(a.value) < Number(b.value)) return -1;
        },

        PerformanceAnalyzeZonesCellMouseenter(props) {
            let { object_id } = props.row;
            this.$refs.AmCharts && this.$refs.AmCharts.selectById(object_id);
            this.$refs.AmCharts && this.$refs.AmCharts.activeById(object_id);
        },
        PerformanceAnalyzeZonesCellMouseleave() {
            this.$refs.AmCharts && this.$refs.AmCharts.clearActive();

            if (this.$refs.dialogZone.showing) return;
            this.$refs.AmCharts && this.$refs.AmCharts.clearSelected();
        },
        // Обработчик клика по сегменту графика
        onChartSelected(selectedData) {
            let { name, object_id } = selectedData;

            this.openModal(name, object_id);
        },
        onDialogHide() {
            this.$refs.AmCharts && this.$refs.AmCharts.clearSelected();
        },
        // Обработчик клика по строке таблицы PerformanceAnalyzeZones
        PerformanceAnalyzeZonesCellClicked(props) {
            let { name, object_id } = props.row;
            object_id = object_id === null ? -1 : object_id;

            this.openModal(name, object_id);
        },
        // Принимает имя зоны и ее id и открывает модалку с компонентом ModalZone
        openModal(name, object_id) {
            this.setSelectedZoneName(name);
            this.setSelectedZoneId(object_id);

            this.$refs.dialogZone.show();
        },
        update() {
            // Получает список из строк "Итого" по месяцам для таблицы "Трудозатраты по различным источникам
            this.requestWorkAnalyzeTotalData();
            // Получает данные о рабочих зонах на карте
            this.requestWorkZones();
        },

        // FIXME: Очищать данные таблиц при переключении проектов + обработать ситуацию,
        // когда в ответ приходит пустой массив, крутится бесконечный прелоадер
        projectSwitch(newId) {
            this.clearStore();
            this.update();
        }
    }
};
</script>

<style lang="sass">
.WorkPerformance
    height: calc(100% - 16px)
    display: flex
    justify-content: space-between
    max-width: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    // padding: 8px
    @media only screen and (max-width : 600px)
        margin:
            top: 0
            right: 0
            bottom: 16px
            left: 0
        max-width: 100%
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        position: relative
        @media only screen and (max-width : 1300px)
            height: auto
    .table-title
        width: 100%
        font-size: 16px
        font-weight: 600
        padding: 12px 16px
        text-align: center
    .q-table
        border: 1px solid rgba(0,0,0,0.12);
        border-top-width: 0;
    .WorkPerformance-left
        display: flex
        flex-direction: column
        // padding-bottom: 16px
        width: 50%
        @media only screen and (max-width : 1300px)
            height: 50vh
            max-height: 50vh
        @media only screen and (max-width : 600px)
            padding-top: 16px
    .WorkPerformance-right
        height: 100%
        flex-grow: 1
        display: flex
        flex-direction: column
        // padding-bottom: 16px
        margin-left: 8px
        width: calc(50% - 8px)
        &-top
            height: 40%
            flex-grow: 1
            display: flex
            flex-direction: column
            @media only screen and (max-width : 600px)
                padding-top: 16px
        &-bottom
            height: 60%
            flex-grow: 1
            display: flex
            flex-direction: column
            @media only screen and (max-width : 600px)
                padding-top: 16px
    @media only screen and (max-width : 1600px)
        .WorkPerformance-left
            width: 42%
        th
            font-size: 11px
    @media only screen and (max-width : 1300px)
        flex-direction: column
        .WorkPerformance-left, .WorkPerformance-right
            width: 100%
            max-width: 100%
            padding-bottom: 0
    @media only screen and (max-width : 768px)
        .WorkPerformance-left, .WorkPerformance-right
            width: 100%


    .PerformanceAnalyze
        height: 100%
        flex-grow: 1
        overflow: auto
        display: flex
        flex-direction: column

    .PerformanceAnalyzeZones
        max-width: calc(100% - 2px)
        overflow: hidden
        @media only screen and (max-width : 1300px)
            max-width: 100%

    .PerformanceKPI
        margin-top: 8px

    .AmCharts
        position: relative
        margin-top: 8px
        @media only screen and (max-width : 1300px)
            min-height: 250px
        @media only screen and (max-width : 600px)
            min-height: 150px
</style>
