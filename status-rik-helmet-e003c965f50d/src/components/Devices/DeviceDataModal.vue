<template>
    <q-card class="DeviceDataModal column full-height full-width DeviceDataModal-card">
        <q-btn
            class="DeviceDataModal-close modal-close-btn close-red with-mobile no-radius-top-left no-radius-top-right no-radius-bottom-right"
            icon="close"
            flat
            :dense="$q.screen.lt.md"
            v-close-popup
        />
        <q-card-section class="DeviceDataModal-header">
            <div class="DeviceDataModal-headerName">Сырые данные с устройства {{ deviceName }}</div>
            <div class="DeviceDataModal-headerPeriod">{{ period }}</div>
        </q-card-section>

        <q-card-section class="DeviceDataModal-body">
            <div class="DeviceDataModal-codeWrap">
                <DataViewer class="DataViewer" :data="deviceRawData" :expandDepth="2" />
            </div>
        </q-card-section>
    </q-card>
</template>

<script>
import DataViewer from '../common/DataViewer.vue';

import { date as quasarDate } from 'quasar';
import { mapGetters } from 'vuex';

export default {
    name: 'DeviceDataModal',
    components: {
        DataViewer
    },
    computed: {
        ...mapGetters('Devices', ['dataModalData', 'getDevice']),

        deviceData() {
            let deviceData = {};

            let id = this.dataModalData.id;
            let data = this.getDevice(id);

            if (data) deviceData = data;

            return deviceData;
        },

        deviceRawData() {
            let rawData = {};
            if (this.deviceData && this.deviceData.rawData) rawData = this.deviceData.rawData;

            return rawData;
        },

        deviceName() {
            let name = '';
            if (this.dataModalData && this.dataModalData.name) {
                name = `"${this.dataModalData.name}"`;
            }
            return name;
        },

        period() {
            let period = '';
            if (this.deviceRawData && this.deviceRawData.coords && this.deviceRawData.coords.length) {
                let from = this.dataModalData.coords[0].timestamp;
                from = quasarDate.formatDate(new Date(from), 'DD.MM.YYYY HH:mm:ss');
                if (this.deviceRawData.coords.length === 1) {
                    period = `(${from})`;
                } else {
                    let to = this.deviceRawData.coords[this.deviceRawData.coords.length - 1].timestamp;
                    to = quasarDate.formatDate(new Date(to), 'DD.MM.YYYY HH:mm:ss');

                    period = `(${from} - ${to})`;
                }
            }

            return period;
        }
    }
};
</script>

<style lang="sass">
.DeviceDataModal
    position: relative
    display: flex
    flex-direction: column
    flex-wrap: nowrap
    &-close
        position: absolute
        top: 0
        right: 0
        z-index: 1
    &-header
        text-align: center
        font-weight: 600
        font-size: 16px
        line-height: 18px
        display: flex
        justify-content: center
        padding-right: 56px
        @media only screen and (max-width : 768px)
            flex-direction: column
            padding-right: 0
    &-headerName
    &-headerPeriod
        padding: 0 6px
    &-body
        display: flex
        flex-direction: column
        flex-grow: 1
        padding: 0
        margin: 0 16px 16px
        @media only screen and (max-width : 600px)
            margin: 0 2px 2px
    &-codeWrap
        display: flex
        flex-direction: column
        flex-grow: 1
        overflow: auto
        border-radius: 4px
        box-shadow: 0 1px 0 0 #aaa, 0 0 0 1px #aaa
    .DataViewer
        flex-grow: 1
</style>
