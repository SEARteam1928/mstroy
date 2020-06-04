<template>
    <div class="DeviceItem-section DeviceItem-DeviceItemZone">
        <div class="DeviceItem-sectionHeader DeviceItem-headerDeviceItemZone">
            <div v-if="mobileMode" class="DeviceItem-sectionTitle">Текущая зона</div>
            <div class="DeviceItem-sectionValue">{{ zoneName }}</div>
        </div>
    </div>
</template>

<script>
import { mapGetters } from 'vuex';

export default {
    name: 'DeviceItemZone',
    props: {
        zone: {
            type: Object,
            required: true
        }
    },
    computed: {
        ...mapGetters('Devices', ['mobileMode']),

        zoneName() {
            return this.zone.object_name || this.defaultName;
        }
    },
    data() {
        return {
            defaultName: 'Вне зоны'
        };
    }
};
</script>

<style lang="sass">
.DeviceItem-section
    &.DeviceItem-DeviceItemZone
        .DeviceItem
            &-sectionHeader
                height: 100%
                flex-direction: row
                align-items: center
                padding-left: 0
            &-sectionValue
                // font-weight: normal
</style>
