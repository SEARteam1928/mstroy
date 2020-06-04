<template>
    <div class="DevicesRawDataHeader">
        <DevicesPicker
            class="DevicesPicker"
            v-model="selectedDeviceModel"
            :devices="deviceList"
            :loading="isLoadingDevices"
            :error="errorLoadingDevices"
            @popup-hide="onPopupHide"
        />
        <PeriodTimePicker class="PeriodTimePicker" dense toISO @change="onChangePeriod" />

        <q-btn
            class="DevicesRawData-saveBtn"
            color="ms-primary"
            :disable="disableSaveBtn"
            :loading="isLoadingSave"
            @click="onSaveBtnClick"
        >
            Сохранить в .csv
            <template v-slot:loading>
                <q-spinner-puff />
            </template>
        </q-btn>
    </div>
</template>

<script>
import DevicesPicker from '../common/DevicesPicker.vue';
import PeriodTimePicker from '../common/PeriodTimePicker.vue';

import isFalse from '@services/utils/isFalse';
import saveDownload from '@services/utils/saveDownload';

import withShowMessage from '@mixins/withShowMessage';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DevicesRawDataHeader',
    components: {
        DevicesPicker,
        PeriodTimePicker
    },
    mixins: [withShowMessage()],
    computed: {
        ...mapGetters('DevicesRawData', [
            'isActiveRequestDeviceList',
            'isActiveRequestDeviceCoordinatesExcel',
            'periodDate',
            'selectedDevicesId',
            'selectedDevices',
            'deviceList',
            'getDevice',
            'moduleErrors'
        ]),

        isLoadingDevices() {
            return this.isActiveRequestDeviceList;
        },

        errorLoadingDevices() {
            return this.moduleErrors.requestDeviceList !== undefined;
        },

        selectedDeviceModel: {
            get() {
                return this.selectedDevices;
            },
            set(devices) {
                if (!devices) {
                    this.clearSelectedDevicesId();

                    return;
                }

                let selectedDevices = devices.map(({ rowId }) => rowId);
                this.setSelectedDevicesId(selectedDevices);
            }
        },

        hasSelectedDevices() {
            return this.selectedDevicesId.length > 0;
        },

        disableSaveBtn() {
            let disable = true;

            if (this.periodDate.from && this.periodDate.to && this.hasSelectedDevices) disable = false;

            return disable;
        },
        isLoadingSave() {
            return this.isActiveRequestDeviceCoordinatesExcel;
        },
        csvFileName() {
            let name = '.csv';
            if (this.selectedDevice) {
                let devName = this.selectedDevice.name;
                let loraKey = this.selectedDevice.loraKey;
                let { from, to } = this.periodDate;

                name = `name-${devName}_loraKey-${loraKey}_from-${from}_to-${to}${name}`;
            } else {
                name = `Данные с устройства${name}`;
            }

            return name;
        }
    },
    methods: {
        ...mapMutations('DevicesRawData', [
            'setPeriodDate',
            'setSelectedDevicesId',
            'clearSelectedDevicesId',
            'setIsActiveRequestDeviceCoordinatesExcel'
        ]),
        ...mapActions('DevicesRawData', ['requestDeviceCoordinatesExcel', 'requestDeviceCoordinates']),

        onChangePeriod(period) {
            this.setPeriodDate(period);
        },

        onPopupHide() {
            this.requestDeviceCoordinates();
        },

        async onSaveBtnClick() {
            let data = await this.requestDeviceCoordinatesExcel();
            if (!data) {
                this.showMessage('Нет данных для сохранения в файл .csv', true);

                return;
            }

            let blob = new Blob([data], { type: 'text/csv' });
            let objectUrl = window.URL.createObjectURL(blob);

            saveDownload(objectUrl, this.csvFileName);

            setTimeout(() => {
                window.URL.revokeObjectURL(objectUrl);
            }, 200);
        }
    }
};
</script>

<style lang="sass">
.DevicesRawDataHeader
    display: flex
    .DevicesPicker
        margin-right: 16px
        flex-grow: 1
    .PeriodTimePicker
        margin-right: 16px
        flex-grow: 1
</style>
