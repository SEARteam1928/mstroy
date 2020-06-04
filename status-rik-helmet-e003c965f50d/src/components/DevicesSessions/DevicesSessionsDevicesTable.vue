<template>
    <div class="DevicesSessionsDevicesTable">
        <DevicesSessionsDevicesTableHeader />

        <q-separator class="DevicesSessionsDevicesTable-separator" />

        <DataPreloader :loading="devicesIsLoading" :error="false" :vertical="true">
            <q-scroll-area
                class="DevicesSessionsDevicesTable-scroll"
                :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
            >
                <DevicesSessionsDevicesTableRow
                    class="DevicesSessionsDevicesTableRow"
                    v-for="device in deviceListWithFilters"
                    :key="device.id"
                    :device="device"
                />
            </q-scroll-area>
        </DataPreloader>
    </div>
</template>

<script>
import DataPreloader from '../common/DataPreloader.vue';
import DevicesSessionsDevicesTableHeader from './DevicesSessionsDevicesTableHeader.vue';
import DevicesSessionsDevicesTableRow from './DevicesSessionsDevicesTableRow.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DevicesSessionsDevicesTable',
    components: {
        DataPreloader,
        DevicesSessionsDevicesTableHeader,
        DevicesSessionsDevicesTableRow
    },
    computed: {
        ...mapGetters('DevicesSessions', ['isActiveRequestAllDevices', 'allDevices', 'deviceListWithFilters']),

        devicesIsLoading() {
            return this.isActiveRequestAllDevices && this.allDevices.length === 0;
        }
    }
};
</script>

<style lang="sass">
.DevicesSessionsDevicesTable
    display: flex
    flex-direction: column
    position: relative
    height: 100%
    flex-grow: 1
    align-self: stretch
    overflow: hidden
    &-scroll
        height: 100%
        flex-grow: 1
        align-self: stretch
    &-separator
        max-height: 1px
</style>
