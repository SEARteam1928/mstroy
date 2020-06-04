<template>
    <q-page class="DevicesRawData-page page-background">
        <div class="DevicesRawData">
            <DevicesRawDataHeader class="DevicesRawDataHeader page-block" />

            <DevicesRawDataView class="DevicesRawDataView page-block" />
        </div>
    </q-page>
</template>

<script>
import DevicesRawDataHeader from '../components/DevicesRawData/DevicesRawDataHeader.vue';
import DevicesRawDataView from '../components/DevicesRawData/DevicesRawDataView.vue';

import withModuleErrors from '../mixins/withModuleErrors';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DevicesRawData',
    components: {
        DevicesRawDataHeader,
        DevicesRawDataView
    },
    mixins: [withModuleErrors('DevicesRawData')],
    computed: {
        ...mapGetters('DevicesRawData', ['periodDate', 'selectedDevicesId']),

        deviceListError() {
            return this.moduleErrors.requestDeviceCoordinates !== undefined;
        }
    },
    watch: {
        periodDate: {
            handler(newDate, oldDate) {
                let { from, to } = newDate;
                if (!from || !to) return;
                if (from === oldDate.from && to === oldDate.to) return;

                this.updateCoordinates();
            },
            deep: true
        }
    },
    created() {
        this.requestDeviceList();
    },
    beforeDestroy() {
        this.setPeriodDate({ from: null, to: null });
        this.clearDeviceList();
        this.clearDeviceListMap();
        this.clearSelectedDevicesId();
        this.clearDeviceCoordinates();
    },
    methods: {
        ...mapActions('DevicesRawData', ['requestDeviceList', 'requestDeviceCoordinates']),
        ...mapMutations('DevicesRawData', [
            'setPeriodDate',
            'clearDeviceList',
            'clearDeviceListMap',
            'clearSelectedDevicesId',
            'clearDeviceCoordinates'
        ]),

        updateCoordinates() {
            this.requestDeviceCoordinates();
        }
    }
};
</script>

<style lang="sass">
.DevicesRawData
    height: calc(100% - 16px)
    display: flex
    flex-direction: column
    max-width: calc(100% - 16px)
    margin:
        top: 8px
        right: 8px
        bottom: 8px
        left: 8px
    &-page
        overflow: hidden
        height: calc( 100vh - var(--header-height) )
        position: relative
    .DevicesRawDataHeader
        padding: 8px
    .DevicesRawDataView
        margin-top: 8px
        flex-grow: 1
</style>
