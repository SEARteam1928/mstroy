<template>
    <div class="DeviceTopBar" :class="{ 'mobileMode': mobileMode }">
        <DeviceTopBarFilter class="DeviceTopBarFilter" />
        <DeviceTopBarLegend v-if="!mobileMode" class="DeviceTopBarLegend" />
    </div>
</template>

<script>
import DeviceTopBarFilter from './DeviceTopBar/DeviceTopBarFilter.vue';
import DeviceTopBarLegend from './DeviceTopBar/DeviceTopBarLegend.vue';

import { mapGetters } from 'vuex';

export default {
    name: 'DeviceTopBar',
    components: {
        DeviceTopBarFilter,
        DeviceTopBarLegend
    },
    computed: {
        ...mapGetters('Devices', ['mobileMode'])
    }
};
</script>

<style lang="sass">
.DeviceTopBar
    display: flex
    align-items: flex-end
    padding-bottom: 8px
    // Отступ справа, который соответствует отступу списка устройств под скроллбар
    margin-right: 16px
    .DeviceTopBarFilter
        min-width: 300px
        max-width: 300px
        flex-grow: 0
        margin-right: 10px
    .DeviceTopBarLegend
        flex-grow: 1
        // Отступ легенды справа, который соответствует размеру
        // кнопки дополнительных действий + паддинг справа у DeviceItem
        padding-right: 48px

    // Стили для мобильного режима
    &.mobileMode
        margin-left: 16px
        .DeviceTopBarFilter
            min-width: 100%
            max-width: 100%
        .DeviceTopBarLegend
            display: none
</style>
