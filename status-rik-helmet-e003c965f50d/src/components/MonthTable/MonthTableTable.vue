<template>
    <div class="MonthTableTable">
        <DataPreloader
            vertical
            :loading="isLoading"
            :warning="noData"
            warningMessage="Нет данных за выбранный период"
            :info="noPeriod"
            infoMessage="Не выбран период"
            :error="hasError"
        >
            <q-table
                table-class="MonthTableTable-table"
                :data="tableData"
                :columns="tableModel"
                row-key="index"
                :pagination.sync="pagination"
                separator="cell"
                dense
                flat
                hide-bottom
                hide-top
            >
                <template v-slot:body-cell="props">
                    <MonthTableTableTdRender v-bind="props" />
                </template>
            </q-table>
        </DataPreloader>
    </div>
</template>

<script>
import DataPreloader from '../common/DataPreloader.vue';
import MonthTableTableTdRender from './MonthTableTableTdRender.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'MonthTableTable',
    components: {
        DataPreloader,
        MonthTableTableTdRender
    },
    computed: {
        ...mapGetters('MonthTable', ['tableModel', 'tableData', 'dataIsLoading', 'moduleErrors', 'periodDate']),

        isLoading() {
            return this.moduleErrors.requestReportsHoursComparing === undefined && this.dataIsLoading;
        },
        noData() {
            return (
                this.moduleErrors.requestReportsHoursComparing === undefined &&
                !this.noPeriod &&
                !this.dataIsLoading &&
                this.tableData.length === 0
            );
        },
        noPeriod() {
            return !this.periodDate.from || !this.periodDate.to;
        },
        hasError() {
            return this.moduleErrors.requestReportsHoursComparing !== undefined;
        }
    },
    data() {
        return {
            pagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: Infinity
            }
        };
    }
};
</script>

<style lang="sass">
.MonthTableTable
    position: relative
    overflow: hidden
    .q-table
        padding: 0
        @media only screen and (max-width : 1200px)
            padding: 0
    .q-table__top
        padding: 6px 16px
        border: none

    // Прилипающий к левому краю второй столбец (ФИО сотрудников)
    .q-table
        thead
            th
                &:nth-of-type(1)
                    border-left-width: 1px
                    border-left-style: solid
                &:nth-of-type(2)
                    position: sticky
                    left: 0
                    z-index: 3
                    border-right-width: 1px
                    border-right-style: solid
        tbody
            td
                &:nth-of-type(1)
                    border-left-width: 1px
                    border-left-style: solid
                &:nth-of-type(2)
                    position: sticky
                    left: 0
                    z-index: 2
                    background: #fff
                    border-right-width: 1px
                    border-right-style: solid
                &:nth-of-type(3)
                    border-left: none

    // Прилипающий к правому краю последний столбец (Итого чел/час)
    .q-table
        thead
            th:last-of-type
                position: sticky
                right: 0
                z-index: 3
                border-right-width: 1px
                border-right-style: solid
                padding: 4px 8px
        tbody
            td:last-of-type
                position: sticky
                right: 0
                z-index: 2
                background: #fff
                border-right-width: 1px
                border-right-style: solid
                padding: 4px 8px

    // Выделение цветом столбцов (№ п/п), (ФИО сотрудников) и (Итого чел/час)
    .q-table
        tbody
            td
                &:last-of-type,
                &:nth-of-type(1),
                &:nth-of-type(2)
                    background-color: rgb(217, 234, 242)

    // Нижний бордер на последней строке
    .q-table
        tbody
            tr:last-of-type
                td
                    border-bottom-width: 1px
                    border-bottom-style: solid

    // Оформление ячеек строки "Итого"
    .MonthTableTableTdRender-totalRowCell-pp,
    .MonthTableTableTdRender-totalRowCell-position,
    .MonthTableTableTdRender-totalRowCell-day
        background-color: rgb(217, 234, 242)
        position: sticky
        bottom: 0
        border-top-width: 1px
        border-top-style: solid
    .MonthTableTableTdRender-totalRowCell-title
        background-color: rgb(217, 234, 242)
        position: sticky
        left: 0
        bottom: 0
        border-top-width: 1px
        border-top-style: solid
        font-weight: bold
    .MonthTableTableTdRender-totalRowCell-total
        background-color: rgb(217, 234, 242)
        position: sticky
        right: 0
        bottom: 0
        border-top-width: 1px
        border-top-style: solid
</style>
