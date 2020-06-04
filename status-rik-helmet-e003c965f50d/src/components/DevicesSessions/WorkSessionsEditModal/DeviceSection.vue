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
            color="ms-primary"
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
        ...mapGetters('DevicesSessions', ['editSessionModalData', 'allDevices', 'getDeviceById']),

        loadingDevices() {
            return this.allDevices.length === 0;
        },
        isDisabled() {
            return this.editSessionModalData.id !== null || this.editSessionModalData.deviceId !== null;
        }
    },
    watch: {
        // Если модалка в режиме редактирования, значит выбор устройств блокируется
        // и нужно установить в модель селекта уже занесенное в хранилище устройство
        isDisabled: {
            handler(newDisabled) {
                if (newDisabled) {
                    let { deviceId } = this.editSessionModalData;
                    let device = this.getDeviceById(deviceId);
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
        this.deviceOptions = this.allDevices;

        let { deviceId } = this.editSessionModalData;
        let device = this.getDeviceById(deviceId);
        if (device) this.deviceModel = device;

        window.DeviceSection = this;
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setEditSessionModalData']),

        // Метод поиска и фильтрации списка устройств по имени из инпута в селекте
        filterFn(val, update) {
            update(
                () => {
                    if (val === '') {
                        this.deviceOptions = this.allDevices;
                    } else {
                        let needle = val.toLowerCase();
                        this.deviceOptions = this.allDevices.filter(
                            ({ name }) => name.toLowerCase().indexOf(needle) > -1
                        );
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
            let deviceId = null;

            if (prop instanceof Object) {
                deviceId = prop.id;
            }

            this.setEditSessionModalData({ deviceId });
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    &-deviceSection
    &-deviceSelect
</style>
