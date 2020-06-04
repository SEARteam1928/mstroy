<template>
    <q-page>
        <div class="workers-container">
            <div class="workers-content">
                <!-- row-key="Code" - Имя столбца, который отображает уникальные данные -->
                <!-- :dense="$q.screen.lt.md" - маленькие паддинги на средних экранах -->
                <!-- @selection="onSelect" - событие при выборе строки -->
                <q-table class="workers-table"
                    :title="tableTitle"
                    :data="workersData"
                    :columns="columns"
                    row-key="Code"
                    :visible-columns="visibleColumns"
                    :pagination.sync="pagination"
                    :loading="loadingData"
                    dense
                    flat
                    selection="multiple"
                    :selected.sync="selectedData"
                    :filter="filter"
                    @request="onRequest"
                    @selection="onSelect"
                >
                    <template v-slot:top="props">
                        <div class="col">
                            <div class="row">
                                <h5 class="table-title">{{tableTitle}}</h5>
                                
                                <q-space />

                                
                            </div>
                            <div class="row">
                                <div class="workers-action-group">
                                    <!-- size="sm" ставить на 360- -->
                                    <q-btn class="workers-action-btn" label="Фильтр"
                                        color="custom-icon-bg" 
                                        text-color="ms_black"
                                        :dense="$q.screen.xs"
                                        @click="showRowSearchHandler" 
                                    />
                                    <q-btn class="workers-action-btn text-ms_black" label="Новый"
                                        color="custom-icon-bg" 
                                        text-color="ms_black"
                                        :dense="$q.screen.xs"
                                    />
                                    <q-btn class="workers-action-btn" label="Редактировать"
                                        :outline="!canRowEdit"
                                        :disable="!canRowEdit"
                                        color="custom-icon-bg" 
                                        text-color="ms_black"
                                        :dense="$q.screen.xs"
                                    />
                                    <q-btn class="workers-action-btn" label="Удалить"
                                        :outline="!canRowDelete"
                                        :disable="!canRowDelete"
                                        color="custom-icon-bg" 
                                        text-color="ms_black"
                                        :dense="$q.screen.xs"
                                    />
                                </div>

                            </div>

                            <div class="row-filter-wrap">
                                <q-slide-transition :duration="300">
                                    <div class="row row-filter" v-show="showRowSearch">

                                        <q-input class="workers-filter"
                                            placeholder="Поиск по таблице" 
                                            outlined 
                                            dense 
                                            debounce="300" 
                                            clearable
                                            clear-icon="close"
                                            v-model="filter" 
                                        >
                                            <template v-slot:prepend>
                                                <QIconCustom dense name="filter" :colors="{primary: 'custom-icon-primary'}"/>
                                            </template>
                                        </q-input>

                                        <q-space v-if="!$q.screen.xs"/>

                                        <q-select class="column-select"
                                            v-model="visibleColumns"
                                            multiple
                                            dense
                                            :display-value="$q.lang.table.columns"
                                            emit-value
                                            map-options
                                            :options="columns"
                                            option-value="name" />
                                    </div>
                                </q-slide-transition>                                
                            </div>
                        </div>
                    
                    </template>

                    <template v-slot:body="props">
                        <q-tr :props="props" :key="props.row.Code">
                            <!-- Ячейка "Чекбокс" -->
                            <td class="q-table--col-auto-width">
                                <q-checkbox v-model="props.selected" dense/>
                            </td>

                            <!-- Ячейка "Фамилия" -->
                            <QTdCustom key="LN" :props="props"  @click="rowClickHandler">
                                {{ props.row.LN }}
                            </QTdCustom>

                            <!-- Ячейка "Имя" -->
                            <QTdCustom key="FN" :props="props" @click="rowClickHandler">
                                {{ props.row.FN }}
                            </QTdCustom>

                            <!-- Ячейка Отчество -->
                            <QTdCustom key="FthN" :props="props" @click="rowClickHandler">
                                {{ props.row.FthN }}
                            </QTdCustom>

                            <!-- Ячейка Код -->
                            <QTdCustom key="Code" :props="props" @click="rowClickHandler">
                                {{ props.row.Code }}
                            </QTdCustom>

                            <!-- Ячейка Дата рождения -->
                            <QTdCustom key="BD" :props="props" @click="rowClickHandler">
                                {{ props.row.BD }}
                            </QTdCustom>

                            <!-- Ячейка Подразделение -->
                            <QTdCustom key="CSD" :props="props" @click="rowClickHandler">
                                {{ props.row.CSD }}
                            </QTdCustom>

                            <!-- Ячейка Должность -->
                            <QTdCustom key="CP" :props="props" @click="rowClickHandler">
                                {{ props.row.CP }}
                            </QTdCustom>
                        </q-tr>
                    </template>

                </q-table>

                <!-- :maximized="$q.platform.is.mobile" -->
                <q-dialog class="worker-content-dialog"
                    v-model="workerContentActiveData"
                    full-height
                    full-width
                    :maximized="$q.screen.sm || $q.screen.xs"
                    @hide="dialogHideHandler"
                    ref="workerContentDialog"
                >
                    <!-- <WorkerPage :props="openedWorker" v-if="openedWorker"/> -->
                    <router-view></router-view>
                </q-dialog>

            </div> <!-- .workers-content -->
        </div>
    </q-page>
</template>

<script>
import _workersData from '../components/Workers/workersData';
import tableModel from '../components/Workers/tableModel';

import QTdCustom from '../components/common/QTdCustom.vue';
import QIconCustom from '../components/common/QIconCustom.vue';
import WorkerPage from './WorkerPage.vue';

export default {
    name: 'Workers',
    meta() {
        return {
            title: this.currentTitle,
        }
    },
    components: {
        QTdCustom,
        QIconCustom,
        WorkerPage,
    },
    data() {
        return {
            tableTitle: 'Сотрудники',
            visibleColumns: ['LN', 'FN', 'FthN', 'Code', 'BD', 'CSD', 'CP'],
            loadingData: false,
            pagination: {
                sortBy: '',
                descending: false,
                page: 1,
                rowsPerPage: 50,
                // rowsNumber: 5
            },
            columns: tableModel,

            workersData: [],
            selectedData: [],
            filter: '',
            showRowSearch: false,

            // Флаг отображения диалога просмотра сотрудника
            workerContentActiveData: false,

            // Сюда будет попадать объект строки таблицы, по которой кликнули чтобы посмотреть сотрудника
            openedWorker: undefined,
        }
    },
    computed: {
        routeParams() {
            return this.$route.params;
        },
        id() {
            return this.$route.params.id;
        },
        currentTitle() {
            return (this.id && this.openedWorker) ? this.titleTemplate(`${this.openedWorker.row.LN} ${this.openedWorker.row.FN}`) : this.titleTemplate('Сотрудники');
            // if(this.openedWorker) return this.titleTemplate(this.openedWorker);
        },
        canRowEdit() {
            return this.selectedData.length === 1;
        },
        canRowDelete() {
            return this.selectedData.length > 0;
        },

        workerContentActive() {
            if(!this.id) {
                this.workerContentActiveData = false;
                return false;
            }

            let active = false;
            let matched = this.$router.matcher.match(this.$route).matched;
            for (let index = 0; index < matched.length; index++) {
                if(matched[index].name === 'worker') {
                    active = true;
                    break;
                }
            }
            // console.log('workerContentActiveData: ', `${this.workerContentActiveData} -> `, active);

            this.workerContentActiveData = active;
            return active;
        }
    },
    methods: {
        titleTemplate: title => `${title} - BIM-портал`,

        dialogHideHandler(e) {
            // Когда срабатывает событие закрытия диалога, возвращаем роутер в состояние страницы с таблицей Сотрудников
            if(e) {
                this.$router.push({name: 'workers'});
                this.openedWorker = undefined;
                requestAnimationFrame(() => this.workerContentActiveData = this.workerContentActive)

            // TODO: непонятно почему, но часто при открытии дилога возникает событие hide,
            // на которе срабатывает обработчик и диалог тут же закрывается. 
            // При ложных вызовах аргумент e, где должно быть событие - undefined.
            // Поэтому в таких случаях поддерживаем флагом диалог открытым.
            // UPD: вообще не понятна логика срабатывания события hide и попадания в него объекта события e.
            // При нажатии кнопки "Назад" в браузере, открывалось пустое окно диалога, потому что срабатывал hide без объекта события
            // Поэтому добавил проверку на наличие id сотрудника в роутере
            } else if(!e && this.id) {
                this.workerContentActiveData = true;
            } else {
                this.workerContentActiveData = false;
            }
            
        },
        delay(timeout) {
            return new Promise(resolve => setTimeout(resolve, timeout));
        },
        async workersDataLoader() {
            this.loadingData = true;

            await this.delay(1000);

            this.workersData = _workersData;
            this.loadingData = false;
        },
        async onRequest(props) {
            console.log('Параметры запроса от таблицы:' , props);
        },
        async onSelect(details) {
            console.log('Параметры выбранных строк от таблицы:' , details);
        },
        showRowSearchHandler() {
            this.showRowSearch = !this.showRowSearch;
            if(!this.showRowSearch) this.filter = '';
        },

        // Обработчик клика по строке сотрудника, вызывает переход на роут сотрудника и открытие диалога с ним
        rowClickHandler(props) {
            console.log('rowClickHandler props: ', props);
            this.openedWorker = props;

            this.$router.push({name: 'worker', params: {id: props.key}});
            requestAnimationFrame(() => this.workerContentActiveData = this.workerContentActive)
        },

    },
    created() {
        window.wrks = this;

        this.workersDataLoader();

        // При создании компонента проверим, не загрузилась ли страница таблицы с роутом сотрудника
        this.workerContentActiveData = this.workerContentActive;
    },
    mounted() {
        this.onRequest({
            pagination: this.pagination,
            filter: undefined
        })
    }
}
</script>

<style lang="sass" scoped>
.workers-container
    position: absolute
    overflow: auto
    width: 100%
    height: 100%
    left: 0
    top: 0

.workers-content
    // padding: 15px
    // height: 150vh

.workers-table
    tbody
        tr
            &:nth-child(even)
                background-color: var(--q-color-custom-icon-bg)
            &:hover
                background-color: var(--q-color-menu-item-border)


.table-title
    margin: 15px 0

.column-select
    min-width: 300px
    @media only screen and (max-width : 768px)
        min-width: 250px

.workers-action-group
    width: 100%
    display: flex
    @media only screen and (max-width : 359px)
        // justify-content: centers

.workers-action-btn
    margin: 3px
    &:first-of-type
        margin-left: 0
    &:last-of-type
        margin-right: 0
    @media only screen and (max-width : 599px)
        font-size: 12px
    @media only screen and (max-width : 359px)
        font-size: 10px

.row-filter
    @media only screen and (max-width : 599px)
        justify-content: flex-end
    &-wrap
        margin-top: 12px

.workers-filter
    width: 290px
    @media only screen and (max-width : 599px)
        width: 100%

</style>