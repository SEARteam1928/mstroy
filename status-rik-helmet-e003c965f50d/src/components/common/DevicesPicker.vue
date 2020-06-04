<template>
    <div class="DevicesPicker">
        <q-select
            class="DevicesPicker-select"
            outlined
            use-input
            dense
            clearable
            multiple
            hide-bottom-space
            :value="value"
            :options="deviceOptions"
            :loading="loading"
            :error="error"
            input-debounce="0"
            label="Выбор устройств"
            option-label="name"
            option-value="id"
            @input="onChangeDevice"
            @filter="filterFn"
            @keydown.enter="onEnter"
            @popup-show="onPopupShow"
            @popup-hide="onPopupHide"
            :display-value="selectedCounter"
        >
            <template v-slot:no-option>
                <q-item>
                    <q-item-section class="text-grey">Не найдено</q-item-section>
                </q-item>
            </template>
        </q-select>
    </div>
</template>

<script>
import sortByNameField from '../../services/utils/sortByNameField';

export default {
    name: 'DevicesPicker',
    props: {
        value: {
            validator: prop => prop instanceof Array || prop === null,
            required: true
        },
        devices: {
            type: Array,
            required: true
        },
        loading: {
            type: Boolean,
            required: false,
            default: false
        },
        error: {
            type: Boolean,
            required: false,
            default: false
        }
    },
    data() {
        return {
            deviceOptions: []
        };
    },
    computed: {
        selectedCounter() {
            let counter = '';
            if (this.value instanceof Array && this.value.length > 0) {
                counter = `Выбрано: ${this.value.length}`;

                let devicesId = this.value.map(({ rowId }) => rowId);
                counter += ` [${devicesId.join(', ')}]`;
            }

            return counter;
        }
    },
    created() {
        this.deviceOptions = [...this.devices].sort(sortByNameField);
    },
    methods: {
        // Метод поиска и фильтрации списка устройств по имени из инпута в селекте
        filterFn(val, update) {
            update(
                () => {
                    if (val === '') {
                        this.deviceOptions = [...this.devices].sort(sortByNameField);
                    } else {
                        let needle = val.toLowerCase();
                        this.deviceOptions = this.devices
                            .filter(({ name }) => name.toLowerCase().indexOf(needle) > -1)
                            .sort(sortByNameField);
                    }
                },

                // Этот аргумент нужен для того, чтобы после ввода каждого символа ставить фокус на первый пункт опщнов
                // Нужно для того, чтобы по нажатию Enter после ввода первый опшн автоматически становился выбранным
                // ref - инстанс q-select
                ref => {
                    if (val !== '' && ref.options.length > 0) {
                        // Сброс фокуса с опшнов
                        ref.setOptionIndex(-1);
                        // Установка фокуса на первый опшн
                        ref.moveOptionSelection(1, true);
                    }
                }
            );
        },
        onEnter() {
            let device = this.deviceOptions[0];
            this.$emit('input', device);
        },
        onChangeDevice(devices) {
            this.$emit('input', devices);
        },

        onPopupShow() {
            this.$emit('popup-show');
        },
        onPopupHide() {
            this.$emit('popup-hide');
        }
    }
};
</script>

<style lang="sass">
.DevicesPicker
</style>
