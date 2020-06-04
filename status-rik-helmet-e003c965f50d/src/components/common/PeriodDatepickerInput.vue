<template>
    <div class="PeriodDatepickerInput" :class="{ 'mobileMode': mobileMode }">
        <q-field
            outlined
            dense
            clearable
            color="ms-primary"
            :class="{ 'isEmpty': isEmpty }"
            :label="label"
            :value="dateString"
            @clear="onClearClick"
            @blur="close"
        >
            <template v-slot:prepend>
                <q-icon class="cursor-pointer" name="today" @click="toggle" />
            </template>

            <template v-slot:control>
                <input
                    class="PeriodDatepickerInput-input-inner q-field__native q-placeholder"
                    type="text"
                    tabindex="0"
                    :aria-label="label"
                    :value="dateString"
                    @input="onInputValue"
                    @keypress.enter="close"
                    ref="input"
                />

                <q-btn-dropdown
                    class="PeriodDatepickerInput-btn-dropdown"
                    :class="alignPicker"
                    v-model="isOpen"
                    :menu-self="align"
                    @hide="onBtnDropdownHide"
                >
                    <PeriodDatepicker
                        class="PeriodDatepicker"
                        :class="{ 'mobileMode': mobileMode }"
                        :from="PeriodDatepickerData.from"
                        :to="PeriodDatepickerData.to"
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
                        @update="onUpdatePeriod"
                        @select="onSelectPeriod"
                        @reset="onResetPeriod"
                        @selectDay="onSelectDay"
                        @click.stop
                        ref="PeriodDatepicker"
                    />
                </q-btn-dropdown>
            </template>
        </q-field>

        <transition name="fade">
            <div v-if="isOpen && mobileMode" class="PeriodDatepickerInput-background" @click="close" />
        </transition>
    </div>
</template>

<script>
import { date as quasarDate } from 'quasar';
import { dateISONormalize } from '@services/utils';

import PeriodDatepicker from './PeriodDatepicker.vue';

export default {
    name: 'PeriodDatepickerInput',
    components: {
        PeriodDatepicker
    },
    props: {
        from: {
            type: String,
            required: false,
            default: null
        },
        to: {
            type: String,
            required: false,
            default: null
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
        },
        align: {
            type: String,
            required: false,
            default: 'top left'
        },
        clickableInput: {
            type: Boolean,
            required: false,
            default: false
        },
        mobileMode: {
            type: Boolean,
            required: false,
            default: false
        },
        label: {
            type: String,
            required: false,
            default: ''
        },
        clearable: {
            type: Boolean,
            required: false,
            default: false
        },
        dense: {
            type: Boolean,
            required: false,
            default: false
        },
        value: {
            type: Object,
            required: false
        }
    },
    computed: {
        isEmpty() {
            let isEmpty = false;

            let { from } = this.PeriodDatepickerData;
            if (!from) isEmpty = true;

            return isEmpty;
        },
        dateString() {
            let dateString = '';
            if (this.isEmpty) return dateString;

            let { from, to } = this.PeriodDatepickerData;

            if (from) {
                from = quasarDate.formatDate(from, this.mask);

                if (this.panel === 'day') {
                    dateString = `${from}`;

                    return dateString;
                }

                dateString = `${from} - `;
            }

            if (to) {
                to = quasarDate.formatDate(to, this.mask);
                dateString += to;
            } else if (this.$refs.input) {
                let inputValue = this.$refs.input.value;
                dateString = inputValue.startsWith(from) ? inputValue : dateString;
            }

            return dateString;
        },
        alignPicker() {
            return {
                'PeriodDatepicker-align-left':
                    this.align === 'top left' || this.align === 'center left' || this.align === 'bottom left',
                'PeriodDatepicker-align-center':
                    this.align === 'top middle' || this.align === 'center middle' || this.align === 'bottom middle',
                'PeriodDatepicker-align-right':
                    this.align === 'top right' || this.align === 'center right' || this.align === 'bottom right',
                'isEmpty': this.isEmpty
            };
        }
    },
    watch: {
        isOpen(newState) {
            if (newState) {
                this.$emit('open');
            } else {
                this.$emit('close');
            }
        },
        values(newValue, oldValue) {
            let { from, to } = newValue;
            if (from === null || to === null) this.$emit('input', newValue);
            if (from === oldValue.from && to === oldValue.to) return;

            this.$emit('input', newValue);
        },

        value(newValue) {
            let { from, to } = newValue;
            this.PeriodDatepickerData = { from, to };
        }
    },
    data() {
        return {
            PeriodDatepickerData: { from: null, to: null },
            values: { from: null, to: null },
            mask: 'DD.MM.YYYY',
            isOpen: false
        };
    },
    created() {
        window.PeriodDatepickerInput = this;

        this.PeriodDatepickerData = { from: this.from, to: this.to };
    },
    methods: {
        normalizeDateFormat(dateString) {
            // Из строкового представления даты в русском формате делает формат YYYY-MM-DD
            // В таком формате правильно пройдет парсинг в new Date
            return dateString
                .split(/[-\.\/,]/)
                .reverse()
                .join('.');
        },
        inputDateParser(value) {
            let from = null;
            let to = null;

            // https://regex101.com/r/5MSi1M/3
            let regex = /^\s*(?<from>\d{1,2}[-\.\/,]\d{1,2}[-\.\/,]\d{4})(\s*-?\s*(?<to>\d{1,2}[-\.\/,]\d{1,2}[-\.\/,]\d{4}))?/;
            let match = regex.exec(value);

            if (match) {
                from = match.groups.from ? this.normalizeDateFormat(match.groups.from) : from;
                to = match.groups.to ? this.normalizeDateFormat(match.groups.to) : to;
            }

            return { from, to };
        },
        onInputValue(e) {
            let { value } = e.target;
            let { from, to } = this.inputDateParser(value);

            if (!from) return;

            this.PeriodDatepickerData = this.normalizeValues({ from, to });
        },

        normalizeValues(values) {
            let { from, to, date } = values;
            let result = { from: null, to: null };

            if (date) {
                let _date = quasarDate.adjustDate(new Date(date), {
                    hours: 0,
                    minutes: 0,
                    seconds: 0,
                    milliseconds: 0
                });
                result.from = dateISONormalize(_date);

                return result;
            }

            if (from) {
                // В процессе ввода даты в инпут, регулярка может находить такие значения,
                // которые подойдут под формат даты, но не будут являться корректной датой, что вызовет ошибку
                try {
                    let _from = quasarDate.adjustDate(new Date(from), {
                        hours: 0,
                        minutes: 0,
                        seconds: 0,
                        milliseconds: 0
                    });
                    result.from = dateISONormalize(_from);
                } catch (err) {}
            }

            if (to) {
                // В процессе ввода даты в инпут, регулярка может находить такие значения,
                // которые подойдут под формат даты, но не будут являться корректной датой, что вызовет ошибку
                try {
                    let _to = quasarDate.adjustDate(new Date(to), {
                        hours: 23,
                        minutes: 59,
                        seconds: 59,
                        milliseconds: 999
                    });
                    result.to = dateISONormalize(_to);
                } catch (err) {}
            }

            return result;
        },
        setValues() {
            this.values = this.PeriodDatepickerData;
        },
        onUpdatePeriod(values) {
            this.PeriodDatepickerData = this.normalizeValues(values);
            this.close();
            this.setValues();

            this.$emit('update', this.PeriodDatepickerData);
        },
        onSelectPeriod(values) {
            this.PeriodDatepickerData = this.normalizeValues(values);
            // Если у календаря нет подтверждающих кнопок, то после выбора даты он будет закрываться
            // и обновлять даты для работы с v-model. Иначе v-model будет обновляться только после нажатия кнопок
            if (!this.showControls) {
                this.close();
                this.setValues();
            }

            this.$emit('select', this.PeriodDatepickerData);
        },
        onSelectDay(values) {
            this.PeriodDatepickerData = this.normalizeValues(values);
        },
        onResetPeriod(values) {
            this.PeriodDatepickerData = this.normalizeValues(values);
            this.setValues();
            this.$emit('reset', this.PeriodDatepickerData);
        },
        onBtnDropdownHide() {
            this.isOpen && this.close();
        },
        onClearClick() {
            this.reset();
        },
        reset() {
            this.values = { from: null, to: null };
            this.PeriodDatepickerData = { from: null, to: null };
            this.$refs.PeriodDatepicker && this.$refs.PeriodDatepicker.reset();

            this.$emit('reset', this.PeriodDatepickerData);
        },
        open() {
            this.isOpen = true;
        },
        close() {
            this.isOpen = false;

            if (!this.showControls) return;

            // Если у календаря есть подтверждающие кнопки и были изменены даты, а потом календарь закрывается,
            // но не была нажата кнопка "Подтвердить", то автоматически применим изменения
            let { from, to } = this.PeriodDatepickerData;
            if (from !== this.values.from || to !== this.values.to) {
                this.setValues();
            }
        },
        toggle() {
            if (this.isOpen) {
                this.close();
            } else {
                this.open();
            }
        }
    }
};
</script>

<style lang="sass">
.PeriodDatepickerInput
    position: relative
    .PeriodDatepickerInput-input
        display: flex
        border: 1px solid transparent
        border-radius: 4px
        z-index: 10
        background-color: #fff
        color: #000
    &-btn
        display: flex
        justify-content: center
        align-items: center
        &-icon
            color: rgba(0,0,0,0.54)
            transition: color 0.36s cubic-bezier(0.4, 0, 0.2, 1)
            font-size: 24px
    &-background
        position: fixed
        width: 100vw
        height: 100vh
        top: 0
        left: 0
        z-index: 1

    &-btn-dropdown
        height: 100%
        width: 1px
        position: absolute
        top: 0
        opacity: 0
        z-index: -1
        &.PeriodDatepicker-align-left
            left: 0
        &.PeriodDatepicker-align-center
            left: 50%
            transform: translateX(calc( -50% ))
        &.isEmpty.PeriodDatepicker-align-center
            transform: translateX(calc( -50% - 15px ))
        &.PeriodDatepicker-align-right
            right:
        .q-anchor--skip
            padding: 0

    .PeriodDatepicker
        position: absolute
        top: 100%
        box-shadow: 0 3px 6px -1px rgba(0, 0, 0, 0.4)
        .mj-daterange-picker
            background-color: #fff
            border-color: transparent

    .fade-enter-active, .fade-leave-active
        transition: opacity .25s
    .fade-enter, .fade-leave-to
        opacity: 0

    // Мобильный режим календаря
    &.mobileMode
        .PeriodDatepickerInput
            &-background
                background-color: rgba(0,0,0,0.54)
                z-index: 1

.PeriodDatepicker
    &.mobileMode
        z-index: 10
        position: fixed
        right: auto
        top: 50%
        left: 50%
        transform: translate(-50%, -50%)
        .mj-daterange-picker
            background-color: #fff
            border-color: transparent
</style>
