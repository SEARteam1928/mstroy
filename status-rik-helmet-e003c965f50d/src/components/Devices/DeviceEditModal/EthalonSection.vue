<template>
    <div class="DeviceEditModal-ethalonSection">
        <q-checkbox v-model="ethalon" label="Эталонное устройство" />
    </div>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'EthalonSection',
    computed: {
        ...mapGetters('Devices', ['editModalData']),

        ethalon: {
            get() {
                return this.editModalData.ethalon;
            },
            set(ethalon) {
                this.setEditModalData({ ethalon });
            }
        }
    },
    methods: {
        ...mapMutations('Devices', ['setEditModalData'])
    }
};
</script>

<style lang="sass">
.DeviceEditModal
    &-ethalonSection
        width: 100%
        padding: 0 16px
</style>
