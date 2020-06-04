<template>
    <q-page class="MonthTable-page page-background">
        <div class="MonthTable page-block">
            <MonthTableHeader class="MonthTableHeader" :tableTitle="tableTitle" />

            <MonthTableTable
                class="MonthTableTable table-blue-header table-blue-grid table-no-border-radius sticky-header table-header-center table-header-pre"
            />
        </div>
    </q-page>
</template>

<script>
import MonthTableHeader from '../components/MonthTable/MonthTableHeader.vue';
import MonthTableTable from '../components/MonthTable/MonthTableTable.vue';

import { dateISONormalize } from '@services/utils';
import { startOfMonth, endOfMonth } from '@services/utils/dateUtils';
import withModuleErrors from '@mixins/withModuleErrors';
import withProjectSwitch from '@mixins/withProjectSwitch';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'MonthTable',
    components: {
        MonthTableHeader,
        MonthTableTable
    },
    mixins: [withModuleErrors('MonthTable'), withProjectSwitch('MonthTable')],
    computed: {
        ...mapGetters('MonthTable', ['projectId', 'periodDate', 'currentMonth', 'currentYear']),

        tableTitle() {
            let title = 'Табель';
            if (this.currentMonth && this.currentYear) {
                title += ` за ${this.currentMonth} ${this.currentYear}`;
            }

            return title;
        }
    },
    watch: {
        periodDate: {
            handler() {
                this.requestReportsHoursComparing();
            },
            deep: true
        }
    },
    created() {
        let now = new Date();
        let from = dateISONormalize(startOfMonth(now));
        let to = dateISONormalize(endOfMonth(now));

        // Даты с первого по последнее число текущего месяца
        this.setPeriodDate({ from, to });

        // Изначальный запрос на загрузку данных будет инициализирован вызовом
        // projectSwitch из миксина withProjectSwitch
    },
    beforeDestroy() {
        this.clearPeriodDate();
        this.clearHoursData();
    },
    methods: {
        ...mapMutations('MonthTable', ['setProjectId', 'setPeriodDate', 'clearPeriodDate', 'clearHoursData']),
        ...mapActions('MonthTable', ['requestReportsHoursComparing']),

        projectSwitch(newId) {
            this.requestReportsHoursComparing();
        }
    }
};
</script>

<style lang="sass">
.MonthTable
    overflow: hidden
    height: calc( 100% - 16px )
    display: flex
    flex-direction: column
    max-width: calc( 100% - 16px )
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )

    .MonthTableHeader
        padding: 10px 16px
</style>
