<template>
    <div class="DevicesSessionsActionsBlock">
        <BlockNotSelected class="BlockNotSelected" v-if="isNotSelected" />
        <BlockSingleSelected class="BlockSingleSelected" v-if="isSingleSelected" />
        <BlockMultiSelected class="BlockMultiSelected" v-if="isMultiSelected" />
    </div>
</template>

<script>
import BlockNotSelected from './DevicesSessionsActionsBlock/BlockNotSelected.vue';
import BlockSingleSelected from './DevicesSessionsActionsBlock/BlockSingleSelected.vue';
import BlockMultiSelected from './DevicesSessionsActionsBlock/BlockMultiSelected.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DevicesSessionsActionsBlock',
    components: {
        BlockNotSelected,
        BlockSingleSelected,
        BlockMultiSelected
    },
    computed: {
        ...mapGetters('DevicesSessions', ['selectedDevicesId']),

        isNotSelected() {
            return this.selectedDevicesId.length === 0;
        },
        isSingleSelected() {
            return this.selectedDevicesId.length === 1;
        },
        isMultiSelected() {
            return this.selectedDevicesId.length > 1;
        }
    }
};
</script>

<style lang="sass">
.DevicesSessionsActionsBlock
    height: 100%
</style>
