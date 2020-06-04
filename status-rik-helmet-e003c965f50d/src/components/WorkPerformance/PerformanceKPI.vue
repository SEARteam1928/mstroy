<template>
    <div class="PerformanceKPI">
        <DataPreloader
            class="DataPreloader"
            :loading="loadingData"
            :error="error"
            :vertical="true"
            :duration="100"
            :size="32"
        />
        <q-table
            table-class="PerformanceKPI-table"
            :title="tableTitle"
            :data="tableData"
            :columns="columns"
            row-key="name"
            separator="cell"
            dense
            flat
            hide-bottom
            @request="onRequest"
        >
            <template v-slot:body="props">
                <q-tr :props="props" :key="props.row.name">
                    <!-- Ячейка "Наименование" -->
                    <QTdCustom key="name" :props="props">
                        {{ props.row.name }}
                    </QTdCustom>

                    <!-- Ячейка "Факт" -->
                    <QTdCustom key="fact" :props="props">
                        {{ props.row.fact }}
                    </QTdCustom>

                    <!-- Ячейка "Целевой показатель" -->
                    <QTdCustom key="target" :props="props">
                        {{ props.row.target }}
                    </QTdCustom>
                </q-tr>
            </template>
        </q-table>
    </div>
</template>

<script>
import PerformanceKPIModel from './PerformanceKPIModel';
import QTdCustom from '../common/QTdCustom.vue';
import DataPreloader from '../common/DataPreloader.vue';

export default {
    name: 'PerformanceKPI',
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
        }
    },
    data() {
        return {
            columns: PerformanceKPIModel
        };
    },
    created() {
        window.PerformanceKPI = this;
    },
    methods: {
        async onRequest(props) {
            console.log('Параметры запроса от PerformanceKPI:', props);
        }
    }
};
</script>

<style lang="sass">
.PerformanceKPI
    position: relative
    min-height: 114px
    .DataPreloader
        bottom: -30px
        top: auto
    .q-table__top
        .q-table__control
            text-align: center
            width: 100%
            .q-table__title
                width: 100%
                font-size: 16px
                line-height: 18px
                font-weight: 600
    th
        white-space: pre-wrap
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

    // Подгон ширины столбцов для телефонов
    .q-table
        thead
            @media only screen and (max-width : 360px)
                th
                    text-align: center
                    text-overflow: ellipsis
                    overflow: hidden
                    &:nth-of-type(2)
                       max-width: 40px
                    &:nth-of-type(3)
                       max-width: 60px
            @media only screen and (max-width : 360px)
                th
                    &:nth-of-type(3)
                       max-width: 40px
    .q-table--dense .q-table th,
    .q-table--dense .q-table td
        padding: 0 4px
</style>
