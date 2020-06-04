<template>
    <q-card-section class="DeviceEditModal-loraKeySection">
        <q-input outlined dense clearable label="LoraKey" min="0" v-model="loraKey" />
    </q-card-section>
</template>

<script>
import { mapGetters, mapMutations } from 'vuex';

export default {
    name: 'LoraKeySection',
    computed: {
        ...mapGetters('Devices', ['editModalData']),

        loraKey: {
            get() {
                return this.editModalData.loraKey;
            },
            set(loraKey) {
                loraKey = loraKey || null;

                this.setEditModalData({ loraKey });
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
    &-loraKeySection
        width: 100%
</style>
