<template>
    <q-card-section class="DeviceEditModal-assetsNumberSection">
        <q-input outlined dense clearable type="number" label="Инвентарный номер" v-model="assetsNumber" />
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'AssetsNumberSection',
    computed: {
        ...mapGetters('Devices', ['editModalData']),

        assetsNumber: {
            get() {
                return this.editModalData.assetsNumber;
            },
            set(assetsNumber) {
                let name = assetsNumber || null;
                let _assetsNumber = Math.abs(parseInt(assetsNumber));
                assetsNumber = isNaN(_assetsNumber) ? null : _assetsNumber;

                this.setEditModalData({ name, assetsNumber });
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
    &-assetsNumberSection
        width: 100%
</style>
