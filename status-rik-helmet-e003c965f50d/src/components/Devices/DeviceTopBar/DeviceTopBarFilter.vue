<template>
    <div class="DeviceTopBarFilter">
        <q-toggle dense v-model="autoUpdateModel">Автообновление</q-toggle>
        <q-select
            class="DeviceTopBarFilter-select"
            dense
            clearable
            multiple
            v-model="filters"
            :options="deviceListFilters"
            :display-value="selectedCounter"
            label="Фильтр устройств"
            popup-content-class="DeviceTopBarFilter-select-options"
        >
            <template v-slot:option="scope">
                <q-item v-bind="scope.itemProps" v-on="scope.itemEvents">
                    <q-item-section>
                        <q-toggle v-model="toggleModel" :val="scope.opt.value" left-label :label="scope.opt.label" />
                    </q-item-section>
                </q-item>
            </template>
        </q-select>
    </div>
</template>

<script>
import { deviceListFilters } from '@services/utils';

import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'DeviceTopBarFilter',
    data() {
        return {
            deviceListFilters
        };
    },
    computed: {
        ...mapGetters('Devices', ['deviceFilters', 'autoUpdate']),

        autoUpdateModel: {
            get() {
                return this.autoUpdate;
            },
            set(val) {
                this.setAutoUpdate(val);
            }
        },

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
        selectedCounter() {
            let counter = '';
            if (this.deviceFilters.length > 0) {
                counter = `Активных фильтров: ${this.deviceFilters.length}`;
            }

            return counter;
        }
    },
    created() {
        window.DeviceTopBarFilter = this;

        // Восстановление списка фильтров из localStorage
        this.toggleModel = this.restoreFilters();
    },
    methods: {
        ...mapMutations('Devices', ['setDeviceFilters', 'setAutoUpdate']),

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
        }
    }
};
</script>

<style lang="sass">
.DeviceTopBarFilter
    .q-field__label
        user-select: none

.DeviceTopBarFilter-select-options
    .q-toggle__label
        width: 100%
</style>
