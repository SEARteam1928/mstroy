<template>
    <div class="sessions-table-wrap col column no-wrap">
        
        <!-- Таблица трудозатрат -->
        <q-table class="sessions-table sticky column no-wrap"
            :data="sessionsData"
            :columns="columnsSessions"
            row-key="StartTime"
            :pagination.sync="sessionsPagination"
            :loading="sessionsIsLoading"
            dense
            flat
            selection="single"
            :selected.sync="selectedData"
            :filter="sessionsFilter"
            @request="onRequest"
            @selection="onSelect"
        >

            <template v-slot:body="props">
                <q-tr :props="props" :key="props.row.PP">
                    <!-- Ячейка "Чекбокс" -->
                    <td class="q-table--col-auto-width text-center">
                        <q-checkbox v-model="props.selected" dense/>
                    </td>

                    <!-- Ячейка -->
                    <QTdCustom key="StartTime" :props="props" @click="rowClickHandler">
                        <!-- {{ props.row.StartTime }} -->
                        {{  props.colsMap.StartTime.format && props.colsMap.StartTime.format(props.row.StartTime) || props.row.StartTime }}
                    </QTdCustom>

                    <!-- Ячейка -->
                    <QTdCustom key="EndTime" :props="props" @click="rowClickHandler">
                        <!-- {{ props.row.EndTime }} -->
                        {{  props.colsMap.EndTime.format && props.colsMap.EndTime.format(props.row.EndTime) || props.row.EndTime }}
                    </QTdCustom>

                    <!-- Ячейка -->
                    <QTdCustom key="Accepted" :props="props" @click="rowClickHandler">
                        {{ props.row.Accepted }}
                    </QTdCustom>

                    <!-- Ячейка -->
                    <QTdCustom key="Total" :props="props" @click="rowClickHandler">
                        {{ props.row.Total }}
                    </QTdCustom>
                </q-tr>
            </template>

        </q-table>

        <WorkerTimeAnalize 
            :accepted="acceptedTime"
            :total="totalTime"
        />

    </div>

</template>

<script>
import tableModelSessions from './tableModelSessions';
import tableDataSessions from './tableDataSessions';

import WorkerTimeAnalize from './WorkerTimeAnalize.vue';
import QTdCustom from '../common/QTdCustom.vue';


export default {
    name: 'WorkerTabTrack',
    components: {
        WorkerTimeAnalize,
        QTdCustom,
    },
    props: {
        id: {
            type: String,
            required: true
        }
    },
    computed: {
        acceptedTime() {
            return this.sessionsData.reduce((amount, session) => amount += session.Accepted, 0);
        },
        totalTime() {
            return this.sessionsData.length * this.fullSessionMinutes;
        }
    },
    data() {
        return {
            trackData: [],
            interval: 60,

            columnsSessions: tableModelSessions,
            sessionsData: [],
            sessionsPagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: 50,
                // rowsNumber: 5
            },
            sessionsIsLoading: false,
            sessionsFilter: '',
            selectedData: [],

            // Время смены в минутах
            fullSessionMinutes: 480,
        }
    },
    methods: {
        delay(timeout) {
            return new Promise(resolve => setTimeout(resolve, timeout));
        },
        async sessionsDataLoader() {
            this.sessionsIsLoading = true;

            // await this.delay(1000);
            this.sessionsData = tableDataSessions();

            this.sessionsIsLoading = false;
        },
        async onRequest(props) {
            console.log('Параметры запроса от таблицы:' , props);
        },
        async onSelect(details) {
            console.log('Параметры выбранных строк от таблицы:' , details);
        },
        rowClickHandler(props) {
            console.log('rowClickHandler props: ', props);
        },
    },
    created() {
        window.wtt = this;
        // this.requestWorkerTrackData();

        this.sessionsDataLoader();
    }
}
</script>

<style lang="sass" scoped>
.time-analizer-card
    // margin: 0 15px

.sessions-table
    flex-grow: 1
    height: 100%
    .q-table__middle
        height: 100%
    tbody
        tr
            &:nth-child(even)
                background-color: var(--q-color-custom-icon-bg)
            &:hover
                background-color: var(--q-color-menu-item-border)


.sessions-table-wrap
    height: 100%

</style>