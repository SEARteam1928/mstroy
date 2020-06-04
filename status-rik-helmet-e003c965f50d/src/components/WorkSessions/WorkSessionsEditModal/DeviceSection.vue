<template>
    <q-card-section class="WorkSessionsEditModal-deviceSection">
        <q-select
            class="WorkSessionsEditModal-deviceSelect"
            outlined
            use-input
            dense
            clearable
            v-model="deviceModel"
            :options="deviceOptions"
            :loading="loadingDevices"
            :disable="isDisabled"
            input-debounce="0"
            label="Выбор устройства"
            option-label="name"
            option-value="id"
            @input="onChangeDevice"
            @filter="filterFn"
            @keydown.enter="onEnter"
            :display-value="`${deviceModel ? deviceModel.name : ''}`"
        >
            <template v-slot:no-option>
                <q-item>
                    <q-item-section class="text-grey">Не найдено</q-item-section>
                </q-item>
            </template>
        </q-select>
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DeviceSection',
    computed: {
        ...mapGetters('WorkSessions', ['editModalData', 'devices', 'device']),

        loadingDevices() {
            return this.devices.length === 0;
        },
        isDisabled() {
            return this.editModalData.work_session_id !== null;
        }
    },
    watch: {
        // Если модалка в режиме редактирования, значит выбор устройств блокируется
        // и нужно установить в модель селекта уже занесенное в хранилище устройство
        isDisabled: {
            handler(newDisabled) {
                if (newDisabled) {
                    let { device_id } = this.editModalData;
                    let device = this.device(device_id);
                    if (device) this.deviceModel = device;
                }
            },
            immediate: true
        }
    },
    data() {
        return {
            deviceModel: null,
            deviceOptions: []
        };
    },
    created() {
        this.deviceOptions = this.devices;

        window.DeviceSection = this;
    },
    methods: {
        ...mapMutations('WorkSessions', ['setEditModalData']),

        // Метод поиска и фильтрации списка устройств по имени из инпута в селекте
        filterFn(val, update) {
            update(
                () => {
                    if (val === '') {
                        this.deviceOptions = this.devices;
                    } else {
                        let needle = val.toLowerCase();
                        this.deviceOptions = this.devices.filter(({ name }) => name.toLowerCase().indexOf(needle) > -1);
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
            this.deviceModel = device;
        },
        onChangeDevice(prop) {
            let device_id = null;

            if (prop instanceof Object) {
                device_id = prop.id;
            }

            this.setEditModalData({ device_id });
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    &-deviceSection
    &-deviceSelect
</style>
