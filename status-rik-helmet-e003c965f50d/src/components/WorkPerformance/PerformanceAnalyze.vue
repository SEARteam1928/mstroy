<template>
    <!-- eslint-disable vue/no-use-v-if-with-v-for -->
    <div class="PerformanceAnalyze" ref="container">
        <DataPreloader
            class="DataPreloader"
            :loading="loadingData"
            :error="hasError"
            :vertical="true"
            :duration="100"
        />
        <q-table
            table-class="PerformanceAnalyze-table"
            :title="tableTitle"
            :data="PerformanceAnalyzeTotalData"
            :columns="columns"
            row-key="day"
            :pagination.sync="pagination"
            separator="cell"
            dense
            flat
            hide-bottom
            :expanded.sync="expanded"
        >
            <template v-slot:body="props">
                <q-tr
                    v-if="props.row.rowName"
                    :key="props.row.day"
                    :props="props"
                    :class="{
                        'table-named-row': true,
                        [`table-row-${props.row.rowName}`]: true,
                        'table-row-expandable': true,
                        'table-row-expanded': props.expand,
                        'table-row-expanded-loading': props.expand && !props.row.daysData.length
                    }"
                    @click.native="setExpanded(props.row.day)"
                >
                    <!-- columnFilter определяет какие из полей объекта нужно отрисовывать в таблице -->
                    <td
                        v-for="(value, name) in props.row"
                        :key="name"
                        :class="`text-${columnsAlign[name]}`"
                        v-if="columnFilter(name)"
                    >
                        <q-icon
                            v-if="name === 'day' && !(props.expand && !props.row.daysData.length)"
                            class="table-expand-icon"
                            name="arrow_drop_down"
                        />

                        <!-- Показывается во время загрузки данных по дням -->
                        <q-spinner
                            v-if="name === 'day' && props.expand && !props.row.daysData.length"
                            class="table-expand-spinner"
                        />
                        {{ value }}
                    </td>
                </q-tr>

                <tr v-if="props.expand" v-for="row in props.row.daysData" :key="row.day + props.row.day">
                    <td :class="[`text-${columnsAlign.day}`, 'cell-day']">{{ row.day }}</td>
                    <td :class="`text-${columnsAlign.spider_hours}`">{{ row.spider_hours }}</td>
                    <td :class="`text-${columnsAlign.excel_hours}`">{{ row.excel_hours }}</td>
                    <td :class="`text-${columnsAlign.total_hours}`">{{ row.total_hours }}</td>
                    <td :class="`text-${columnsAlign.effective_percentage}`">{{ row.effective_percentage }}</td>
                </tr>
            </template>
        </q-table>
    </div>
</template>

<script>
import PerformanceAnalyzeModel from './PerformanceAnalyzeModel';

import DataPreloader from '../common/DataPreloader.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'PerformanceAnalyze',
    components: {
        DataPreloader
    },
    props: {
        tableTitle: {
            type: String,
            required: true
        }
    },
    computed: {
        ...mapGetters('WorkPerformance', [
            'selectedMonth',
            'PerformanceAnalyzeTotalData',
            'PerformanceAnalyzeTotalDataMap',
            'moduleErrors'
        ]),

        // Показывает загружены ли начальные данные списка строк по месяцам
        loadingData() {
            return this.PerformanceAnalyzeTotalData.length === 0;
        },
        columnsAlign() {
            let aligns = {};
            this.columns.forEach(({ name, align }) => {
                aligns[name] = align;
            });

            return aligns;
        },

        hasError() {
            return this.moduleErrors.requestWorkAnalyzeComparing !== undefined;
        }
    },
    watch: {
        // Когда только загрузился список строк по месяцам, разворачивает строку с последним (текущим) месяцем
        // и вызывает загрузку данных по дням за этот месяц
        PerformanceAnalyzeTotalData(newData, oldData) {
            if (newData.length && !oldData.length) {
                // let lastMonth = newData[newData.length - 1];
                // this.setExpanded(lastMonth.day);

                this.expandLastMonth();
            }
        },

        // Когда изменяется выбранный месяц, проверяет загружены ли уже данные по дням за этот месяц.
        // Если еще не загружены, загружает их
        selectedMonth(newMonth, oldMonth) {
            if (!newMonth || newMonth === oldMonth) return;

            this.$nextTick(() => {
                if (!this.isLoadedDaysData(newMonth)) {
                    this.requestWorkAnalyzeComparing();
                }
            });
        }
    },
    data() {
        return {
            columns: PerformanceAnalyzeModel,
            expanded: [],
            pagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: Infinity
            }
        };
    },
    created() {
        window.PerformanceAnalyze = this;

        this.expandLastMonth();
    },
    methods: {
        ...mapActions('WorkPerformance', ['requestWorkAnalyzeComparing']),
        ...mapMutations('WorkPerformance', ['setSelectedMonth', 'clearSelectedMonth']),

        // Позволяет проверять, загружены ли данные по дням для передаваемого месяца
        isLoadedDaysData(selectedMonth) {
            let result = false;

            let totalDataIndex = this.PerformanceAnalyzeTotalDataMap[selectedMonth];
            let daysData = this.PerformanceAnalyzeTotalData[totalDataIndex].daysData;
            result = daysData.length > 0;

            return result;
        },
        columnFilter(name) {
            let showColumn = new Set([
                'pp',
                'day',
                'spider_hours',
                'excel_hours',
                'total_hours',
                'effective_percentage'
            ]);

            return showColumn.has(name);
        },
        setExpanded(selectedMonth) {
            if (this.expanded[0] !== selectedMonth) {
                this.expanded = [selectedMonth];
                this.setSelectedMonth(selectedMonth);
            }
        },
        expandLastMonth() {
            if (!this.PerformanceAnalyzeTotalData.length) return;

            let lastMonth = this.PerformanceAnalyzeTotalData[this.PerformanceAnalyzeTotalData.length - 1];
            this.setExpanded(lastMonth.day);
        }
    }
};
</script>

<style lang="sass">
.PerformanceAnalyze
    position: relative
    .q-table__top
        padding: 6px 16px
        .q-table__control
            text-align: center
            width: 100%
            .q-table__title
                width: 100%
                font-size: 16px
                line-height: 18px
                font-weight: 600
    th
        white-space: pre
        text-align: center
        font-weight: 600
        &.sortable
            &.sorted
                // Колонка отсортирована по возрастанию
                &.sort-desc
                    // Колонка отсортирована по убыванию
            .q-table__sort-icon
                // TODO: оформить стилями состояние сортировки столбцов
                // без использования иконок стрелок
                display: none
    .table-row-total
        font-weight: 600
        background-color: #e0e0e0

    .q-table__middle
        height: 100%
        .q-table
            // height: 100%
            tbody
                height: 100%
                width: 100%
                position: relative

    .q-table
        tr
            td.cell-day
                padding-left: 22px !important

    // Подгон ширины столбцов для телефонов
    .q-table
        thead
            @media only screen and (max-width : 414px)
                th
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(2)
                       max-width: 65px
                    &:nth-of-type(3)
                       max-width: 65px
                    &:nth-of-type(4)
                       max-width: 65px
            @media only screen and (max-width : 375px)
                th
                    &:nth-of-type(2)
                       max-width: 60px
                    &:nth-of-type(3)
                       max-width: 60px
                    &:nth-of-type(4)
                       max-width: 60px
                    &:nth-of-type(5)
                       max-width: 60px
            @media only screen and (max-width : 320px)
                th
                    &:nth-of-type(2)
                       max-width: 45px
                    &:nth-of-type(3)
                       max-width: 45px
                    &:nth-of-type(4)
                       max-width: 45px
</style>
