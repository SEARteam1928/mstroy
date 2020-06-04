<template>
    <div class="DevicesRawDataView">
        <DataPreloader
            :loading="isLoading"
            :info="!hasParams"
            infoMessage="Выберите устройство и период времени"
            :warning="isEmpty"
            warningMessage="Нет данных за выбранный период"
            vertical
        >
            <DataViewer :data="deviceCoordinates" :expandDepth="2" />
        </DataPreloader>
    </div>
</template>

<script>
import DataPreloader from '../common/DataPreloader.vue';
import DataViewer from '../common/DataViewer.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DevicesRawDataView',
    components: {
        DataPreloader,
        DataViewer
    },
    computed: {
        ...mapGetters('DevicesRawData', [
            'periodDate',
            'selectedDevicesId',
            'isActiveRequestDeviceCoordinates',
            'deviceCoordinates',
            'moduleErrors'
        ]),

        isLoading() {
            return this.isActiveRequestDeviceCoordinates;
        },

        hasSelectedDevices() {
            return this.selectedDevicesId.length > 0;
        },

        hasParams() {
            let result = false;

            let { from, to } = this.periodDate;
            if (this.hasSelectedDevices && from && to) result = true;

            return result;
        },

        hasError() {
            this.moduleErrors.requestDeviceCoordinates !== undefined;
        },

        isEmpty() {
            let result = false;

            if (this.hasParams && !this.hasError && !this.isLoading && this.deviceCoordinates.length === 0)
                result = true;

            return result;
        }
    }
};
</script>

<style lang="sass">
.DevicesRawDataView
    position: relative
</style>
