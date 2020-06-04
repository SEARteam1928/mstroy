<template>
    <div class="DevicesSessionsFilter">
        <QBtnDropdown
            class="DevicesSessionsFilter-btn"
            outline
            color="ms-primary"
            dropdown-icon="keyboard_arrow_down"
            :label="btnLabelWithFiltersCounter"
        >
            <q-list class="DevicesSessionsFilter-list">
                <q-item
                    class="DevicesSessionsFilter-item"
                    :class="{
                        'DevicesSessionsFilter-itemActive': checkActiveFilter(filter.value),
                        [`DevicesSessionsFilter-${filter.value}`]: true
                    }"
                    tag="label"
                    v-ripple
                    v-for="filter in deviceListFilters"
                    :key="filter.value"
                >
                    <q-item-section avatar class="DevicesSessionsFilter-itemToggle">
                        <q-toggle color="ms-primary" dense v-model="toggleModel" :val="filter.value" />
                    </q-item-section>
                    <q-item-section class="DevicesSessionsFilter-itemLabel">
                        <q-item-label>{{ filter.label }}</q-item-label>
                    </q-item-section>
                </q-item>
            </q-list>
        </QBtnDropdown>
    </div>
</template>

<script>
import deviceListFilters from '@services/utils/deviceListFilters';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'DevicesSessionsFilter',
    data() {
        return {
            deviceListFilters,
            btnLabel: 'Фильтр устройств'
        };
    },
    computed: {
        ...mapGetters('DevicesSessions', ['deviceFilters']),

        // Модель активных фильтров
        filters: {
            get() {
                return this.deviceFilters;
            },
            set(val) {
                if (val === null) val = [];

                this.setDeviceFilters(val);

                let filtersArr = this.filtersToArray(val);
                this.saveDeviceFilters(filtersArr);
            }
        },
        // Модель для переключателей в option селекта
        toggleModel: {
            get() {
                // Мапим объекты фильтров так, чтобы в массиве модели переключателей были только строки с value фильтров
                return this.deviceFilters.map(({ value }) => value);
            },
            set(val) {
                // Фильтруем массив фильтров на соответствие с массивом активных переключателей
                let filters = this.deviceListFilters.filter(({ value }) => val.includes(value));

                this.setDeviceFilters(filters);

                let filtersArr = this.filtersToArray(filters);
                this.saveDeviceFilters(filtersArr);
            }
        },

        // Счетчик количества активных фильтров
        btnLabelWithFiltersCounter() {
            let label = this.btnLabel;
            if (this.deviceFilters.length > 0) {
                label += `: ${this.deviceFilters.length}`;
            }

            return label;
        }
    },
    created() {
        // Восстановление списка фильтров из localStorage
        this.toggleModel = this.restoreFilters();
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setDeviceFilters']),

        // Приводит массив объектов или имен фильтров к массиву имен фильтров
        filtersToArray(filters) {
            let array = filters.map(filter => {
                if (typeof filter === 'string') return filter;

                return filter.value;
            });

            return array;
        },

        saveDeviceFilters(filters) {
            window.localStorage.setItem('deviceFilters', JSON.stringify(filters));
        },
        restoreFilters() {
            let result = [];

            try {
                let filters = window.localStorage.getItem('deviceFilters');
                if (filters) result = JSON.parse(filters);
            } catch (error) {}

            return result;
        },

        checkActiveFilter(value) {
            return this.deviceFilters.find(({ value: _value }) => _value === value);
        }
    }
};
</script>

<style lang="sass">
.DevicesSessionsFilter
    &-btn
        position: relative
        &:before
            content: ''
            position: absolute
            top: 0
            bottom: 0
            right: 38px
            width: 1px
            background-color: var(--ms-primary)
        .q-btn__wrapper
            padding-right: 8px
            .q-btn__content
                & > div
                    min-width: 170px
                    text-align: left

    &-list
        padding: 8px
    &-item
        color: var(--ms-dark)
        border-radius: 4px
        transition: background-color 250ms ease-in-out
        &:not(:last-of-type)
            margin-bottom: 8px
        &:hover
            background-color: var(--ms-light-grey)
        .q-focus-helper
            display: none
    &-itemActive

    // Кастомное оформление айтемов фильтров
    &-filterWithConnectionError,
    &-filterWithConnectionWarning,
    &-filterWithConnectionNormal
        .DevicesSessionsFilter
            // Добавление цветового индикатора перед описанием фильтра
            &-itemLabel
                position: relative
                padding-left: 16px
                &:before
                    content: ''
                    position: absolute
                    left: 0
                    top: 0
                    bottom: 0
                    width: 8px

    &-filterWithConnectionError
        .DevicesSessionsFilter
            &-itemLabel
                &:before
                    background-color: #f44336
    &-filterWithConnectionWarning
        .DevicesSessionsFilter
            &-itemLabel
                &:before
                    background-color: #ffc107
    &-filterWithConnectionNormal
        .DevicesSessionsFilter
            &-itemLabel
                &:before
                    background-color: #4caf50
</style>
