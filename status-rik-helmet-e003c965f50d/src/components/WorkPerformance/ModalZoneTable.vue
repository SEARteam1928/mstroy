<template>
    <!-- eslint-disable vue/no-use-v-if-with-v-for -->
    <div class="ModalZoneTable" ref="container">
        <DataPreloader
            class="DataPreloader"
            :loading="loadingData"
            :error="hasError"
            :vertical="true"
            :duration="100"
        />
        <q-table
            table-class="ModalZoneTable-table"
            :title="tableTitle"
            :data="dividedTableData"
            :columns="columns"
            row-key="date"
            :pagination.sync="pagination"
            separator="cell"
            dense
            flat
            square
            hide-bottom
        >
            <template v-slot:body="props">
                <q-tr
                    v-if="props.row.rowName"
                    :props="props"
                    :key="uid()"
                    :class="['table-named-row', `table-row-${props.row.rowName}`]"
                >
                    <td
                        v-for="(value, name) in props.row"
                        :key="name"
                        :class="`text-${columnsAlign[name]}`"
                        :colspan="name === 'worker' ? 2 : 1"
                        v-if="name !== 'rowName'"
                    >
                        {{ name === 'pay_amount' ? currencyFormat(value) : value }}
                    </td>
                </q-tr>

                <q-tr
                    v-else
                    :props="props"
                    :key="props.row.pp"
                    class="cursor-pointer"
                    @mouseenter.native="onMouseEnter(props)"
                    @mouseleave.native="onMouseLeave(props)"
                    @click.native="onClick(props)"
                >
                    <!-- Ячейка "'№ п/п" -->
                    <QTdCustom key="pp" :props="props">
                        {{ props.row.pp }}
                    </QTdCustom>

                    <!-- Ячейка "ФИО сотрудников" -->
                    <QTdCustom key="worker" :props="props">
                        {{ props.row.worker }}
                    </QTdCustom>

                    <!-- Ячейка "Данные с устройств, ч/ч" -->
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
        </q-table>

        <q-resize-observer v-if="autoRowHeight" ref="observer" />
    </div>
</template>

<script>
import { uid } from 'quasar';

import { currencyFormat, ComputeRowHeight } from '@services/utils';
import ModalZoneTableModel from './ModalZoneTableModel';

import QTdCustom from '../common/QTdCustom.vue';
import DataPreloader from '../common/DataPreloader.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'ModalZoneTable',
    components: {
        QTdCustom,
        DataPreloader
    },
    props: {
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
        }
    },
    computed: {
        ...mapGetters('WorkPerformance', ['ModalZoneTableData', 'moduleErrors']),

        loadingData() {
            return !this.ModalZoneTableData.work_hours || !this.ModalZoneTableData.work_hours.length;
        },
        columnsAlign() {
            let aligns = {};
            this.columns.forEach(({ name, align }) => {
                aligns[name] = align;
            });

            return aligns;
        },
        dividedTableData() {
            let result = [];

            if (this.loadingData) return result;

            this.ModalZoneTableData.work_hours.forEach(
                ({ worker, worker_id, in_zone_hours, percentages, hours_amount, pay_amount }, index) => {
                    result.push({
                        pp: index + 1,
                        worker,
                        worker_id,
                        in_zone_hours,
                        percentages: percentages + '%',
                        hours_amount,
                        pay_amount
                    });
                }
            );

            let totalRow = this.buildTotal(this.ModalZoneTableData.total);
            result.push(totalRow);

            return result;
        },

        hasError() {
            return this.moduleErrors.requestWorkAnalyzeWorkCostObject !== undefined;
        }
    },
    watch: {
        dividedTableData(newData) {
            if (!this.autoRowHeight) return;

            this.$nextTick(() => {
                this.computeRowHeight();
            });
        }
    },
    data() {
        return {
            columns: ModalZoneTableModel,
            pagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: Infinity
            },
            currencyFormat,
            uid,
            computeRowHeight: () => {}
        };
    },
    created() {
        window.ModalZoneTable = this;
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
        onClick(props) {
            this.$emit('click', props);
        },
        onMouseEnter(props) {
            this.$emit('mouseEnter', props);
        },
        onMouseLeave(props) {
            this.$emit('mouseLeave', props);
        },
        buildTotal(totalData) {
            let { in_zone_hours, percentages, hours_amount, pay_amount } = totalData;
            let total = {
                worker: 'Итого',
                in_zone_hours,
                percentages: percentages + '%',
                hours_amount,
                pay_amount,
                rowName: 'total'
            };

            return total;
        }
    }
};
</script>

<style lang="sass">
.ModalZoneTable
    position: relative
    margin: 0 16px
    .q-table
        border: 1px solid rgba(0,0,0,0.12);
        border-top-width: 0;
    .q-table__top
        .q-table__control
            text-align: center
            width: 100%
            margin: 0 40px
            .q-table__title
                width: 100%
                font-weight: 600
                font-size: 16px
                line-height: 18px
        @media only screen and (max-width : 768px)
            padding: 12px 0
            .q-table__control
                margin: 0 30px
                .q-table__title
                    font-size: 16px
                    line-height: 18px
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

    // Подгон ширины столбцов для телефонов
    .q-table
        thead
            @media only screen and (max-width : 414px)
                th
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(3)
                        max-width: 65px
                    &:nth-of-type(4)
                        max-width: 65px
                    &:nth-of-type(5)
                        max-width: 65px
                    &:nth-of-type(6)
                        max-width: 65px
            @media only screen and (max-width : 375px)
                th
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(3)
                       max-width: 60px
                    &:nth-of-type(4)
                       max-width: 40px
                    &:nth-of-type(5)
                       max-width: 60px
                    &:nth-of-type(6)
                       max-width: 60px
            @media only screen and (max-width : 360px)
                th
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(2)
                       max-width: 100px
                    &:nth-of-type(3)
                       max-width: 50px
                    &:nth-of-type(5)
                       max-width: 50px
                    &:nth-of-type(6)
                       max-width: 50px
            @media only screen and (max-width : 320px)
                th
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(3)
                       max-width: 40px
                    &:nth-of-type(5)
                       max-width: 40px
                    &:nth-of-type(6)
                       max-width: 40px
</style>
