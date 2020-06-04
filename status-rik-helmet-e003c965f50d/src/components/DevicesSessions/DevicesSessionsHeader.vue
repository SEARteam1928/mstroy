<template>
    <div class="DevicesSessionsHeader">
        <q-btn class="DevicesSessionsHeader-addDeviceBtn" unelevated label="+ Добавить устройство" color="ms-primary" />

        <q-btn
            class="DevicesSessionsHeader-giveDeviceBtn"
            unelevated
            outline
            label="Выдать устройство"
            color="ms-primary"
            @click="onGiveDeviceBtnClick"
        />

        <q-space />
        <!-- <q-btn class="DevicesSessionsHeader-filterDeviceBtn" outline label="Фильтр устройств" color="ms-primary" /> -->

        <DevicesSessionsFilter />
    </div>
</template>

<script>
import DevicesSessionsFilter from './DevicesSessionsFilter.vue';

import { mapMutations } from 'vuex';

export default {
    name: 'DevicesSessionsHeader',
    components: {
        DevicesSessionsFilter
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setGiveDeviceModalOpen']),

        onGiveDeviceBtnClick() {
            this.setGiveDeviceModalOpen(true);
        }
    }
};
</script>

<style lang="sass">
.DevicesSessionsHeader
    width: 100%
    padding: 8px 12px
    display: flex
    &-giveDeviceBtn
        margin-left: 16px
</style>
