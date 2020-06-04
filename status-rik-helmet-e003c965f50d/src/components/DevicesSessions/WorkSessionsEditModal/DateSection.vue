<template>
    <q-card-section class="WorkSessionsEditModal-dateSection">
        <PeriodDatepickerInput
            class="PeriodDatepickerInput"
            clickableInput
            clearable
            dense
            align="top middle"
            panel="range"
            label="Выбор даты"
            :from="startDate"
            :to="finishDate"
            @input="onInput"
            @reset="onReset"
        />
    </q-card-section>
</template>

<script>
import PeriodDatepickerInput from '@components/common/PeriodDatepickerInput.vue';

import { mapGetters, mapMutations, mapActions } from 'vuex';

export default {
    name: 'DateSection',
    components: {
        PeriodDatepickerInput
    },
    computed: {
        ...mapGetters('DevicesSessions', ['editSessionModalData']),

        startDate() {
            return this.editSessionModalData.startDate;
        },
        finishDate() {
            return this.editSessionModalData.finishDate;
        }
    },
    methods: {
        ...mapMutations('DevicesSessions', ['setEditSessionModalData']),

        onInput(prop) {
            let { from, to } = prop;

            this.setEditSessionModalData({
                startDate: from,
                finishDate: to
            });
        },
        onReset() {
            this.setEditSessionModalData({
                startDate: null,
                finishDate: null
            });
        }
    }
};
</script>

<style lang="sass">
.WorkSessionsEditModal
    &-dateSection
</style>
