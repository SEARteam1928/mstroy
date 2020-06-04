<template>
    <div class="mj-daterange-picker" :style="cssProps" :class="{ 'with-controls': showControls }">
        <div class="panels-choices" v-if="availablePanels.length > 1">
            <div
                class="panel-button"
                v-for="panel in availablePanels"
                :key="panel"
                :class="{ 'is-current': panel === currentPanel }"
                @click="currentPanel = panel"
            >
                {{ legends[locale].panels[panel] }}
            </div>
        </div>

        <div class="preset-ranges" v-if="isPresetPicker && presets.length > 1">
            <div class="preset" v-for="entry in availablePresets" :key="entry" @click="selectPreset(entry)">
                <input type="radio" v-model="preset" :value="entry" />
                <label :for="entry">
                    <span class="check"></span>
                    <span>{{ legends[locale].presets[entry] }}</span>
                </label>
            </div>
        </div>

        <!-- isDaysPicker -->
        <div class="mj-calendar" :class="weekSelector ? 'mj-calendar-week' : 'mj-calendar-days'" v-if="isDaysPicker">
            <div class="calendar-header">
                <div
                    class="calendar-previous-month calendar-arrow calendar-arrow-previous"
                    :aria-label="legends[locale].previousMonth"
                    @click="changeMonth(1)"
                >
                    <!-- arrow-left -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="7.4" height="12">
                        <path d="M7.766 1.658L3.008 6.094l4.437 4.758-1.448 1.35L.21 5.997 6.416.21z" />
                    </svg>
                </div>
                <div class="calendar-month-name">{{ currentMonthName }}</div>
                <div
                    class="calendar-previous-month calendar-arrow calendar-arrow-next"
                    :aria-label="legends[locale].nextMonth"
                    @click="changeMonth(-1)"
                >
                    <!-- arrow-right -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="8" height="13">
                        <path d="M.048 1.658l4.758 4.436L.37 10.852l1.448 1.35 5.787-6.205L1.4.21z" />
                    </svg>
                </div>
            </div>

            <div class="calendar-days-name">
                <div class="day" v-for="day in firstWeek" :key="day.name">
                    <span>{{ day.name }}</span>
                </div>
            </div>

            <!-- calendar-days -->
            <div class="calendar-days">
                <div
                    class="day"
                    v-for="day in monthDays"
                    :key="day.date | date('DDMMYYYY')"
                    :class="dayClasses(day)"
                    @click="selectDay(day.date)"
                    @mouseover="hoverizeDay(day.date)"
                    @mouseleave="hoverRange = []"
                >
                    <span>{{ day.date | date('D') }}</span>
                </div>
            </div>
        </div>

        <!-- isMonthsPicker -->
        <div class="mj-calendar" v-if="isMonthsPicker">
            <div class="calendar-header">
                <div
                    class="calendar-previous-month calendar-arrow calendar-arrow-previous"
                    :aria-label="legends[locale].previousYear"
                    @click="changeYear(1)"
                >
                    <!-- arrow-left -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="7.4" height="12">
                        <path d="M7.766 1.658L3.008 6.094l4.437 4.758-1.448 1.35L.21 5.997 6.416.21z" />
                    </svg>
                </div>
                <div class="calendar-month-name">{{ currentYearName }}</div>
                <div
                    class="calendar-previous-month calendar-arrow calendar-arrow-next"
                    :aria-label="legends[locale].nextYear"
                    @click="changeYear(-1)"
                >
                    <!-- arrow-right -->
                    <svg xmlns="http://www.w3.org/2000/svg" width="8" height="13">
                        <path d="M.048 1.658l4.758 4.436L.37 10.852l1.448 1.35 5.787-6.205L1.4.21z" />
                    </svg>
                </div>
            </div>

            <!-- calendar-months -->
            <div class="calendar-months" v-if="isMonthsPanel">
                <div
                    class="month"
                    v-for="month in yearMonths"
                    :key="month.date | date('DDMMYYYY')"
                    @click="selectMonth(month)"
                    :class="monthClasses(month)"
                >
                    <span>{{ month.displayDate }}</span>
                </div>
            </div>

            <!-- calendar-quarters -->
            <div class="calendar-quarters" v-if="isQuartersPanel">
                <div
                    class="quarter"
                    v-for="(quarter, index) in yearQuarters"
                    :key="index"
                    @click="selectQuarter(quarter)"
                    :class="quarterClasses(quarter)"
                >
                    <div class="legend">{{ legends[locale].quarter }} {{ ++index }}</div>
                    <div class="months">
                        <div class="month" v-for="month in quarter.months" :key="month.displayDate">
                            <span>{{ month.displayDate }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- isYearPicker -->
        <div class="mj-calendar" v-if="isYearPicker">
            <!-- calendar-years -->
            <div class="calendar-years">
                <div
                    class="year"
                    v-for="year in years"
                    :key="year.displayDate"
                    @click="selectYear(year)"
                    :class="yearClasses(year)"
                >
                    <span>{{ year.displayDate }}</span>
                </div>
            </div>
        </div>

        <!-- showControls -->
        <div class="mj-daterange-picker-controls" v-if="showControls">
            <div class="mj-daterange-picker-button mj-daterange-picker-reset" @click="reset">{{ resetLegend }}</div>

            <div
                class="mj-daterange-picker-button mj-daterange-picker-submit"
                :class="{ 'is-disabled': !values.from }"
                @click="update"
            >
                {{ submitLegend }}
            </div>
        </div>
    </div>
</template>

<script>
import {
    addDays,
    subDays,
    addMonths,
    subMonths,
    addWeeks,
    subWeeks,
    addYears,
    subYears,
    differenceInDays,
    endOfDay,
    startOfDay,
    endOfMonth,
    startOfMonth,
    endOfWeek,
    startOfWeek,
    endOfYear,
    startOfYear,
    format,
    isAfter,
    isBefore,
    isSameDay,
    isSameMonth,
    isValid,
    isWithinRange,
    parse
} from '@services/utils/dateUtils';

let legends = {
    ru: {
        reset: 'Сбросить',
        submit: 'Применить',
        previousMonth: 'Предыдущий месяц',
        nextMonth: 'Следующий месяц',
        previousYear: 'Предыдущий год',
        nextYear: 'Следующий год',
        quarter: 'Квартал',
        panels: {
            range: 'Период',
            week: 'Неделя',
            month: 'Месяц',
            quarter: 'Квартал',
            year: 'Год'
        },
        presets: {
            custom: 'Пользовательский диапазон',
            forever: 'С начала',
            last7days: 'Последние 7 дней',
            last30days: 'Последние 30 дней',
            last90days: 'Последние 90 дней',
            last365days: 'Последние 365 дней',
            next365days: 'Следующие 365 дней',
            next90days: 'Следующие 90 дней',
            next30days: 'Следующие 30 дней',
            next7days: 'Следующие 7 дней',
            today: 'Сегодня',
            tomorrow: 'Завтра',
            yesterday: 'Вчера'
        }
    }
};

export default {
    name: 'DateRangePicker',
    filters: {
        date(date, _format, opts) {
            if (!date) return '';

            return format(date, _format, opts);
        }
    },
    props: {
        locale: {
            type: String,
            default: 'ru'
        },
        from: {
            type: [String, Date],
            default: null
        },
        to: {
            type: [String, Date],
            default: null
        },
        begin: {
            type: String,
            default: null
        },
        allowFrom: {
            type: String,
            default: null
        },
        allowTo: {
            type: String,
            default: null
        },
        past: {
            type: Boolean,
            default: true
        },
        future: {
            type: Boolean,
            default: true
        },
        showControls: {
            type: Boolean,
            default: false
        },
        panel: {
            type: String,
            default: null
        },
        yearsCount: {
            type: Number,
            default: 2
        },
        panels: {
            type: Array,
            default: () => ['range', 'week', 'month', 'quarter', 'year']
        },
        theme: {
            type: Object,
            default: () => {
                return {
                    primary: '#4774E8',
                    secondary: '#132B4D',
                    ternary: '#6C83A1',
                    border: '#e6e6e6',
                    light: '#ffffff',
                    dark: '#000000',
                    hovers: {
                        day: '#6C83A1',
                        range: '#4774E8'
                    }
                };
            }
        },
        width: {
            type: String,
            default: 'auto'
        },
        resetTitle: {
            type: String,
            default: null
        },
        submitTitle: {
            type: String,
            default: null
        },
        presets: {
            type: Array,
            default: () => [
                'today',
                'yesterday',
                'last7days',
                'last30days',
                'last90days',
                'last365days',
                'forever',
                'custom'
            ]
        }
    },
    data() {
        return {
            legends,
            currentPanel: null,
            current: null,
            weekSelector: false,
            daySelector: false,
            monthDays: [],
            now: new Date().toISOString(),
            values: {
                from: null,
                to: null
            },
            hoverRange: [],
            preset: 'custom'
        };
    },
    watch: {
        currentPanel: {
            handler(panel) {
                this.switchMode(panel);
            },
            immediate: true
        },
        values: {
            handler(values) {
                this.emitValuesWithSelect(values);
            },
            deep: true
        },
        preset: {
            handler(preset) {
                this.affectPreset(preset);
            }
        }
    },
    computed: {
        availablePanels() {
            return this.panels;
        },
        availablePresets() {
            const index = this.presets.indexOf('forever');
            if (!this.begin && index > -1) {
                this.presets.splice(index, 1);
            }
            return this.presets;
        },
        resetLegend() {
            return this.resetTitle ? this.resetTitle : this.legends[this.locale].reset;
        },
        submitLegend() {
            return this.submitTitle ? this.submitTitle : this.legends[this.locale].submit;
        },
        firstWeek() {
            const days = this.monthDays.slice(0, 7);
            const week = [];
            for (const day of days) {
                week.push({
                    name: format(day.date, 'dd')
                });
            }
            return week;
        },
        cssProps() {
            return {
                '--default-width': this.width,
                '--primary-color': this.theme.primary,
                '--hover-day-color': this.theme.hovers.day,
                '--hover-range-color': this.theme.hovers.range,
                '--secondary-color': this.theme.secondary,
                '--ternary-color': this.theme.ternary,
                '--normal-color': this.theme.light,
                '--contrast-color': this.theme.dark,
                '--border-color': this.theme.border
            };
        },
        yearMonths() {
            const months = [];
            let month = startOfYear(this.current);
            while (months.length !== 12) {
                const isMonthAllowed = this.isRangeAllowed([startOfMonth(month), endOfMonth(month)]);

                months.push({
                    date: month,
                    selectable: isMonthAllowed,
                    displayDate: format(month, 'MMMM')
                });
                month = addMonths(month, 1);
            }
            return months;
        },
        yearQuarters() {
            const quarters = [];
            for (const [index, month] of this.yearMonths.entries()) {
                if (index % 3 === 0) {
                    const isQuarterAllowed = this.isRangeAllowed([
                        startOfMonth(this.yearMonths[index].date),
                        endOfMonth(this.yearMonths[index + 2].date)
                    ]);

                    quarters.push({
                        months: [this.yearMonths[index], this.yearMonths[index + 1], this.yearMonths[index + 2]],
                        selectable: isQuarterAllowed,
                        range: {
                            start: startOfDay(startOfMonth(this.yearMonths[index].date)),
                            end: endOfDay(endOfMonth(this.yearMonths[index + 2].date))
                        }
                    });
                }
            }
            return quarters;
        },
        years() {
            const years = [];
            let i = this.yearsCount;
            let start = this.future ? addYears(this.now, this.yearsCount) : this.now;

            i = +this.future * this.yearsCount + +this.past * this.yearsCount + 1;

            while (i !== 0) {
                const isYearAllowed = this.isRangeAllowed([startOfYear(start), endOfYear(start)]);

                years.push({
                    date: start,
                    selectable: isYearAllowed,
                    displayDate: format(start, 'YYYY')
                });
                start = subYears(start, 1);
                i = i - 1;
            }

            return years;
        },
        currentMonthName() {
            return format(this.current, 'MMMM YYYY');
        },
        currentYearName() {
            return format(this.current, 'YYYY');
        },
        isPresetPicker() {
            return this.currentPanel === 'range';
        },
        isDaysPicker() {
            return this.currentPanel === 'range' || this.currentPanel === 'week' || this.currentPanel === 'day';
        },
        isMonthsPicker() {
            return this.currentPanel === 'month' || this.currentPanel === 'quarter';
        },
        isYearPicker() {
            return this.currentPanel === 'year';
        },
        isMonthsPanel() {
            return this.currentPanel === 'month';
        },
        isQuartersPanel() {
            return this.currentPanel === 'quarter';
        }
    },
    created() {
        window.DateRangePicker = this;

        // Parse Inputs
        Object.keys(this.values).forEach(value => {
            this.values[value] = isValid(parse(this[value])) ? this[value] : null;
        });

        // Todo ? If from or to is null, or from is after to, both are null

        // Display current month or "to" month
        this.current = this.values.to ? this.values.to : this.now;

        // Update Calendar
        this.updateCalendar();

        // Set current panel
        this.currentPanel = this.panel || this.availablePanels[0];
    },
    methods: {
        switchMode(panel) {
            this.weekSelector = panel === 'week' ? true : false;
            this.daySelector = panel === 'day' ? true : false;
            this.updateCalendar();
            this.$emit('update:panel', panel);
        },

        emitValuesWithSelect(values) {
            if (values.from && values.to) {
                this.$emit('select', {
                    to: format(endOfDay(this.values.to), 'YYYY-MM-DDTHH:mm:ss.SSSZ'),
                    from: format(startOfDay(this.values.from), 'YYYY-MM-DDTHH:mm:ss.SSSZ'),
                    panel: this.currentPanel
                });
            }
        },

        emitSelectDay(date) {
            this.$emit('selectDay', {
                date: format(date, 'YYYY-MM-DDTHH:mm:ss.SSSZ'),
                panel: this.currentPanel
            });
        },

        affectPreset(preset) {
            this.current = this.now;
            this.updateCalendar();

            switch (preset) {
                case 'custom':
                    this.values = { from: null, to: null };
                    break;
                case 'today':
                    this.values = { from: startOfDay(this.now), to: this.now };
                    break;
                case 'yesterday':
                    this.values = {
                        from: startOfDay(subDays(this.now, 1)),
                        to: endOfDay(subDays(this.now, 1))
                    };
                    break;
                case 'tomorrow':
                    this.values = {
                        from: startOfDay(addDays(this.now, 1)),
                        to: endOfDay(addDays(this.now, 1))
                    };
                    break;
                case 'last7days':
                    this.values = { from: startOfDay(subWeeks(this.now, 1)), to: this.now };
                    break;
                case 'next7days':
                    this.values = { to: startOfDay(addWeeks(this.now, 1)), from: this.now };
                    break;
                case 'last30days':
                    this.values = { from: startOfDay(subMonths(this.now, 1)), to: this.now };
                    break;
                case 'next30days':
                    this.values = { to: startOfDay(addMonths(this.now, 1)), from: this.now };
                    break;
                case 'last90days':
                    this.values = { from: startOfDay(subMonths(this.now, 3)), to: this.now };
                    break;
                case 'next90days':
                    this.values = { to: startOfDay(addMonths(this.now, 3)), from: this.now };
                    break;
                case 'last365days':
                    this.values = { from: startOfDay(subYears(this.now, 1)), to: this.now };
                    break;
                case 'next365days':
                    this.values = { to: startOfDay(addYears(this.now, 1)), from: this.now };
                    break;
                case 'forever':
                    this.values = { from: this.begin, to: this.now };
                    break;
            }
        },

        reset() {
            this.values = {
                to: null,
                from: null
            };
            this.preset = 'custom';
            this.$emit('reset', { to: null, from: null });
        },
        update() {
            if (!this.values.from) return;

            this.$emit('update', {
                from: format(startOfDay(this.values.from)),
                to: this.values.to ? format(startOfDay(this.values.to), 'YYYY-MM-DDTHH:mm:ss.SSSZ') : '',
                panel: this.currentPanel
            });
        },

        changeMonth(diff) {
            this.current = subMonths(this.current, diff);
            this.updateCalendar();
        },
        changeYear(diff) {
            this.current = subYears(this.current, diff);
            this.updateCalendar();
        },

        selectPreset(preset) {
            this.preset = preset;
        },
        selectDay(date) {
            this.emitSelectDay(date);

            if (this.weekSelector) {
                const range = this.getAllowedDatesOfRange([
                    startOfWeek(date, { weekStartsOn: 1 }),
                    endOfWeek(date, { weekStartsOn: 1 })
                ]);

                this.values.from = range[0];
                this.values.to = range[range.length - 1];
                return;
            }

            if (this.daySelector) {
                this.values.from = startOfDay(date);
                this.values.to = startOfDay(date);
                return;
            }

            if ((this.values.from && this.values.to) || (!this.values.from && !this.values.to)) {
                this.values.from = date;
                this.values.to = null;
            } else if (this.values.from && !this.values.to) {
                if (isBefore(date, this.values.from)) {
                    this.values.to = this.values.from;
                    this.values.from = date;
                } else {
                    this.values.to = date;
                    this.hoverRange = [];
                }
            }
            this.preset = 'custom';
        },
        selectQuarter(quarter) {
            this.values.from = startOfDay(startOfMonth(quarter.range.start));
            this.values.to = endOfMonth(quarter.range.end);
            this.current = this.values.to;
        },
        selectMonth(month) {
            this.values.from = startOfMonth(month.date);
            this.values.to = endOfMonth(month.date);
            this.current = this.values.to;
        },
        selectYear(year) {
            this.values.from = startOfYear(year.date);
            this.values.to = endOfYear(year.date);
            this.current = this.values.to;
        },

        hoverizeDay(date) {
            if (!this.weekSelector && !(this.values.from && !this.values.to)) {
                this.hoverRange = [];
                return;
            }

            if (this.weekSelector) {
                this.hoverRange = [startOfWeek(date, { weekStartsOn: 1 }), endOfWeek(date, { weekStartsOn: 1 })];
            } else if (isBefore(date, this.values.from)) {
                this.hoverRange = [date, this.values.from];
            } else {
                this.hoverRange = [this.values.from, date];
            }
        },

        updateCalendar() {
            const days = [];

            const lastDayOfMonth = endOfMonth(this.current);
            const firstDayOfMonth = startOfMonth(this.current);

            // -1 нужен для того, чтобы первым днем недели был понедельник
            let nbDaysLastMonth = (+format(firstDayOfMonth, 'd') - 1) % 7;

            // Из-за -1 выше, первый день месяца, если он приходится на воскресенье,
            // может не отображаться в составе календаря на этот месяц,
            // поэтому нужно добавить в календарь еще одну неделю, которая захватывается началом месяца
            nbDaysLastMonth = nbDaysLastMonth >= 0 ? nbDaysLastMonth : 7 + nbDaysLastMonth;

            let day = subDays(firstDayOfMonth, nbDaysLastMonth);

            while (isBefore(day, lastDayOfMonth) || days.length % 7 > 0) {
                const isAllowedByFutureAndPast =
                    this.future && isAfter(day, this.now)
                        ? true
                        : false || (this.past && isBefore(day, this.now))
                        ? true
                        : false || isSameDay(day, this.now);
                const isAllowedByAllowedProps = this.isDateAllowed(day);
                days.push({
                    date: day,
                    selectable: isAllowedByFutureAndPast && isAllowedByAllowedProps,
                    currentMonth: isSameMonth(this.current, day)
                });
                day = addDays(day, 1);
            }
            this.monthDays = days;
        },

        dayClasses(day) {
            const classes = [];

            if (day.currentMonth) {
                classes.push('is-current-month');
            }
            if (this.values.from && this.values.to && isWithinRange(day.date, this.values.from, this.values.to)) {
                classes.push('is-selected');
            }
            if (!day.selectable) {
                classes.push('is-disabled');
            }
            if (isSameDay(day.date, this.now)) {
                classes.push('is-today');
            }
            if (
                (!this.values.to && isSameDay(day.date, this.values.from)) ||
                (this.values.to &&
                    !this.values.from &&
                    isSameDay(day.date, this.values.from) &&
                    isSameDay(day.date, this.values.to)) ||
                (this.values.to && this.values.from && isSameDay(day.date, this.values.from))
            ) {
                classes.push('is-first-range');
                classes.push('is-edge-range');
            }
            if (this.values.to && isSameDay(day.date, this.values.to)) {
                classes.push('is-last-range');
                classes.push('is-edge-range');
            }

            if (this.hoverRange.length === 2 && isWithinRange(day.date, this.hoverRange[0], this.hoverRange[1])) {
                classes.push('is-in-range');
            }
            return classes;
        },
        monthClasses(month) {
            const classes = [];
            if (!month.selectable) {
                classes.push('is-disabled');
            }
            if (this.values.to && this.values.from && isWithinRange(month.date, this.values.from, this.values.to)) {
                classes.push('is-selected');
            }
            return classes;
        },
        quarterClasses(quarter) {
            const classes = [];
            if (!quarter.selectable) {
                classes.push('is-disabled');
            }
            if (
                this.values.to &&
                this.values.from &&
                isWithinRange(quarter.range.start, this.values.from, this.values.to) &&
                isWithinRange(quarter.range.end, this.values.from, this.values.to)
            ) {
                classes.push('is-selected');
            }
            return classes;
        },
        yearClasses(year) {
            const classes = [];
            if (!year.selectable) {
                classes.push('is-disabled');
            }
            if (this.values.to && this.values.from) {
                if (
                    isSameDay(this.values.from, startOfYear(year.date)) &&
                    isSameDay(this.values.to, endOfYear(year.date))
                ) {
                    classes.push('is-selected');
                }
            }
            return classes;
        },

        isDateAllowed(date) {
            let isAllowed = true;

            if (this.allowFrom) {
                isAllowed = isAllowed && !isBefore(date, parse(this.allowFrom));
            }

            if (this.allowTo) {
                isAllowed = isAllowed && !isAfter(date, parse(this.allowTo));
            }

            return isAllowed;
        },

        isRangeAllowed([from, to]) {
            return this.isDateAllowed(from) && this.isDateAllowed(to);
        },

        getAllowedDatesOfRange([from, to]) {
            const distance = differenceInDays(to, from);

            return new Array(distance + 1)
                .fill(null)
                .map((_, index) => addDays(from, index))
                .filter(this.isDateAllowed);
        }
    }
};
</script>

<style lang="scss">
.mj-daterange-picker {
    text-align: left;
    min-width: 400px;
    width: var(--default-width);
    user-select: none;
    border: 1px solid var(--border-color);
    border-radius: 4px;

    & * {
        box-sizing: border-box;
    }
}

.mj-daterange-picker .panels-choices {
    display: grid;
    grid-gap: 10px 10px;
    grid-template-columns: 1fr 1fr 1fr 1fr 1fr;
    border-bottom: 1px solid var(--border-color);
    padding: 20px;

    .panel-button {
        font-size: 12px;
        font-weight: bold;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: 32px;
        padding: 5px 15px;
        border-radius: 4px;
        cursor: pointer;
        background-color: #f2f4f5;

        &.is-current,
        &:hover {
            background-color: var(--primary-color);
            color: white;
        }
    }
}

.mj-daterange-picker .preset-ranges {
    padding: 20px;
    display: flex;
    flex-wrap: wrap;
    border-bottom: 1px solid var(--border-color);

    .preset {
        width: 50%;
        font-size: 13px;
        height: 20px;
        cursor: pointer;
        position: relative;
        margin: 5px 0;

        input {
            position: absolute;
            opacity: 0;
            height: 0;
            width: 0;

            &:checked ~ label .check {
                background-color: var(--primary-color);

                &::after {
                    background-color: transparent;
                }
            }
        }

        label {
            display: inline-flex;
            align-items: center;

            span + span {
                margin-left: 10px;
            }

            .check {
                display: block;
                position: relative;
                height: 20px;
                width: 20px;
                background-color: var(--secondary-color);
                border-radius: 10px;

                &::after {
                    content: '';
                    position: absolute;
                    height: 10px;
                    width: 10px;
                    left: 50%;
                    top: 50%;
                    background-color: white;
                    border-radius: 100%;
                    border: 3px solid white;
                    transform: translateX(-50%) translateY(-50%);
                }
            }
        }

        * {
            cursor: pointer;
        }
    }
}

.mj-daterange-picker {
    &.with-controls {
        .mj-calendar {
            padding-bottom: 10px;
        }
    }
}

.mj-calendar {
    color: var(--contrast-color);
    background-color: var(--normal-color);
    padding: 20px;

    .calendar-header {
        display: flex;
        justify-content: space-between;
        align-items: center;

        .calendar-month-name {
            flex: 1;
            text-align: center;
            color: var(--secondary-color);
            font-weight: bold;
            font-size: 14px;
        }

        .calendar-arrow {
            fill: var(--secondary-color);
            cursor: pointer;
        }
    }

    .calendar-months {
        margin-top: 40px;
        display: grid;
        grid-gap: 12px 6px;
        grid-template-columns: 1fr 1fr 1fr;

        .month {
            height: 50px;
            padding: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 13px;

            &:hover {
                background-color: var(--hover-range-color);
            }

            &.is-disabled {
                cursor: not-allowed;
                opacity: 0.5;
                pointer-events: none;
            }

            &.is-selected {
                background-color: var(--primary-color);
                color: white;
            }

            &:not(.is-disabled) {
                cursor: pointer;
            }
        }
    }

    .calendar-quarters {
        margin-top: 20px;

        .quarter {
            display: grid;
            grid-gap: 10px 10px;
            grid-template-columns: 1fr 3fr;
            margin: 10px 0;
            align-items: center;
            font-size: 13px;

            .months {
                display: grid;
                grid-gap: 10px 10px;
                align-items: center;
                grid-template-columns: 1fr 1fr 1fr;
                border: 1px solid var(--border-color);
                border-radius: 4px;
                height: 50px;
                padding: 10px 30px;

                &:hover {
                    background-color: var(--hover-range-color);
                }

                .month {
                    text-align: center;
                }
            }

            &.is-selected .months {
                background-color: var(--primary-color);
                color: white;
            }

            &.is-disabled .months {
                opacity: 0.5;
            }

            &.is-disabled {
                cursor: not-allowed;
                pointer-events: none;
            }

            &:not(.is-disabled) .months {
                cursor: pointer;
            }
        }
    }

    .calendar-years {
        .year {
            height: 50px;
            padding: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 13px;
            margin: 10px 0;

            &:hover {
                background-color: var(--hover-range-color);
            }

            &.is-selected {
                background-color: var(--primary-color);
                color: white;
            }

            &.is-disabled {
                cursor: not-allowed;
                opacity: 0.5;
                pointer-events: none;
            }

            &:not(.is-disabled) {
                cursor: pointer;
            }
        }
    }

    .calendar-days-name,
    .calendar-days {
        display: flex;
        flex-wrap: wrap;
        .day {
            width: calc(100% / 7);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
    }

    .calendar-days-name .day {
        font-size: 11px;
        color: var(--ternary-color);
        height: 30px;
    }

    .calendar-days .day {
        height: 40px;
        font-size: 13px;
        border-top: 2px solid white;
        border-bottom: 2px solid white;

        &:not(.is-current-month) {
            color: var(--ternary-color);
        }

        &.is-disabled {
            cursor: not-allowed;
            opacity: 0.5;
            pointer-events: none;
        }

        &.is-today {
            span {
                color: var(--secondary-color);
                font-weight: bold;
            }
        }

        &.is-in-range {
            background-color: var(--hover-range-color);
        }

        &.is-first-range {
            border-top-left-radius: 4px;
            border-bottom-left-radius: 4px;
        }

        &.is-last-range {
            border-top-right-radius: 4px;
            border-bottom-right-radius: 4px;
        }

        &.is-edge-range {
            background-color: var(--primary-color);
            color: white;
        }

        &.is-selected {
            background-color: var(--primary-color);
            color: white;
        }

        &:not(.is-disabled) {
            cursor: pointer;
        }
    }
}

.mj-calendar.mj-calendar-days {
    display: flex;
    flex-direction: column;

    .calendar-days {
        flex-grow: 1;
    }

    .calendar-days .day {
        &:not(.is-edge-range):hover {
            background-color: var(--hover-day-color);
        }
    }
}

.mj-daterange-picker-controls {
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-top: 1px solid var(--border-color);
    padding: 20px;

    .mj-daterange-picker-button {
        height: 36px;
        min-width: 150px;
        padding: 5px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 4px;
        font-size: 12px;

        &:not(.is-disabled) {
            cursor: pointer;
        }
    }
}

.mj-daterange-picker-reset {
    border: 1px solid #e6eaed;
}

.mj-daterange-picker-submit {
    background-color: var(--primary-color);
    color: white;

    &.is-disabled {
        opacity: 0.5;
        cursor: not-allowed;
        pointer-events: none;
    }
}
</style>
