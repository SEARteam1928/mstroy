<template>
    <div class="PeriodDatepicker">
        <DateRangePicker
            class="mj-daterange-picker"
            :from="from"
            :to="to"
            :begin="begin"
            :allowFrom="allowFrom"
            :allowTo="allowTo"
            :past="past"
            :future="future"
            :panel="panel"
            :showControls="showControls"
            :yearsCount="yearsCount"
            :resetTitle="resetTitle"
            :submitTitle="submitTitle"
            :theme="theme"
            :panels="panels"
            :presets="presets"
            :locale="locale"
            @update="onUpdatePeriod"
            @select="onSelectPeriod"
            @reset="onResetPeriod"
            @selectDay="onSelectDay"
            ref="DateRangePicker"
        />
    </div>
</template>

<script>
import DateRangePicker from './DateRangePicker.vue';

export default {
    name: 'PeriodDatepicker',
    components: {
        DateRangePicker
    },
    props: {
        from: {
            type: [String, Date],
            required: false
        },
        to: {
            type: [String, Date],
            required: false
        },
        panel: {
            type: String,
            required: false,
            default: 'day'
        },
        past: {
            type: Boolean,
            required: false,
            default: true
        },
        future: {
            type: Boolean,
            required: false,
            default: true
        },
        showControls: {
            type: Boolean,
            required: false,
            default: true
        },
        yearsCount: {
            type: Number,
            required: false,
            default: 2
        },
        resetTitle: {
            type: String,
            required: false
        },
        submitTitle: {
            type: String,
            required: false
        },
        begin: {
            type: String,
            required: false
        },
        allowFrom: {
            type: String,
            required: false
        },
        allowTo: {
            type: String,
            required: false
        },
        theme: {
            type: Object,
            required: false
        }
    },
    watch: {
        panel(newPanel) {
            this.$refs.DateRangePicker.currentPanel = newPanel;
        }
    },
    data() {
        return {
            locale: 'ru',
            panels: [],
            presets: []
        };
    },
    created() {
        window.PeriodDatepicker = this;
    },
    methods: {
        selectDay(date) {
            this.$refs.DateRangePicker.selectDay(new Date(date));
        },
        reset() {
            this.$refs.DateRangePicker && this.$refs.DateRangePicker.reset();
        },
        onUpdatePeriod(values) {
            this.$emit('update', values);
        },
        onSelectPeriod(values) {
            this.$emit('select', values);
        },
        onResetPeriod(values) {
            this.$emit('reset', values);
        },
        onSelectDay(values) {
            this.$emit('selectDay', values);
        }
    }
};
</script>

<style lang="sass">
.PeriodDatepicker
    border-radius: 4px
    max-width: 280px
    .mj-daterange-picker
        display: flex
        flex-direction: column
        min-width: auto
        width: 250px
        min-height: 342px
        .mj-daterange-picker-controls
            padding: 10px 0
            .mj-daterange-picker-button
                min-width: auto
                flex-grow: 1
                margin: 0 10px
        .mj-calendar
            flex-grow: 1
            // Режим выбора дней
            .calendar-days
                .day
                    height: 32px
            // Режим выбора месяцев
            .calendar-months
                .month
                    height: auto
                    padding: 5px
            // Режим выбора кварталов
            .calendar-quarters
                .quarter
                    display: flex
                    justify-content: center
                    .legend
                        display: none
                    .months
                        padding: 0 10px
                        width: 100%
                        .month
                            &:nth-child(1)
                                text-align: left
                            &:nth-child(2)
                                text-align: center
                            &:nth-child(3)
                                text-align: right
</style>
