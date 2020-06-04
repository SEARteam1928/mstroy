<template>
    <q-select
        class="devices-select"
        :dense="dense"
        :error="hasError"
        :error-message="errorMsg"
        filled
        multiple
        clearable
        hide-bottom-space
        v-model="devicesModel"
        :label="label"
        :options="devicesOptions"
        :display-value="selectedCounter"
        @filter="filterFn"
        @filter-abort="abortFilterFn"
        @input="onChange"
        @popup-show="onPopupShow"
        @popup-hide="onPopupHide"
        option-label="name"
        option-value="lora_key"
        ref="select"
    >
        <template v-slot:no-option>
            <q-item>
                <q-item-section class="text-grey">Нет устройств</q-item-section>
            </q-item>
        </template>
    </q-select>
</template>

<script>
import api from '../../services/api';

export default {
    name: 'DevicesSelect',
    props: {
        label: {
            type: String,
            required: true
        },
        dense: {
            required: false
        }
    },
    data() {
        return {
            hasError: false,
            errorMsg: 'Ошибка получения данных',
            devicesModel: null,
            devicesOptions: null
        };
    },
    computed: {
        // Для отображения в селекте количества выбранных устройств
        selectedCounter() {
            let counter = '';
            if (this.devicesModel instanceof Array && this.devicesModel.length > 0) {
                counter = `Выбрано: ${this.devicesModel.length}`;
            }

            return counter;
        }
    },
    methods: {
        // Метод, который запрашивает массив устройств при открытии селекта
        async filterFn(val, update, abort) {
            // Если устройства были получены ранее, используем их и выходим
            if (this.devicesOptions !== null) {
                update();
                this.hasError = false;
                return;
            }

            // Запрос устройств от апи
            try {
                let res = await api.getDevices();
                let devices = res.data.filter(device => device.name && device.lora_key);
                devices.sort((a, b) => {
                    if (a.name > b.name) {
                        return 1;
                    } else if (a.name === b.name) {
                        return 0;
                    } else {
                        return -1;
                    }
                });

                update(() => {
                    this.devicesOptions = devices;
                });
                this.hasError = false;
            } catch (err) {
                console.log('Ошибка получения списка устройств');
                abort();
                this.hasError = true;
            }
        },
        abortFilterFn() {
            console.log('Отмена загрузки устройств');
        },
        onChange(devices) {
            this.$emit('change', devices);
        },
        onPopupShow() {
            console.log('Селект открыт');
        },
        onPopupHide() {
            console.log('Селект закрыт');
        }
    },
    created() {
        window.mapPage = this;
    }
};
</script>

<style lang="sass"></style>
