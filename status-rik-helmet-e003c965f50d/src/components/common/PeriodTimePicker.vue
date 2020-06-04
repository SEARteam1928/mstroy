<template>
    <div class="PeriodTimePicker">
        <div class="PeriodTimePicker-sectionWrap PeriodTimePicker-fromWrap">
            <q-input filled :dense="dense" v-model="dateFrom" @input="onChange">
                <template v-slot:prepend>
                    <q-icon name="event" class="cursor-pointer">
                        <q-popup-proxy transition-show="scale" transition-hide="scale">
                            <q-date today-btn :minimal="minimal" v-model="dateFrom" :mask="mask" @input="onChange" />
                        </q-popup-proxy>
                    </q-icon>
                </template>

                <template v-slot:append>
                    <q-icon name="access_time" class="cursor-pointer">
                        <q-popup-proxy transition-show="scale" transition-hide="scale">
                            <q-time format24h now-btn v-model="dateFrom" :mask="mask" @input="onChange" />
                        </q-popup-proxy>
                    </q-icon>
                </template>
            </q-input>
        </div>

        <div class="period-picker-delimit">&mdash;</div>

        <div class="PeriodTimePicker-sectionWrap PeriodTimePicker-toWrap">
            <q-input filled :dense="dense" v-model="dateTo" @input="onChange">
                <template v-slot:prepend>
                    <q-icon name="event" class="cursor-pointer">
                        <q-popup-proxy transition-show="scale" transition-hide="scale">
                            <q-date today-btn :minimal="minimal" v-model="dateTo" :mask="mask" @input="onChange" />
                        </q-popup-proxy>
                    </q-icon>
                </template>

                <template v-slot:append>
                    <q-icon name="access_time" class="cursor-pointer">
                        <q-popup-proxy transition-show="scale" transition-hide="scale">
                            <q-time format24h now-btn v-model="dateTo" :mask="mask" @input="onChange" />
                        </q-popup-proxy>
                    </q-icon>
                </template>
            </q-input>
        </div>
    </div>
</template>

<script>
import dateParse from '@services/utils/dateUtils/parse';
import isValidDate from '@services/utils/dateUtils/isValid';

import { date as quasarDate } from 'quasar';

export default {
    name: 'PeriodTimePicker',
    props: {
        dense: {
            required: false
        },
        minimal: {
            required: false
        },
        toISO: {
            required: false
        },
        from: {
            type: String,
            required: false,
            default: () => {
                let dateFrom = quasarDate.addToDate(new Date(), { minutes: -1 });
                dateFrom = dateFrom.toISOString();

                return dateFrom;
            }
        },
        to: {
            type: String,
            required: false,
            default: () => {
                let dateTo = quasarDate.buildDate({});
                dateTo = dateTo.toISOString();

                return dateTo;
            }
        }
    },
    data() {
        return {
            mask: 'DD.MM.YYYY HH:mm',
            dateFrom: '',
            dateTo: ''
        };
    },
    methods: {
        onChange() {
            let period = {};

            // Извлекаем time stamp из строки по ее маске
            let from = +quasarDate.extractDate(this.dateFrom, this.mask);
            period.from = from > 0 ? from : null;

            let to = +quasarDate.extractDate(this.dateTo, this.mask);
            period.to = to > 0 ? to : null;

            // Если нужно привести дату к toISOString
            if (this.toISO !== undefined) {
                if (period.from) {
                    let date = new Date(period.from);
                    period.from = date.toISOString();
                }

                if (period.to) {
                    let date = new Date(period.to);
                    period.to = date.toISOString();
                }
            }

            this.$emit('change', period);
        }
    },
    created() {
        let dateFrom = this.from;
        let dateFormatFrom = quasarDate.inferDateFormat(dateFrom);
        if (dateFormatFrom === 'string') dateFrom = dateParse(dateFrom);

        dateFrom = quasarDate.formatDate(dateFrom, this.mask);
        this.dateFrom = dateFrom;

        let dateTo = this.to;
        let dateFormatTo = quasarDate.inferDateFormat(dateTo);
        if (dateFormatTo === 'string') dateTo = dateParse(dateTo);

        dateTo = quasarDate.formatDate(dateTo, this.mask);
        this.dateTo = dateTo;

        // После инициализации стартового периода, отдадим его сразу родителю
        this.onChange();
    }
};
</script>

<style lang="sass">
.PeriodTimePicker
    display: flex
    align-items: center
    .PeriodTimePicker-fromWrap
        flex-grow: 1
        padding-right: 5px
    .PeriodTimePicker-toWrap
        flex-grow: 1
        padding-left: 5px
</style>
