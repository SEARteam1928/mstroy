<template>
    <!-- eslint-disable vue/no-use-v-if-with-v-for -->
    <div class="PerformanceAnalyzeZones" ref="container">
        <DataPreloader class="DataPreloader" :loading="loadingData" :error="error" :vertical="true" :duration="100" />
        <q-table
            table-class="PerformanceAnalyzeZones-table performance"
            :title="tableTitle"
            :data="tableData"
            :columns="columns"
            :pagination.sync="pagination"
            row-key="id"
            separator="cell"
            dense
            flat
            square
            hide-bottom
        >
            <template v-slot:body="props">
                <template>
                    <!-- Строка подзаголовка "Производительные" и "Непроизводительных" -->
                    <q-tr
                        :props="props"
                        :key="props.row.id"
                        :class="['table-row-section', `table-row-section-${props.row.section}`]"
                        v-if="props.row.section"
                    >
                        <td :colspan="props.cols.length">
                            {{ props.row.name }}
                        </td>
                    </q-tr>

                    <!-- Промежуточное "Итого", отдельно для Производительных и Непроизводительных и "Итого общее" -->
                    <!-- В именованных строках нужно пропускать вывод ячейки, содержащей поле rowName с именем строки -->
                    <q-tr
                        :props="props"
                        :key="props.row.id"
                        :class="['table-named-row', `table-row-${props.row.rowName}`]"
                        v-else-if="props.row.rowName"
                    >
                        <td
                            v-for="(value, name) in props.row"
                            :key="name"
                            :class="`text-${columnsAlign[name]}`"
                            :colspan="name === 'name' ? 2 : 1"
                            v-if="name !== 'rowName' && name !== 'id'"
                        >
                            {{ name === 'pay_amount' ? currencyFormat(value) : value }}
                        </td>
                    </q-tr>

                    <!-- Простые строки данных таблицы -->
                    <q-tr
                        class="cursor-pointer"
                        :props="props"
                        :key="props.row.id"
                        v-else
                        @click.native="onRowClick(props)"
                        @mouseenter.native="onMouseEnter(props)"
                        @mouseleave.native="onMouseLeave(props)"
                    >
                        <!-- Ячейка "'№ п/п" -->
                        <QTdCustom key="pp" :props="props">
                            {{ props.row.pp }}
                        </QTdCustom>

                        <!-- Ячейка "Наименование зоны" -->
                        <QTdCustom key="name" :props="props">
                            {{ props.row.name }}
                        </QTdCustom>

                        <!-- Ячейка "Получено с устройств, ч/ч" -->
                        <QTdCustom key="in_zone_hours" :props="props">
                            {{ props.row.in_zone_hours }}
                        </QTdCustom>

                        <!-- Ячейка "Процент распределения" -->
                        <QTdCustom key="percentages" :props="props">
                            {{ props.row.percentages }}
                        </QTdCustom>

                        <!-- Ячейка "Приведенное к табелю, ч/ч" -->
                        <QTdCustom key="hours_amount" :props="props">
                            {{ props.row.hours_amount }}
                        </QTdCustom>

                        <!-- Ячейка "Сумма, руб." -->
                        <QTdCustom key="pay_amount" :props="props">
                            {{ currencyFormat(props.row.pay_amount) }}
                        </QTdCustom>
                    </q-tr>
                </template>
            </template>
        </q-table>

        <q-resize-observer v-if="autoRowHeight" ref="observer" />
    </div>
</template>

<script>
import { uid } from 'quasar';
import { currencyFormat, ComputeRowHeight } from '../../services/utils';

import PerformanceAnalyzeZonesModel from './PerformanceAnalyzeZonesModel';
import QTdCustom from '../common/QTdCustom.vue';
import DataPreloader from '../common/DataPreloader.vue';

export default {
    name: 'PerformanceAnalyzeZones',
    props: {
        tableData: {
            type: Array,
            required: true,
            default: () => []
        },
        tableTitle: {
            type: String,
            required: true
        },
        autoRowHeight: {
            type: Boolean,
            required: false,
            default: false
        },
        minRowHeight: {
            type: Number,
            required: false,
            default: 18
        },
        maxRowHeight: {
            type: Number,
            required: false,
            default: Infinity
        },
        error: {
            type: Boolean,
            required: false
        }
    },
    components: {
        QTdCustom,
        DataPreloader
    },
    computed: {
        loadingData() {
            return this.tableData.length === 0;
        },

        columnsAlign() {
            let aligns = {};
            this.columns.forEach(({ name, align }) => {
                aligns[name] = align;
            });

            return aligns;
        }
    },
    watch: {
        tableData(newData) {
            if (!this.autoRowHeight) return;

            this.$nextTick(() => {
                this.computeRowHeight();
            });
        }
    },
    data() {
        return {
            columns: PerformanceAnalyzeZonesModel,
            uid,
            currencyFormat,
            computeRowHeight: () => {},
            pagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: Infinity
            }
        };
    },
    created() {
        window.PerformanceAnalyzeZones = this;
    },
    mounted() {
        if (this.autoRowHeight) {
            this.computeRowHeight = new ComputeRowHeight({
                container: this.$refs.container,
                observer: this.$refs.observer,
                minRowHeight: this.minRowHeight,
                maxRowHeight: this.maxRowHeight,
                throttle: 100
            });
        }
    },
    methods: {
        onMouseEnter(props) {
            this.$emit('mouseEnter', props);
        },
        onMouseLeave(props) {
            this.$emit('mouseLeave', props);
        },
        onRowClick(props) {
            this.$emit('rowClick', props);
        }
    }
};
</script>

<style lang="sass">
.PerformanceAnalyzeZones
    position: relative
    min-height: 200px
    .DataPreloader
        top: 70%
    .q-table__container:last-child
        border-radius: 0 0 4px 4px
    &-table
        &.performance
        &.not-performance
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

    // Строки, разделяющие секции таблицы
    .table-row-section
        text-decoration: underline
        text-align: center

    // Именованные строки
    .table-row-sub-total
        font-weight: 600
    .table-row-total
        font-weight: 600
        background-color: #e0e0e0

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
                    &:nth-of-type(5)
                        max-width: 65px
            @media only screen and (max-width : 375px)
                th
                    &:nth-of-type(3)
                       max-width: 60px
                    &:nth-of-type(4)
                       max-width: 60px
                    &:nth-of-type(5)
                       max-width: 60px
            @media only screen and (max-width : 360px)
                th
                    &:nth-of-type(4)
                       max-width: 40px
            @media only screen and (max-width : 320px)
                th
                    &:nth-of-type(2)
                       max-width: 60px
                    &:nth-of-type(3)
                       max-width: 40px
                    &:nth-of-type(5)
                       max-width: 40px
                    &:nth-of-type(6)
                       max-width: 50px
</style>
