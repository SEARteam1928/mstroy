<template>
    <div class="MonthTableHeader q-table__control">
        <MonthTableTableLegend class="MonthTableTableLegend" />

        <div class="q-table__title">{{ tableTitle }}</div>

        <PeriodDatepickerInput
            class="PeriodDatepickerInput"
            clearable
            dense
            align="top middle"
            panel="month"
            label="Выбор месяца"
            :mobileMode="$q.screen.width <= 480"
            :from="periodDate.from"
            :to="periodDate.to"
            @input="onDateInput"
            @reset="onDateReset"
        />
    </div>
</template>

<script>
import MonthTableTableLegend from './MonthTableTableLegend.vue';
import PeriodDatepickerInput from '../common/PeriodDatepickerInput.vue';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'MonthTableHeader',
    components: {
        MonthTableTableLegend,
        PeriodDatepickerInput
    },
    props: {
        tableTitle: {
            type: String,
            required: false,
            default: ''
        }
    },
    computed: {
        ...mapGetters('MonthTable', ['periodDate'])
    },
    methods: {
        ...mapMutations('MonthTable', ['setPeriodDate']),

        onDateInput(values) {
            this.setPeriodDate(values);
        },
        onDateReset() {
            this.setPeriodDate({ from: null, to: null });
        }
    }
};
</script>

<style lang="sass">
.MonthTableHeader
    display: flex
    justify-content: space-between
    text-align: center
    width: 100%
    position: relative
    @media only screen and (max-width : 900px)
        flex-wrap: wrap
    @media only screen and (max-width : 540px)
        justify-content: center
    .MonthTableTableLegend
        @media only screen and (max-width : 900px)
            order: 1
        @media only screen and (max-width : 680px)
            .MonthTableTableLegend-item
                max-width: 116px
        @media only screen and (max-width : 540px)
            order: 2
            width: 100%
            justify-content: space-between
            .MonthTableTableLegend-item
                margin-top: 6px
                margin-bottom: -4px
                max-width: none
    .q-table__title
        font-size: 16px
        line-height: 18px
        font-weight: 600
        width: 100%
        position: absolute
        @media only screen and (max-width : 1200px)
            position: static
            width: auto
        @media only screen and (max-width : 900px)
            order: 0
            width: 100%
            padding-bottom: 6px
    .PeriodDatepickerInput
        width: 250px
        @media only screen and (max-width : 900px)
            order: 2
        @media only screen and (max-width : 540px)
            width: 100%
            order: 1
</style>
