<template>
    <div class="BlockSingleSelected">
        <div class="BlockSingleSelected-title">
            Информация по устройству <strong class="BlockSingleSelected-titleName">"{{ selectedDeviceName }}"</strong>
        </div>

        <q-scroll-area
            class="BlockSingleSelected-scroll"
            :thumb-style="{ 'transition': 'top 100ms ease, opacity 300ms', 'background-color': 'var(--ms-dark)' }"
        >
            <BlockSingleSelectedMonitoring class="BlockSingleSelectedMonitoring" />
            <BlockSingleSelectedSessions class="BlockSingleSelectedSessions" />
            <BlockSingleSelectedRfid class="BlockSingleSelectedRfid" />
            <BlockSingleSelectedData class="BlockSingleSelectedData" />
        </q-scroll-area>
    </div>
</template>

<script>
import BlockSingleSelectedRfid from './BlockSingleSelectedRfid.vue';
import BlockSingleSelectedSessions from './BlockSingleSelectedSessions.vue';
import BlockSingleSelectedMonitoring from './BlockSingleSelectedMonitoring.vue';
import BlockSingleSelectedData from './BlockSingleSelectedData.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'BlockSingleSelected',
    components: {
        BlockSingleSelectedRfid,
        BlockSingleSelectedSessions,
        BlockSingleSelectedMonitoring,
        BlockSingleSelectedData
    },
    computed: {
        ...mapGetters('DevicesSessions', ['selectedDevicesId', 'getDeviceById']),

        selectedDevice() {
            let selectedDeviceId = this.selectedDevicesId[0];
            return this.getDeviceById(selectedDeviceId);
        },

        selectedDeviceName() {
            return this.selectedDevice && this.selectedDevice.name;
        }
    }
};
</script>

<style lang="sass">
.BlockSingleSelected
    color: var(--ms-dark)
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
    &-title
        padding: 8px 12px
        text-align: center
        font-size: 14px
        border-bottom: 1px solid var(--ms-grey)
    &-titleName
        font-size: 16px


    .BlockSingleSelectedSessions,
    .BlockSingleSelectedMonitoring,
    .BlockSingleSelectedRfid,
        border-bottom: 1px solid var(--ms-grey)
</style>
