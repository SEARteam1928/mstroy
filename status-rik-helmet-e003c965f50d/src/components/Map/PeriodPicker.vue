<template>
    <div class="period-picker">
        <div class="period-picker-from-wrap">
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

        <div class="period-picker-to-wrap">
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
import { date } from 'quasar';

export default {
    name: 'PeriodPicker',
    props: {
        dense: {
            required: false
        },
        minimal: {
            required: false
        },
        toISO: {
            required: false
        }
    },
    data() {
        return {
            mask: 'YYYY-MM-DD HH:mm',
            dateFrom: '',
            dateTo: ''
        };
    },
    methods: {
        onChange() {
            let period = {};

            // Извлекаем time stamp из строки по ее маске
            let from = +date.extractDate(this.dateFrom, this.mask);
            period.from = from > 0 ? from : null;

            let to = +date.extractDate(this.dateTo, this.mask);
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
        // Заполняем первый календарь сегодняшним числом, но время будет 0:00
        let dateFrom = date.buildDate({ hours: 0, minutes: 0, seconds: 0, milliseconds: 0 });
        dateFrom = date.formatDate(dateFrom, this.mask);
        this.dateFrom = dateFrom;

        // Заполняем второй календарь текущей датой и временем
        let dateTo = date.buildDate({});
        dateTo = date.formatDate(dateTo, this.mask);
        this.dateTo = dateTo;

        // После инициализации стартового периода, отдадим его сразу родителю
        this.onChange();
    }
};
</script>

<style lang="sass" scoped>
.period-picker
    display: flex
    align-items: center
    .period-picker-from-wrap
        flex-grow: 1
        padding-right: 5px
    .period-picker-to-wrap
        flex-grow: 1
        padding-left: 5px
</style>
